import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Pengaturan Tema',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Tema:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Terang'),
                trailing: Radio<bool>(
                  value: false,
                  groupValue: _isDarkMode,
                  onChanged: (bool? value) {
                    setState(() {
                      _isDarkMode = value!;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _isDarkMode = false;
                  });
                },
              ),
              ListTile(
                title: const Text('Gelap'),
                trailing: Radio<bool>(
                  value: true,
                  groupValue: _isDarkMode,
                  onChanged: (bool? value) {
                    setState(() {
                      _isDarkMode = value!;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _isDarkMode = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simpan pengaturan tema (misalnya menggunakan Provider atau Shared Preferences)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tema diubah ke ${_isDarkMode ? 'Gelap' : 'Terang'}')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
