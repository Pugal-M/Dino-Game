import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:myapp/game/back_ground.dart';
import 'package:myapp/game/game.dart';
import 'package:myapp/game/pause.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameWidget(game: BackgroundGame()),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(
                    fontFamily: 'BitcountGridDouble',
                    fontSize: 40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.greenAccent),
                  ),
                ),
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
                          'PauseButton': (context, game) {
                            final dinoGame = game as DinoGame;
                            return Positioned(
                              top: 20,
                              left: 20,
                              child: GestureDetector(
                                onTap: () {
                                  dinoGame.pauseEngine();
                                  dinoGame.overlays.remove('PauseButton');
                                  showDialog(
                                    context: context,
                                    builder: (context) => PauseDialog(
                                      onResume: () {
                                        dinoGame.resumeEngine();
                                        dinoGame.overlays.add('PauseButton');
                                      },
                                    ),
                                  ).then((_) {
                                    dinoGame.resumeEngine();
                                    dinoGame.overlays.add('PauseButton');
                                  });
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    border: Border.all(color: Colors.greenAccent),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.pause, color: Colors.greenAccent),
                                ),
                              ),
                            );
                          },
                        },
                        initialActiveOverlays: const ['PauseButton'],
                      ),
                    ),
                  );
                },
                child: const Text('Play'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
