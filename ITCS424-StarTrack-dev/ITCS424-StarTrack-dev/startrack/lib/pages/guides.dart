import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TipsAndTricksScreen extends StatelessWidget {
  const TipsAndTricksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guides'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TipCard(
              title: 'Send your characters on Assignments',
              content:
                  'They will gather materials while you’re offline, and it only takes a minute to send them away.',
              seeMoreLink:
                  'https://honkai-star-rail.fandom.com/wiki/Assignments#:~:text=Assignments%20is%20a%20Game%20System,Wait%20for%20the%20Blade',
            ),
            const TipCard(
              title: 'Complete the Daily Mission',
              content:
                  'It’s short, and it’s a good way to get Daily Activity Point rewards.',
              seeMoreLink:
                  'https://honkai-star-rail.fandom.com/wiki/Daily_Mission',
            ),
            const TipCard(
              title: 'Do a Calyx challenge',
              content:
                  'If you’re in a hurry, choose an easy one, select the maximum number of waves, and press ‘2x speed’ and ‘auto-battle’.',
              seeMoreLink: 'https://honkai-star-rail.fandom.com/wiki/Calyx',
            ),
            const TipCard(
              title: 'Use and Replenish Technique',
              content:
                  'Always initiate a battle by using a character’s Technique ability (the Skill button). This will start the battle in your favor, as you can already harm an opponent or place a buff on your team. As you only get three Technique points, keep an eye out for purple containers between battles. Break them to replenish Technique.',
              seeMoreLink: 'https://honkai-star-rail.fandom.com/wiki/Technique',
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecondPage(),
                  ),
                );
              },
              child: const Text('Next Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String title;
  final String content;
  final String seeMoreLink;

  const TipCard({
    Key? key,
    required this.title,
    required this.content,
    required this.seeMoreLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(content),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                launchUrlStart(seeMoreLink);
              },
              child: const Text(
                'See More',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> launchUrlStart(String url) async {
  if (!await canLaunch(url)) {
    throw 'Could not launch $url';
  }
  await launch(url);
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guides'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TipCard(
              title: 'Beware of Building a 4-Star DPS',
              content:
                  'While 4-star supports often have unique abilities that make them useful to endgame players, 4-star DPS characters’ attacks will always be weaker than 5-stars due to their lower base stats. As a result, the 4-stars are usually cast aside whenever a 5-star joins the team.',
              seeMoreLink:
                  'https://www.ign.com/wikis/honkai-star-rail/All_Honkai_Star_Rail_Characters',
            ),
            TipCard(
              title: 'Don’t Miss Locked-On Targets',
              content:
                  'Sometimes, opponents will ‘lock-on’ to one of your characters. Whenever that happens, you’ll see a little red-glowing target icon above that character’s head. Beware, as it’s easy to overlook! Once an opponent has locked in their next attack, you already know which character they will hit, so you can take preventive measures to minimize the damage. As a new player, make sure that March 7th casts her shield on a locked-on ally.',
              seeMoreLink:
                  'https://www.ign.com/wikis/honkai-star-rail/Honkai_Star_Rail_Tips_and_Tricks',
            ),
            TipCard(
              title: 'Don’t Underestimate Speed',
              content:
                  'Sure, attack power, critical rate, and HP are important, but don’t overlook one of the most important stats in Honkai Star Rail: speed. In turn-based combat, being faster than your opponents means you get to attack more often. Furthermore, if your characters are the first to attack at the start of a battle, you can immediately gain the upper hand.',
              seeMoreLink: 'https://honkai-star-rail.fandom.com/wiki/Speed',
            ),
            TipCard(
              title: 'Check Your Opponents’ Statuses',
              content:
                  'If you press ‘Z’, or the opponent’s name at the top of the screen, you can see their Statuses and Abilities. This is very useful information to have, as it enables you to predict their next attack. Furthermore, you can see which status effects are active, what they do, and how long they last.',
              seeMoreLink:
                  'https://honkai-star-rail.fandom.com/wiki/Status_Effect',
            ),
          ],
        ),
      ),
    );
  }
}
