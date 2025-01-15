import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_metric.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan data mingguan berdasarkan pengguna yang login
  Future<List<HealthMetric>> getWeeklyMetrics() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      QuerySnapshot querySnapshot = await _db
          .collection('health_metrics')
          .doc(user.uid) // Menyimpan data berdasarkan uid pengguna
          .collection('weekly_metrics')
          .orderBy('date') // Mengurutkan berdasarkan tanggal
          .get();

      return querySnapshot.docs
          .map((doc) => HealthMetric.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting weekly metrics: $e');
      return []; // Mengembalikan list kosong jika terjadi error
    }
  }

  // Menyimpan data kesehatan berdasarkan pengguna yang login
  Future<void> saveHealthData(HealthMetric healthMetric) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Menyimpan data ke koleksi Firestore berdasarkan uid pengguna
      await _db.collection('health_metrics')
          .doc(user.uid)
          .collection('weekly_metrics')
          .add(healthMetric.toMap());

      print('Data kesehatan berhasil disimpan');
    } catch (e) {
      print('Error saving health data: $e');
      rethrow; // Mengembalikan exception jika gagal menyimpan
    }
  }

  // Mendapatkan rata-rata metrik berdasarkan pengguna yang login
  Future<Map<String, dynamic>> getHealthMetricsAverage() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      DocumentSnapshot doc = await _db
          .collection('health_metrics')
          .doc(user.uid)
          .collection('average')
          .doc('average')
          .get();

      // Menangani kemungkinan document tidak ada atau data null
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {}; // Jika tidak ada data atau dokumen, mengembalikan map kosong
      }
    } catch (e) {
      print('Error getting health metrics average: $e');
      return {}; // Mengembalikan map kosong jika terjadi error
    }
  }

  // Mendapatkan progres kesehatan berdasarkan pengguna yang login
  Future<Map<String, dynamic>> getHealthProgress() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      DocumentSnapshot doc = await _db
          .collection('health_metrics')
          .doc(user.uid)
          .collection('health_progress')
          .doc('progress')
          .get();

      // Menangani kemungkinan document tidak ada atau data null
      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return {}; // Jika tidak ada data atau dokumen, mengembalikan map kosong
      }
    } catch (e) {
      print('Error getting health progress: $e');
      return {}; // Mengembalikan map kosong jika terjadi error
    }
  }
}
