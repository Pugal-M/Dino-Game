import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

enum EnemyType { AngryPig, Bat, Rino }

class EnemyData {
  final String imgName;
  final Vector2 srcSize;
  EnemyData({required this.imgName, required this.srcSize});
}

class Enemy extends SpriteAnimationComponent {
  final EnemyType enemyType;
  double speed = 100;

  static final Map<EnemyType, EnemyData> enemyData = {
    EnemyType.AngryPig: EnemyData(
      imgName: 'enemy/pig.png',
      srcSize: Vector2(36, 30), // width x height of 1 frame
    ),
    EnemyType.Bat: EnemyData(
      imgName: 'enemy/bat.png',
      srcSize: Vector2(46, 30),
    ),
    EnemyType.Rino: EnemyData(
      imgName: 'enemy/rino.png',
      srcSize: Vector2(52, 34),
    ),
  };

  Enemy(this.enemyType) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    final info = enemyData[enemyType]!;
    final image = Flame.images.fromCache(info.imgName);

    final sheet = SpriteSheet(
      image: image,
      srcSize: info.srcSize,
    );

    animation = sheet.createAnimation(
      row: 0,
      from: 0,
      to: (image.width / info.srcSize.x).floor(),
      stepTime: 0.1,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;
  }
}
