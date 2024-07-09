import 'package:flutter/material.dart';
import 'package:super_elio/level_screen.dart';
import 'package:super_elio/setting_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SUPER ELIO text
              const Text(
                'Super      Elio',
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 1.5,
                      color: Colors.black45,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  letterSpacing: 1.0,
                  fontFamily:
                      'Arcade', // Add your custom font family if available
                ),
              ),
              const SizedBox(
                  height: 30), // Add space between the text and the button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LevelsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12, // Button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Button padding
                  textStyle: const TextStyle(fontSize: 24), // Button text style
                ),
                child: const Text(
                  'Start Game',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20), // Add space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12, // Button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Button padding
                  textStyle: const TextStyle(fontSize: 24), // Button text style
                ),
                child: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
