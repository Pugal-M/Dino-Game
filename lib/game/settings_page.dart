import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sfxOn = true;
  bool bgmOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: const Text("SFX", style: TextStyle(color: Colors.white)),
            value: sfxOn,
            onChanged: (val) => setState(() => sfxOn = val),
          ),
          SwitchListTile(
            title: const Text("BGM", style: TextStyle(color: Colors.white)),
            value: bgmOn,
            onChanged: (val) => setState(() => bgmOn = val),
          ),
        ],
      ),
    );
  }
}
