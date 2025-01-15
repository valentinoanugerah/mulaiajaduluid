import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';

class AccountInfoPage extends StatelessWidget {
  const AccountInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil informasi akun pengguna yang sedang login
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Informasi Akun',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (context) => const Profile())),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              _buildUserInfoCard(
                icon: Icons.email_outlined,
                title: 'Email',
                value: user?.email ?? 'Tidak tersedia',
              ),
              const SizedBox(height: 16),
              _buildUserInfoCard(
                icon: Icons.person_outline,
                title: 'Nama Pengguna',
                value: user?.displayName ?? 'Tidak tersedia',
              ),
              const SizedBox(height: 16),
              _buildUserInfoCard(
                icon: Icons.phone_outlined,
                title: 'Nomor Telepon',
                value: user?.phoneNumber ?? 'Tidak tersedia',
              ),
              const SizedBox(height: 16),
              _buildUserInfoCard(
                icon: Icons.calendar_today_outlined,
                title: 'Tanggal Daftar',
                value: user?.metadata.creationTime?.toLocal().toString() ?? 'Tidak tersedia',
              ),
              const SizedBox(height: 16),
              _buildUserInfoCard(
                icon: Icons.lock_outline,
                title: 'Status Akun',
                value: user?.emailVerified ?? false ? 'Terverifikasi' : 'Belum Terverifikasi',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
