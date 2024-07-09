import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flame_tiled/flame_tiled.dart' hide Text;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_elio/actors/elio.dart';
import 'package:super_elio/actors/gem.dart';
import 'package:super_elio/game_screen.dart';
import 'package:super_elio/main_menu.dart';
import 'package:super_elio/world/ground.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  runApp(MaterialApp(
    title: 'Super ELIO',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const MainMenu(),
  ));
}

class SuperElioGame extends FlameGame with HasCollisionDetection, TapDetector {
  final int level;
  final BuildContext context;

  SuperElioGame({required this.level, required this.context});

  Elio elio = Elio(position: Vector2(250, 100));
  double gravity = 3.8;
  final double pushSpeed = 100;
  final double groundFriction = 4;
  final double jumpForce = 130;
  Vector2 velocity = Vector2(0, 0);
  late TiledComponent homeMap;
  late SpriteAnimation rideAnim;
  late SpriteAnimation pushAnim;
  late SpriteAnimation idleAnim;
  late SpriteAnimation jumpAnim;

  late double mapWidth;
  late AudioPool yay;
  late AudioPool bonus;

  bool isMovingRight = false;
  bool isMovingLeft = false;
  bool isJumping = false;
  double fallspeed = 2.5;
  bool gameEnded = false;
  int magic = 0;
  final ValueNotifier<int> magicNotifier = ValueNotifier<int>(0);
  double levelTime = 20.0; // her seviye için 60 saniye süre
  final ValueNotifier<double> timeNotifier = ValueNotifier<double>(20.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    bonus = await AudioPool.createFromAsset(
      path: 'audio/sfx/bonus.wav',
      maxPlayers: 1,
    );
    yay = await AudioPool.createFromAsset(
      path: 'audio/sfx/yay.mp3',
      maxPlayers: 1,
    );

    await loadLevel(level);
  }

  Future<void> loadLevel(int level) async {
    homeMap = await TiledComponent.load('map_0$level.tmx', Vector2.all(32));

    var obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');

    for (final obj in obstacleGroup!.objects) {
      homeMap.add(Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y)));
    }
    var gemGroup = homeMap.tileMap.getLayer<ObjectGroup>('gems');

    for (final gem in gemGroup!.objects) {
      homeMap.add(Gem(tiledObject: gem)
        ..sprite = await loadSprite('gems/GoldenIngot.png')
        ..position = Vector2(gem.x, gem.y - gem.height)
        ..size = Vector2(gem.width, gem.height));
    }

    mapWidth = 32.0 * homeMap.tileMap.map.width;

    final world = World(children: [homeMap, elio]);
    await add(world);
    // ignore: use_build_context_synchronously
    final screenSize = MediaQuery.of(context).size;
    final camera = CameraComponent.withFixedResolution(
      width: screenSize.width,
      height: screenSize.height,
      world: world,
    );

    await add(camera);
    camera.moveTo(Vector2(screenSize.width / 2, screenSize.height / 2));

    rideAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('ride.png', 'ride.json'),
        stepTime: 0.1);
    pushAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('push.png', 'push.json'),
        stepTime: 0.1);
    idleAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('idle.png', 'idle.json'),
        stepTime: 0.1);
    jumpAnim = SpriteAnimation.spriteList(
        await fromJSONAtlas('jump.png', 'jump.json'),
        stepTime: 0.1);

    elio.animation = rideAnim;
    world.add(elio);
    camera.follow(elio);

    // Ortak oyun varlıklarını yükleyin
    // await add(SpriteComponent.fromImage(...));

    // Seviyeye özgü varlıkları yükleyin
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!gameEnded) {
      levelTime -= dt;

      if (levelTime <= 0) {
        // Süre dolunca oyunu sonlandır
        endGameTimeOut();
      }
      timeNotifier.value = levelTime;
      if (!elio.onGround) {
        velocity.y += gravity * fallspeed;
      }
      elio.position += velocity * dt;

      if (isMovingRight && !elio.hitRight) {
        startMoveRight();
      }

      if (isMovingLeft && !elio.hitLeft) {
        startMoveLeft();
      }

      // Harita sınırlarını kontrol et
      checkMapBounds();
    }
  }

  void checkMapBounds() {
    // Karakterin haritanın sınırlarını geçip geçmediğini kontrol et
    if (elio.x < 0 || elio.y > homeMap.size.y || elio.y < 0) {
      yay.start();
      endGame();
    } else if (elio.x > homeMap.size.x) {
      gameEnded = true;
      completeLevel();
    }
  }

  void completeLevel() {
    gameEnded = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('SUPER'),
        content: const Text('You have completed the section. Congratulations'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(level: level + 1)),
              );
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  void startMoveLeft() {
    isMovingLeft = true;
    if (elio.facingRight) {
      elio.flipHorizontallyAroundCenter();
      elio.facingRight = false;
    }
    if (!elio.hitLeft) {
      velocity.x = -pushSpeed * 1.5;
      elio.animation = pushAnim;
      Future.delayed(const Duration(milliseconds: 500), () {
        elio.animation = rideAnim;
      });
    }
  }

  void startMoveRight() {
    isMovingRight = true;
    if (!elio.facingRight) {
      elio.facingRight = true;
      elio.flipHorizontallyAroundCenter();
    }
    if (!elio.hitRight) {
      velocity.x = pushSpeed * 1.5;
      elio.animation = pushAnim;
      Future.delayed(const Duration(milliseconds: 500), () {
        elio.animation = rideAnim;
      });
    }
  }

  void stopMove() {
    isMovingLeft = false;
    isMovingRight = false;
    elio.animation = rideAnim;
  }

  void jump() {
    if (elio.onGround && !isJumping) {
      isJumping = true;
      elio.animation = jumpAnim;
      Future.delayed(const Duration(milliseconds: 500), () {
        elio.animation = rideAnim;
        isJumping = false;
      });
      elio.y -= 40;
      velocity.y = -jumpForce * 1.5;
      elio.onGround = false;
    }
  }

  void endGame() {
    gameEnded = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You went out of bounds!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              gameEnded = true;
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
              );
            },
            child: const Text('Main Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(level: level)),
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void endGameTimeOut() {
    gameEnded = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Time Out'),
        content: const Text('Your time is up!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              gameEnded = true;
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainMenu()),
              );
            },
            child: const Text('Main Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(level: level)),
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void restartGame() {
    gameEnded = true;
    Navigator.of(context).pop();
    // Oyunu yeniden başlatmak için gerekli işlemleri yapabilirsiniz
    // Örneğin, karakterin başlangıç pozisyonunu ve diğer başlangıç değerlerini ayarlayabilirsiniz
    elio.position = Vector2(200, 50);
    velocity = Vector2.zero();
    elio.animation = rideAnim;
  }

  void increaseMagic() {
    magic += 1; // Magic değerini artırın
    magicNotifier.value =
        magic; // Ekranda magic değerini güncellemek için notifier'i kullanın
  }

  void setGameEnded(bool value) {
    gameEnded = value;
    // Değişiklikleri dinleyen widget'ları güncelle
  }

  void resetGame() {
    levelTime = 0; // Süreyi sıfırla
    timeNotifier.value = levelTime; // Süreyi güncelle
    velocity = Vector2.zero(); // Hızı sıfırla
    isMovingRight = false;
    isMovingLeft = false;
    elio.hitRight = false;
    elio.hitLeft = false;
    elio.onGround = true;
  }
}
