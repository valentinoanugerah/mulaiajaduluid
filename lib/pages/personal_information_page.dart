import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';
import 'package:mulaiajaduluid/services/user_info_profile.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final UserInfoService _userInfoService = UserInfoService();
  Map<String, dynamic>? _userInfo; // Data pengguna
  bool _isLoading = true; // Status loading

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Memuat data pengguna saat halaman dimuat
  }

  /// Fungsi untuk mengambil data pengguna dari Firestore
  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await _userInfoService.fetchUserInfo();
      setState(() {
        _userInfo = userInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          'Informasi Pengguna',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pushReplacement(context,
           MaterialPageRoute(builder: (context)=> const Profile())),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    _buildUserInfoCard(
                      icon: Icons.person_outline,
                      title: 'Nama Lengkap',
                      value: _userInfo?['name'] ?? 'Tidak tersedia',
                    ),
                    const SizedBox(height: 16),
                    _buildUserInfoCard(
                      icon: Icons.bloodtype,
                      title: 'Golongan Darah',
                      value: _userInfo?['bloodType'] ?? 'Tidak tersedia',
                    ),
                    const SizedBox(height: 16),
                    _buildUserInfoCard(
                      icon: Icons.history,
                      title: 'Riwayat Penyakit',
                      value: _userInfo?['medicalHistory'] ?? 'Tidak tersedia',
                    ),
                    const SizedBox(height: 16),
                    _buildUserInfoCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Tanggal Lahir',
                      value: _userInfo?['birthDate'] ?? 'Tidak tersedia',
                    ),
                    const SizedBox(height: 16),
                    _buildUserInfoCard(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      value: _userInfo?['address'] ?? 'Tidak tersedia',
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
