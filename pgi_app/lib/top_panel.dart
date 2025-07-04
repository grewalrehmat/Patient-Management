import 'package:flutter/material.dart';

class TopPanel extends StatelessWidget implements PreferredSizeWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= 800;
    final double height = isMobile ? 80 : 100;

    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        toolbarHeight: height,
        titleSpacing: 20,
        title: Text(
          'MedVault-RS 👨‍⚕️',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 22 : 26,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: isMobile ? 26 : 30,
            ),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black,
                radius: isMobile ? 18 : 22,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(100);
  }
}
