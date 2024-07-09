import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ground extends PositionComponent {
  // ignore: use_super_parameters
  Ground({required size, required position})
      : super(size: size, position: position) {
    debugMode = false;
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }
}
