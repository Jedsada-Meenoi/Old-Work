// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

Map<String, dynamic> userData =
    {}; // Default value to avoid errors when fetching data

class _UserInfoPageState extends State<UserInfoPage> {
  late SharedPreferences prefs;
  // List<dynamic> expeditions = []; // Initial expeditions list

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch user data when the page is initialized
  }

  void fetchUserData() async {
    prefs = await SharedPreferences.getInstance();
    var reqBody = {"uid": prefs.getString('uid')};

    var responseInfo = await http.post(
      Uri.parse('http://34.87.22.134:3000/fetchInfo'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var responseActInfo = await http.post(
      Uri.parse('http://34.87.22.134:3000/fetchAct'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    var resInfo = jsonDecode(responseInfo.body);
    var resActInfo = jsonDecode(responseActInfo.body);

    // Update the user data state with the response data
    setState(() {
      userData = {...resActInfo, ...resInfo};
      print(userData['expeditions'].runtimeType);
      // expeditions = userData['expeditions'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: userData.isNotEmpty &&
                  userData['phone_background_image_url'] != null
              ? DecorationImage(
                  image: NetworkImage(userData['phone_background_image_url']),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: userData.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Section

                    UserProfileBlock(
                      nickname: userData['nickname'],
                      level: userData['level'],
                      gameData: [
                        {'name': 'Time Active', 'value': '349'},
                        {'name': 'Characters Unlocked', 'value': '42'},
                        {'name': 'Achievements Unlocked', 'value': '460'},
                        {'name': 'Treasures Opened', 'value': '573'},
                        // Add more game data items as needed
                      ],
                    ),

                    // Expeditions Section
                    SizedBox(height: 24.0),

                    ExpeditionGroup(
                      expeditions: List<Map<String, dynamic>>.from(
                          userData['expeditions'] ?? []),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class UserProfileBlock extends StatelessWidget {
  final String nickname;
  final int level;
  final List<Map<String, String>> gameData;

  UserProfileBlock({
    required this.nickname,
    required this.level,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    String backgroundImageUrl =
        'https://upload-os-bbs.hoyolab.com/game_record/rpg_card.png'
        '?nickname=$nickname&level=$level';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(backgroundImageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            UserInfoCard(
              nickname: nickname,
              level: level,
              profileUrl: userData['cur_head_icon_url'],
            ),
            SizedBox(height: 24.0),
            Text(
              'Game Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            GameDataGroup(gameData: gameData),
          ],
        ),
      ),
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String nickname;
  final int level;
  final String profileUrl;

  UserInfoCard({
    required this.nickname,
    required this.level,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileUrl),
        ),
        title: Text(nickname),
        subtitle: Text('Level $level'),
      ),
    );
  }
}

class ExpeditionGroup extends StatelessWidget {
  final List<Map<String, dynamic>> expeditions;

  ExpeditionGroup({required this.expeditions});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assignments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: expeditions.map((dynamic expedition) {
                if (expedition is Map<String, dynamic>) {
                  String name = expedition['name'];
                  int remainingTime = expedition['remaining_time'];
                  String imageUrl = expedition['item_url'];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ExpeditionCard(
                      name: name,
                      remainingTime: remainingTime,
                      imageUrl: imageUrl,
                    ),
                  );
                } else {
                  // Handle unexpected item type
                  return Container(); // or alternative widget
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpeditionCard extends StatelessWidget {
  final String name;
  final int remainingTime;
  final String imageUrl;

  ExpeditionCard({
    required this.name,
    required this.remainingTime,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    String formattedRemainingTime = _formatRemainingTime(remainingTime);

    return ListTile(
      contentPadding: EdgeInsets.all(16),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        'Remaining Time: $formattedRemainingTime',
      ),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle onTap action, e.g., navigate to expedition details page
      },
    );
  }

  String _formatRemainingTime(int remainingTimeInSeconds) {
    Duration duration = Duration(seconds: remainingTimeInSeconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '$hours hours $minutes minutes';
  }
}

class GameDataGroup extends StatelessWidget {
  final List<Map<String, String>> gameData;

  GameDataGroup({required this.gameData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: gameData.map((data) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    data['value']!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
