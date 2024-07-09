import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:super_elio/level_screen.dart';
import 'package:super_elio/main.dart';
import 'package:super_elio/main_menu.dart';

class GameScreen extends StatelessWidget {
  final int level;

  const GameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final game = SuperElioGame(level: level, context: context);

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            bottom: 340,
            left: 540,
            child: ValueListenableBuilder(
              valueListenable: game.timeNotifier,
              builder: (context, value, child) {
                return Text(
                  'TIME: ${game.levelTime.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontFamily: 'Arcade',
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 340,
            left: 240,
            child: ValueListenableBuilder(
              valueListenable: game.magicNotifier,
              builder: (context, value, child) {
                return Text(
                  'MAGIC: $value',
                  style: const TextStyle(
                      fontSize: 26, color: Colors.black, fontFamily: 'Arcade'),
                );
              },
            ),
          ),
          Positioned(
              bottom: 355,
              left: 380,
              child: Row(
                children: [
                  Text(
                    'LEVEL $level',
                    style: const TextStyle(
                        fontSize: 34,
                        color: Colors.black,
                        fontFamily: 'Arcade'),
                  )
                ],
              )),
          Positioned(
            bottom: 50,
            left: 50,
            child: Row(
              children: [
                GestureDetector(
                  onTapDown: (_) => game.startMoveLeft(),
                  onTapUp: (_) => game.stopMove(),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(
                        Icons.arrow_left,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                GestureDetector(
                  onTapDown: (_) => game.startMoveRight(),
                  onTapUp: (_) => game.stopMove(),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            right: 50,
            child: GestureDetector(
              onTapDown: (_) => game.jump(),
              child: SizedBox(
                width: 80,
                height: 80,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    content: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              game.setGameEnded(true);
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainMenu()),
                              );
                            },
                            child: const Text(
                              'Main Menu',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              game.setGameEnded(true);
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LevelsScreen()),
                              );
                            },
                            child: const Text(
                              'Level Screen',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: const Text(
                    'Menu',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
