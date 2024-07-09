import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_elio/actors/elio.dart';
import 'package:super_elio/main.dart';
// ignore: depend_on_referenced_packages
import 'package:tiled/tiled.dart';

class Gem extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SuperElioGame> {
  final TiledObject tiledObject;
  Gem({required this.tiledObject}) : super() {
    debugMode = false;
  }

  @override
  Future<void>? onLoad() async {
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Elio) {
      gameRef.increaseMagic();
      gameRef.levelTime += 10; // Her gem toplandığında süreye 10 saniye ekle
      removeFromParent();
      gameRef.bonus.start();
    }

    super.onCollision(intersectionPoints, other);
  }
}
