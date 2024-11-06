// ignore_for_file: prefer_const_constructors, prefer_final_fields, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:startrack/structModel/newsEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

var parser = EmojiParser();

class NewsEvents extends StatefulWidget {
  @override
  _NewsEventsState createState() => _NewsEventsState();
}

class _NewsEventsState extends State<NewsEvents> {
  late List<NewsEvent> _newsData = [];
  late SharedPreferences prefs;

  List<String> _routes = [
    '/news',
    '/guides',
    '/database',
    '/user',
    '/calculator'
  ];

  void _onItemTapped(int index) {
    Navigator.pushNamed(context, _routes[index]);
    print(prefs.getString('email'));
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text('News & Events'),
            backgroundColor: Color.fromARGB(255, 197, 198, 202),
          ),
          body: Column(
            children: [
              // Events Section
              Expanded(
                child: Container(
                  color: Color.fromARGB(255, 57, 52, 56),
                  padding: EdgeInsets.all(16.0),
                  child: FutureBuilder<List<NewsEvent>>(
                    future: getEventsData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(
                          child: Text('No news events available.'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Color(0xFFEFEFEF),
                              child: ExpansionTile(
                                title: Text(
                                  parser.emojify(snapshot.data![index].title),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Details:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        Text(
                                          parser.emojify(snapshot
                                              .data![index].description),
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                        Image(
                                          image: NetworkImage(
                                              snapshot.data![index].banner),
                                          height: 400,
                                          width: 400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Guides',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Database',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.calculate), label: 'Calculator'),
              ],
              showUnselectedLabels: true,
              unselectedItemColor: Colors.grey,
              selectedItemColor:
                  Colors.blue, // Customize the selected item color
              onTap: _onItemTapped),
        ));
  }

  Future<List<NewsEvent>> getEventsData() async {
    final res = await http.get(
        Uri.parse('https://api.ennead.cc/starrail/news/events'),
        headers: {'Accept-Charset': 'utf-8'});
    var resBody = utf8.decode(res.bodyBytes);
    var data = jsonDecode(resBody);

    if (res.statusCode == 200) {
      for (Map<String, dynamic> event in data) {
        _newsData.add(NewsEvent.fromJson(event));
      }
      return _newsData
          .where((event) =>
              DateTime.now().millisecondsSinceEpoch ~/ 1000 < event.endAt)
          .toList();
    } else {
      throw Exception('Failed to load album');
    }
  }
}
