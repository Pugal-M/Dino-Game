import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

class BackgroundGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'parallex/plx-1.png',
      'parallex/plx-2.png',
      'parallex/plx-3.png',
      'parallex/plx-4.png',
      'parallex/plx-5.png',
    ]);

    final parallax = await loadParallax([
      for (int i = 1; i <= 5; i++)
        ParallaxImageData('parallex/plx-$i.png'),
    ], baseVelocity: Vector2(20, 0), velocityMultiplierDelta: Vector2(1, 0.03));

    add(ParallaxComponent(parallax: parallax));
  }
}
