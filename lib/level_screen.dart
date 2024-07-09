import 'package:flutter/material.dart';
import 'package:super_elio/game_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73C8A9),
              Color(0xFF373B44),
            ],
          ),
        ),
        child: ListView(
          children: <Widget>[
            buildLevelTile(context, 'Level 1', 'Easy level', 1),
            buildLevelTile(context, 'Level 2', 'Medium level', 2),
            buildLevelTile(context, 'Level 3', 'Hard level', 3),
            // Diğer seviyeleri ekleyin
          ],
        ),
      ),
    );
  }

  Widget buildLevelTile(
      BuildContext context, String title, String subtitle, int level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: Colors.black.withOpacity(0.5), // Tile'ın arka plan saydamlığı
        child: ListTile(
          tileColor: Colors.transparent, // ListTile'ın arka plan rengi
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen(level: level)),
            );
          },
        ),
      ),
    );
  }
}
