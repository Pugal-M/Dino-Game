import 'package:flutter/material.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onResume;

  const PauseDialog({super.key, required this.onResume});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Paused',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'BitcountGridDouble',
        ),
      ),
      content: const Text(
        'Game is paused.',
        style: TextStyle(
          color: Colors.white70,
          fontFamily: 'BitcountGridDouble',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onResume(); // callback to resume the game
          },
          child: const Text(
            'Resume',
            style: TextStyle(
              color: Colors.greenAccent,
              fontFamily: 'BitcountGridDouble',
            ),
          ),
        ),
      ],
    );
  }
}
