import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/game/game.dart';
import 'package:myapp/game/settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameWidget(
                      game: DinoGame(),
                      overlayBuilderMap: {
                        'GameOverOverlay': (context, game) {
                          final dinoGame = game as DinoGame;
                          return GameOverOverlay(
                            score: dinoGame.score,
                            highScore: dinoGame.highScore,
                            onRestart: () {
                              dinoGame.restartGame();
                              dinoGame.overlays.remove('GameOverOverlay');
                            },
                          );
                        },
                      },
                    ),
                  ),
                );
              },
              child: const Text('Play'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
