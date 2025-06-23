import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              //  Change Password
              ExpansionTile(
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                collapsedBackgroundColor: Colors.white10,
                backgroundColor: Colors.white10,
                leading: const Icon(Icons.lock, color: Colors.white),
                title: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "To change your password, visit the security settings or contact the admin if you've forgotten it.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              //  Privacy Policy
              ExpansionTile(
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                collapsedBackgroundColor: Colors.white10,
                backgroundColor: Colors.white10,
                leading: const Icon(Icons.shield, color: Colors.white),
                title: const Text(
                  "Privacy Policy",
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "We value your privacy. All medical data is encrypted and stored securely with restricted access.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              //  About
              ExpansionTile(
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                collapsedBackgroundColor: Colors.white10,
                backgroundColor: Colors.white10,
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  "About MedVault-RS",
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "MedVault-RS is a secure medical records system designed for PGI Hospital by Yuvraj Malik. Version 1.0.0.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              //  Help
              ExpansionTile(
                collapsedIconColor: Colors.white70,
                iconColor: Colors.white,
                collapsedBackgroundColor: Colors.white10,
                backgroundColor: Colors.white10,
                leading: const Icon(Icons.help_outline, color: Colors.white),
                title: const Text(
                  "Help & Support",
                  style: TextStyle(color: Colors.white),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Need help? Reach us at support@medvault.rs or contact your system admin.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              //  Logout
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.redAccent),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.redAccent,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
