import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  const PrivacySecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 402;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20 * scaleFactor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privasi & Keamanan',
                style: TextStyle(
                  fontSize: 24 * scaleFactor,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20 * scaleFactor),
              Text(
                'Pengaturan Privasi',
                style: TextStyle(fontSize: 18 * scaleFactor, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10 * scaleFactor),
              SwitchListTile(
                title: const Text('Aktifkan Verifikasi Dua Langkah'),
                value: false, // Ganti dengan status aktual
                onChanged: (bool value) {
                  // Tambahkan logika untuk mengubah status
                },
              ),
              SizedBox(height: 20 * scaleFactor),
              Text(
                'Informasi Keamanan',
                style: TextStyle(fontSize: 18 * scaleFactor, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10 * scaleFactor),
              Text(
                'Pastikan untuk tidak membagikan informasi akun Anda kepada orang lain.',
                style: TextStyle(fontSize: 16 * scaleFactor),
              ),
              // Tambahkan informasi lain sesuai kebutuhan
            ],
          ),
        ),
      ),
    );
  }
}