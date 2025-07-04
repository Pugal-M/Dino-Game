import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:myapp/game/player.dart';

class DinoGame extends FlameGame {
  late SpriteAnimationComponent _dino;
  late ParallaxComponent _parallaxComponent;

  @override
  Future<void> onLoad() async {
    // ✅ Load parallax first so it appears **behind** the player
    _parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('plx-1.png'),
        // Add more layers if needed
      ]
    );
    add(_parallaxComponent); // 👈 add background before player

    // ✅ Load player animation
    final player = Player();
    await player.onLoad();

    _dino = SpriteAnimationComponent()
      ..animation = Player.runAnimation
      ..size = Vector2.all(80)
      ..position = Vector2(100, 200);

    add(_dino);
  }
}
