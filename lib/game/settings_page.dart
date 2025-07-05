// import 'package:flutter/material.dart';

// class SettingsDialog extends StatefulWidget {
//   const SettingsDialog({super.key});

//   @override
//   State<SettingsDialog> createState() => _SettingsDialogState();
// }

// class _SettingsDialogState extends State<SettingsDialog>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   bool isSfxEnabled = true;
//   bool isBgmEnabled = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 250),
//     )..forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void toggleSfx(bool value) {
//     setState(() {
//       isSfxEnabled = value;
//     });
//     // Save to SharedPreferences or update state
//   }

//   void toggleBgm(bool value) {
//     setState(() {
//       isBgmEnabled = value;
//     });
//     // Save to SharedPreferences or update state
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ScaleTransition(
//         scale: CurvedAnimation(
//           parent: _controller,
//           curve: Curves.easeOutBack,
//         ),
//         child: AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           backgroundColor: const Color.fromARGB(255, 0, 75, 105),
//           title: const Text(
//             'Settings',
//             style: TextStyle(color: Colors.white,fontFamily: 'BitcountGridDouble'),

//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SwitchListTile(
//                 value: isSfxEnabled,
//                 onChanged: toggleSfx,
//                 title: const Text('SFX',
//                     style: TextStyle(color: Colors.white,fontFamily: 'BitcountGridDouble'),),
//               ),
//               SwitchListTile(
//                 value: isBgmEnabled,
//                 onChanged: toggleBgm,
//                 title: const Text('BGM',
//                     style: TextStyle(color: Colors.white,fontFamily: 'BitcountGridDouble')),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close', style: TextStyle(color: Colors.white,fontFamily: 'BitcountGridDouble')),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
