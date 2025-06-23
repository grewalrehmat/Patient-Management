import 'package:flutter/material.dart';

class PseudoPage extends StatelessWidget {
  const PseudoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: isWideScreen
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text(
                'Pseudo',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
      body: const Center(
        child: Text(
          'Pseudo Page (Coming Soon)',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}
