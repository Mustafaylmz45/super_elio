import 'package:flutter/material.dart';
import 'package:super_elio/audio_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF373B44),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 1.5,
                      color: Colors.black45,
                      offset: Offset(5.0, 5.0),
                    ),
                  ],
                  fontFamily: 'Arcade',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Music Volume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: AudioManager.instance.musicVolumeNotifier,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    onChanged: (newValue) {
                      AudioManager.instance.setMusicVolume(newValue);
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.yellowAccent,
                    inactiveColor: Colors.white30,
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Sound Effects Volume',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              ValueListenableBuilder<double>(
                valueListenable: AudioManager.instance.sfxVolumeNotifier,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    onChanged: (newValue) {
                      AudioManager.instance.setSfxVolume(newValue);
                    },
                    min: 0.0,
                    max: 1.0,
                    activeColor: Colors.yellowAccent,
                    inactiveColor: Colors.white30,
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black12,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
