import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/change_language_page.dart'; // Misal halaman untuk mengganti bahasa
import 'package:mulaiajaduluid/pages/privacy_security_page.dart'; // Halaman untuk keamanan & privasi
import 'package:mulaiajaduluid/pages/change_language_page.dart';
import 'package:mulaiajaduluid/pages/theme_settings_page.dart'; // Halaman untuk pengaturan tema

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      title: const Text(
        'Pengaturan',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildSettingsOptions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.brightness_6,
          title: 'Pengaturan Tema',
          subtitle: 'Sesuaikan tema aplikasi',
          onTap: () {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ThemeSettingsPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          icon: Icons.notifications_outlined,
          title: 'Notifikasi',
          subtitle: 'Atur preferensi notifikasi',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pengaturan notifikasi coming soon!')),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          icon: Icons.language_outlined,
          title: 'Bahasa',
          subtitle: 'Ganti bahasa aplikasi',
          onTap: () {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChangeLanguagePage()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          icon: Icons.lock_outline,
          title: 'Keamanan & Privasi',
          subtitle: 'Atur pengaturan privasi dan keamanan',
          onTap: () {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PrivacySecurityPage()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildOptionTile(
          icon: Icons.exit_to_app,
          title: 'Keluar',
          subtitle: 'Keluar dari akun Anda',
          onTap: () {
            // Aksi keluar (logout)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur logout coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            // Navigate to Home page
            break;
          case 1:
            // Navigate to Stats page
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Statistik',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}
