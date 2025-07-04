import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent {
  static SpriteAnimation? idleanimation;
  static SpriteAnimation? runAnimation;

  Player({super.position}) : super(size: Vector2(64, 64));

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('DinoSprites - doux.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(24, 24),
    );

    idleanimation = spriteSheet.createAnimation(row: 0, from: 0, to: 3, stepTime: 0.08);
    runAnimation = spriteSheet.createAnimation(row: 0, from: 4, to: 10, stepTime: 0.08);

    animation = runAnimation!;
  }
}
