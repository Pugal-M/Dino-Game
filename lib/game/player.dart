import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent {
  static late final SpriteAnimation runAnimation;
  static late final SpriteAnimation hitAnimation;
  static bool _loaded = false;

  double verticalVelocity = 0.0;
  bool isJumping = false;
  bool isHit = false;

  Player({super.position})
      : super(size: Vector2.all(64), anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    if (!_loaded) {
      final image = Flame.images.fromCache('DinoSprites - doux.png');
      final sheet = SpriteSheet(image: image, srcSize: Vector2(24, 24));
      runAnimation = sheet.createAnimation(row: 0, from: 4, to: 10, stepTime: 0.08);
      hitAnimation = sheet.createAnimation(row: 0, from: 14, to: 16, stepTime: 0.08);
      _loaded = true;
    }
    animation = runAnimation;
  }

  void run() {
    if (!isHit) animation = runAnimation;
  }

  void hit() {
    if (!isHit) {
      isHit = true;
      animation = hitAnimation;

      Future.delayed(const Duration(seconds: 1), () {
        isHit = false;
        animation = runAnimation;
      });
    }
  }

  void jump(double jumpSpeed) {
    if (!isJumping && !isHit) {
      verticalVelocity = -jumpSpeed; // negative to move upward
      isJumping = true;
    }
  }

  // ✅ Updated to use delta time
  void applyGravity(double gravity, double groundY, double dt) {
    if (!isHit) {
      y += verticalVelocity * dt;
      verticalVelocity += gravity * dt;

      if (y >= groundY) {
        y = groundY;
        verticalVelocity = 0;
        isJumping = false;
      }
    }
  }
}
