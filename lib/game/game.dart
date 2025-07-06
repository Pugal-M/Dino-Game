import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myapp/game/enemy.dart';
import 'package:myapp/game/player.dart';
import 'constants.dart';

enum GameState { playing, paused, gameOver }

class DinoGame extends FlameGame
    with TapDetector, HasGameRef<DinoGame>, HasKeyboardHandlerComponents, WidgetsBindingObserver {
  Player? _player;
  final List<Enemy> _enemies = [];
  final Random _random = Random();

  late double groundY;
  late TextComponent _scoreText;
  TextComponent? _highScoreText;

  int score = 0;
  int highScore = 0;

  double _enemySpawnTimer = 0.0;
  double _currentSpawnInterval = 2.5;
  final double _spawnInterval = 2.5;

  double _baseEnemySpeed = 100;
  int _nextDifficultyScore = 2000;

  GameState _gameState = GameState.playing;

  final double jumpSpeed = 650;
  final double gravity = 1000;

  late final HudButtonComponent _pauseButton;

  @override
  bool isLoaded = false;

  @override
  Future<void> onLoad() async {
    FlameAudio.audioCache.loadAll(['jump.wav', 'hit.wav']);

    await images.loadAll([
      'parallex/plx-1.png',
      'parallex/plx-2.png',
      'parallex/plx-3.png',
      'parallex/plx-4.png',
      'parallex/plx-5.png',
      'parallex/plx-6.png',
      'DinoSprites - doux.png',
      'enemy/pig.png',
      'enemy/bat.png',
      'enemy/rino.png'
    ]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;

    final parallax = Parallax([
      for (int i = 1; i <= 5; i++)
        ParallaxLayer(
          ParallaxImage(images.fromCache('parallex/plx-$i.png')),
          velocityMultiplier: Vector2(3.5 * (1.0 + i * 0.2), 1.0),
        ),
      ParallaxLayer(
        ParallaxImage(images.fromCache('parallex/plx-6.png'),
            fill: LayerFill.none, repeat: ImageRepeat.repeatX),
        velocityMultiplier: Vector2(3.5 * 2.0, 1.0),
      ),
    ], baseVelocity: Vector2(20, 0));
    add(ParallaxComponent(parallax: parallax));

    _scoreText = TextComponent(
      text: '0',
      position: Vector2(size.x / 2, 10),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFFFFFFF),
          fontFamily: 'BitcountGridDouble',
        ),
      ),
    );
    add(_scoreText);

    _highScoreText = TextComponent(
      text: 'High: $highScore',
      anchor: Anchor.topRight,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 20, color: Color(0x88FFFFFF), fontFamily: 'BitcountGridDouble'),
      ),
    );
    add(_highScoreText!);
    if (size.x > 0) {
      _highScoreText!.position = Vector2(size.x - 10, 10);
    }

    _player = Player();
    await add(_player!);

    _pauseButton = HudButtonComponent(
      button: RectangleComponent(
        size: Vector2(40, 40),
        paint: BasicPalette.white.withAlpha(50).paint(),
        children: [],
      ),
      position: Vector2(10, 10),
      onPressed: () {
        _gameState = _gameState == GameState.paused ? GameState.playing : GameState.paused;
      },
    );
    add(_pauseButton);

    WidgetsBinding.instance.addObserver(this);
    isLoaded = true;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (_gameState == GameState.playing && _player != null) {
      _player!.jump(jumpSpeed);
      FlameAudio.play('jump.wav');
    } else if (_gameState == GameState.gameOver) {
      restartGame();
      overlays.remove('GameOverOverlay');
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    final tileSize = canvasSize.x / numberOfTilesAlongWidth;
    groundY = canvasSize.y - groundHeight - tileSize + dinoTopBottomSpacing;

    if (_player != null) {
      _player!
        ..width = tileSize
        ..height = tileSize
        ..x = 200
        ..y = groundY;
    }

    if (_highScoreText != null) {
      _highScoreText!.position = Vector2(canvasSize.x - 10, 10);
    }

    if (isLoaded) {
      _pauseButton.position = Vector2(10, 10);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _gameState = GameState.paused;
    } else if (state == AppLifecycleState.detached) {
      pauseEngine();
    }
  }

  void spawnEnemy() {
    if (_enemies.length >= 3 || _gameState != GameState.playing) return;

    final tileSize = size.x / numberOfTilesAlongWidth;

    final List<EnemyType> enemyPool = [
      EnemyType.AngryPig,
      EnemyType.Bat,
      EnemyType.Rino,
    ];

    final randomType = enemyPool[_random.nextInt(enemyPool.length)];
    final enemy = Enemy(randomType)..speed = _baseEnemySpeed;

    switch (randomType) {
      case EnemyType.AngryPig:
        enemy.size = Vector2(tileSize, tileSize * 0.8);
        break;
      case EnemyType.Bat:
        enemy.size = Vector2(tileSize * 1.2, tileSize * 0.8);
        break;
      case EnemyType.Rino:
        enemy.size = Vector2(tileSize * 1.4, tileSize * 1.0);
        break;
    }

    final spawnX = size.x + _random.nextDouble() * size.x;
    final y = (randomType == EnemyType.Bat)
        ? groundY - tileSize * 1.5
        : groundY;

    enemy
      ..anchor = Anchor.bottomLeft
      ..position = Vector2(spawnX, y + 60);

    add(enemy);
    _enemies.add(enemy);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameState == GameState.paused) return;

    final slowmo = _gameState == GameState.gameOver ? 0.1 : 1.0;
    final adjustedDt = dt * slowmo;

    if (_player != null && _gameState == GameState.playing) {
      _player!.applyGravity(gravity, groundY, adjustedDt);
      _player!.update(adjustedDt);
    }

    if (_gameState != GameState.gameOver) {
      for (final enemy in _enemies) {
        enemy.update(adjustedDt);
        enemy.x -= enemy.speed * adjustedDt;
      }
    }

    if (_gameState != GameState.playing) return;

    score += (60 * dt).toInt();
    _scoreText.text = score.toString();

    _enemySpawnTimer += dt;
    if (_enemySpawnTimer >= _currentSpawnInterval) {
      spawnEnemy();
      _enemySpawnTimer = 0.0;
    }

    final List<Enemy> toRemove = [];
    for (final enemy in _enemies) {
      if (enemy.x < -enemy.width) {
        enemy.removeFromParent();
        toRemove.add(enemy);
      }
    }
    _enemies.removeWhere((e) => toRemove.contains(e));

    if (score >= _nextDifficultyScore) {
      _baseEnemySpeed += 20;
      _currentSpawnInterval = (_currentSpawnInterval - 0.2).clamp(1.5, _spawnInterval);
      _nextDifficultyScore += 2000;
    }

    for (final enemy in _enemies) {
      if (_player != null && !_player!.isHit) {
        final playerRect = _player!.toRect().deflate(10);
        final enemyRect = enemy.toRect().deflate(10);
        if (enemyRect.overlaps(playerRect)) {
          _player!.hit();
          FlameAudio.play('hit.wav');
          _gameState = GameState.gameOver;

          if (score > highScore) {
            highScore = score;
            _highScoreText?.text = 'High: $highScore';
            SharedPreferences.getInstance().then(
                (prefs) => prefs.setInt('highScore', highScore));
          }

          Future.microtask(() {
            for (final enemy in _enemies) {
              enemy.removeFromParent();
            }
            _enemies.clear();

            _player?.removeFromParent();
            _player = null;

            overlays.add('GameOverOverlay');
          });

          break;
        }
      }
    }
  }

  void restartGame() {
    final tileSize = size.x / numberOfTilesAlongWidth;

    score = 0;
    _scoreText.text = '0';
    _baseEnemySpeed = 100;
    _nextDifficultyScore = 2000;
    _currentSpawnInterval = _spawnInterval;
    _gameState = GameState.playing;

    for (var e in _enemies) {
      e.removeFromParent();
    }
    _enemies.clear();

    _player = Player();
    add(_player!);

    _player?.isHit = false;
    _player?.run();

    _player?.width = tileSize;
    _player?.height = tileSize;
    _player?.x = 200;
    _player?.y = groundY;
  }

  @override
  void onDetach() {
    WidgetsBinding.instance.removeObserver(this);
    pauseEngine();
    super.onDetach();
  }
}


class GameOverOverlay extends StatelessWidget {
  final int score;
  final int highScore;
  final VoidCallback onRestart;

  const GameOverOverlay({
    super.key,
    required this.score,
    required this.highScore,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ModalBarrier(
          dismissible: false,
          color: Colors.black54,
        ),
        Center(
          child: Container(
            width: 350,
            height: 260,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Over',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'BitcountGridDouble',
                        decoration: TextDecoration.none)),
                const SizedBox(height: 12),
                Text('Score: $score',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'BitcountGridDouble',
                        decoration: TextDecoration.none)),
                const SizedBox(height: 4),
                Text('High Score: $highScore',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontFamily: 'BitcountGridDouble',
                        decoration: TextDecoration.none)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        textStyle: const TextStyle(
                          fontFamily: 'BitcountGridDouble',
                          fontSize: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.greenAccent),
                        ),
                      ),
                      onPressed: onRestart,
                      child: const Text('Restart', style: TextStyle(fontFamily: 'BitcountGridDouble')),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.greenAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        textStyle: const TextStyle(
                          fontFamily: 'BitcountGridDouble',
                          fontSize: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.greenAccent),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: const Text('Home', style: TextStyle(fontFamily: 'BitcountGridDouble')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

