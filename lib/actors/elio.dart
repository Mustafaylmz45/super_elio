import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_elio/main.dart';
import 'package:super_elio/world/ground.dart';

class Elio extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SuperElioGame> {
  // ignore: use_super_parameters
  Elio({required position}) : super(position: position) {
    debugMode = false;
    size = Vector2(41.5, 50);
    anchor = Anchor.bottomCenter;
  }
  bool onGround = false;
  bool facingRight = true;
  bool hitRight = false;
  bool hitLeft = false;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(
        size: Vector2(width * .6, height), position: Vector2(10, 0)));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.velocity.x != 0) {
      gameRef.velocity.x -= gameRef.velocity.x.sign * gameRef.groundFriction;
      if (gameRef.velocity.x.abs() < gameRef.groundFriction) {
        gameRef.velocity.x = 0;
      }
    }

    if (x > 0 && gameRef.velocity.x <= 0) {
      gameRef.velocity.x += gameRef.groundFriction;

      if (gameRef.velocity.x > 0) {
        gameRef.velocity.x = 0;
      }
    } else if (gameRef.velocity.x >= 0) {
      // moving to the right
      gameRef.velocity.x -= gameRef.groundFriction;
      // print('${gameRef.velocity.x}, ${gameRef.groundFriction}');
      if (gameRef.velocity.x < 0) {
        gameRef.velocity.x = 0;
      }
    } else {
      gameRef.velocity.x = 0;
    }

    if (gameRef.velocity.x == 0 && onGround) {
      animation = gameRef.idleAnim;
    }
  }

  @override
  void onCollision(intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ground) {
      if (gameRef.velocity.y > 0) {
        if (intersectionPoints.length == 2) {
          var x1 = intersectionPoints.first[0];
          var x2 = intersectionPoints.last[0];
          if ((x1 - x2).abs() < 10) {
            gameRef.velocity.y = 100;
          } else {
            gameRef.velocity.y = 0;
            onGround = true;
          }
        }
      }
      if (gameRef.velocity.x != 0) {
        for (var point in intersectionPoints) {
          if (y - 5 >= point[1]) {
            gameRef.velocity.x = 0;
            if (point[0] > x) {
              hitRight = true;
              hitLeft = false;
            } else {
              hitLeft = true;
              hitRight = false;
            }
          }
        }
      }
    }
  }

  @override
  void onCollisionEnd(other) {
    super.onCollisionEnd(other);
    onGround = false;
    hitLeft = false;
    hitRight = false;
  }
}
