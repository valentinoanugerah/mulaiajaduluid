import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';




// Pastikan Anda memiliki Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Fungsi untuk meng-update data di Firestore
Future<void> _updateProfileData(String weight, String height) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      // Menyimpan data ke Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'weight': weight,
        'height': height,
      });

      Fluttertoast.showToast(msg: "Profile data updated!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to update profile data: ${e.toString()}");
    }
  } else {
    Fluttertoast.showToast(msg: "User not logged in!");
  }
}
