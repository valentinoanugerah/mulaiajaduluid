import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';
import 'package:mulaiajaduluid/services/user_info_profile.dart';

class EditProfileInfoPage extends StatefulWidget {
  const EditProfileInfoPage({super.key});

  @override
  State<EditProfileInfoPage> createState() => _EditProfileInfoPageState();
}

class _EditProfileInfoPageState extends State<EditProfileInfoPage> {
  final UserInfoService _userInfoService = UserInfoService();

  // TextEditingController untuk setiap field input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo(); // Memuat data pengguna saat halaman dimuat
  }

  /// Fungsi untuk mengambil data pengguna dari Firestore
  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await _userInfoService.fetchUserInfo();
      if (userInfo != null) {
        setState(() {
          _nameController.text = userInfo['name'] ?? '';
          _bloodTypeController.text = userInfo['bloodType'] ?? '';
          _medicalHistoryController.text = userInfo['medicalHistory'] ?? '';
          _birthDateController.text = userInfo['birthDate'] ?? '';
          _addressController.text = userInfo['address'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  /// Fungsi untuk menyimpan data pengguna ke Firestore
  Future<void> _saveUserInfo() async {
    try {
      await _userInfoService.saveUserInfo(
        name: _nameController.text,
        bloodType: _bloodTypeController.text,
        medicalHistory: _medicalHistoryController.text,
        birthDate: _birthDateController.text,
        address: _addressController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi berhasil disimpan!')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah menyimpan
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
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
          'Edit Informasi Pengguna',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                icon: Icons.person_outline,
                label: 'Nama Lengkap',
                placeholder: 'Masukkan nama lengkap Anda',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                icon: Icons.bloodtype,
                label: 'Golongan Darah',
                placeholder: 'Masukkan golongan darah Anda',
                controller: _bloodTypeController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                icon: Icons.history,
                label: 'Riwayat Penyakit',
                placeholder: 'Masukkan riwayat penyakit Anda',
                controller: _medicalHistoryController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                icon: Icons.calendar_today_outlined,
                label: 'Tanggal Lahir',
                placeholder: 'Masukkan tanggal lahir Anda (dd/mm/yyyy)',
                controller: _birthDateController,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                icon: Icons.location_on_outlined,
                label: 'Alamat',
                placeholder: 'Masukkan alamat Anda',
                controller: _addressController,
              ),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required String placeholder,
    required TextEditingController controller,
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
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveUserInfo,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
