import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.person, size: 50, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dr. Yuvraj Malik',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Cardiologist | PGI Hospital',
                  style: TextStyle(fontSize: 14, color: Colors.white60),
                ),
                const Divider(height: 32, color: Colors.white12),

                _infoTile(Icons.email, 'Email', 'yuvraj.malik@medvault.rs'),
                _infoTile(Icons.phone, 'Phone', '+91 98765 43210'),
                _infoTile(Icons.badge, 'Role', 'Doctor'),

                const Divider(height: 32, color: Colors.white12),
                _activityLogSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.white60),
      title: Text(label, style: const TextStyle(color: Colors.white70)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _activityLogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Log',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _logItem('Scanned Report - Chest X-Ray', '22 June 2025, 10:45 AM'),
        _logItem('Viewed Profile', '21 June 2025, 6:00 PM'),
        _logItem('Logged in', '21 June 2025, 5:58 PM'),
      ],
    );
  }

  Widget _logItem(String action, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history, color: Colors.white54),
      title: Text(action, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        time,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}
