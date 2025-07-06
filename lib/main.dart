import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
// Your DinoGame file
import 'package:myapp/game/home_page.dart';
// Optional, if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  await FlameAudio.audioCache.load('bg.wav'); // preload bgm
  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('bg.wav', volume: 0.6); // start bgm
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
