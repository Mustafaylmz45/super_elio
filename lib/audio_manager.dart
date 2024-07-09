import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class AudioManager {
  AudioManager._privateConstructor();

  static final AudioManager instance = AudioManager._privateConstructor();

  final ValueNotifier<double> musicVolumeNotifier = ValueNotifier<double>(0.5);
  final ValueNotifier<double> sfxVolumeNotifier = ValueNotifier<double>(0.5);

  void setMusicVolume(double volume) {
    musicVolumeNotifier.value = volume;
    // Arka plan müziğinin ses seviyesini güncelle
    if (FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.stop();
      FlameAudio.bgm.play('back_audio.wav', volume: volume);
    }
  }

  void setSfxVolume(double volume) {
    sfxVolumeNotifier.value = volume;
    // SFX ses seviyesini güncellemek için ek işlemler yapılabilir
  }

  // Arka plan müziğini oynatma fonksiyonu
  void playBackgroundMusic(String fileName) {
    FlameAudio.bgm.play(fileName, volume: musicVolumeNotifier.value);
  }

  // Ses efektlerini oynatma fonksiyonu
  void playSoundEffect(String fileName) {
    FlameAudio.play(fileName, volume: sfxVolumeNotifier.value);
  }
}
