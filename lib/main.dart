import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
// Your DinoGame file
import 'package:myapp/game/home_page.dart';
// Optional, if needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
