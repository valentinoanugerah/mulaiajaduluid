import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Menyimpan informasi pengguna ke Firestore
  Future<void> saveUserInfo({
    required String name,
    required String bloodType,
    required String medicalHistory,
    required String birthDate,
    required String address,
  }) async {
    try {
      // Ambil UID pengguna yang sedang login
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("Pengguna belum login");
      }

      // Simpan data ke Firestore
      await _db
          .collection('health_metrics')
          .doc(user.uid) // UID pengguna sebagai document ID
          .collection('user_info')
          .doc('profile') // ID dokumen tetap untuk profil
          .set({
        'date': DateTime.now(), // Waktu penyimpanan
        'name': name,
        'bloodType': bloodType,
        'medicalHistory': medicalHistory,
        'birthDate': birthDate,
        'address': address,
      }, SetOptions(merge: true));

      print("Informasi pengguna berhasil disimpan");
    } catch (e) {
      print("Gagal menyimpan informasi pengguna: $e");
      rethrow;
    }
  }

  /// Mengambil informasi pengguna dari Firestore
  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      // Ambil UID pengguna yang sedang login
      final User? user = _auth.currentUser;

      if (user == null) {
        throw Exception("Pengguna belum login");
      }

      // Ambil data dari Firestore
      final DocumentSnapshot doc = await _db
          .collection('health_metrics')
          .doc(user.uid)
          .collection('user_info')
          .doc('profile') // Mengambil data dengan ID dokumen 'profile'
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("Data pengguna tidak ditemukan");
        return null;
      }
    } catch (e) {
      print("Gagal mengambil informasi pengguna: $e");
      rethrow;
    }
  }
}
