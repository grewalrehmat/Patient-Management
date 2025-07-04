import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'records_page.dart';
import 'upload_page.dart';
import 'ocr_page.dart';
import 'log_visit_page.dart';
import 'patients_page.dart';
import 'settings_page.dart';
import 'login_screen.dart';
import 'profile_page.dart';
import 'top_panel.dart';

void main() {
  runApp(const MedVaultApp());
}

class MedVaultApp extends StatelessWidget {
  const MedVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedVault-RS',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        primaryColor: Colors.tealAccent,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const MainScaffold(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int selectedIndex = 0;

  bool get isWideScreen => MediaQuery.of(context).size.width > 800;

  List<Widget> get pages {
    return [
      HomePage(onShowAllTapped: () => setState(() => selectedIndex = 1)),
      const RecordsPage(),
      isWideScreen ? const UploadPage() : const OCRPage(),
      if (isWideScreen) const PatientsPage(),
      const LogVisitPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isWideScreen
          ? Row(
              children: [
                _buildSidebar(),
                Expanded(child: pages[selectedIndex]),
              ],
            )
          : Column(
              children: [
                const TopPanel(),
                Expanded(child: pages[selectedIndex]),
              ],
            ),
      bottomNavigationBar: isWideScreen ? null : _buildBottomNav(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 80,
      color: const Color(0xFF2C2C2E),
      child: Column(
        children: [
          Expanded(
            child: NavigationRail(
              backgroundColor: const Color(0xFF2C2C2E),
              selectedIndex: selectedIndex >= 5 ? 0 : selectedIndex,

              onDestinationSelected: (index) =>
                  setState(() => selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.folder_copy),
                  label: Text('Records'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.upload_file),
                  label: Text('Upload'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  label: Text('Patients'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome),
                  label: Text('Log Visit'),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white24, thickness: 1),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: "Settings",
            onPressed: () => setState(() => selectedIndex = 5),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.white54,
        iconSize: 30,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_copy),
            label: 'Records',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'OCR'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'Log Visit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
