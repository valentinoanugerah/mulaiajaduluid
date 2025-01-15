// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
// Gunakan prefix untuk menghindari konflik
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

Future<UserCredential?> signInWithGoogle() async {
  try {
    _isLoading = true;
    notifyListeners();

    // Inisialisasi GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Lakukan proses Sign-In dengan Google
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // Jika pengguna membatalkan login
      throw 'Proses login dengan Google dibatalkan.';
    }

    // Ambil Authentication object dari Google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Buat credential untuk Firebase
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Login ke Firebase menggunakan credential Google
    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    notifyListeners();
    return userCredential;
  } catch (e) {
    throw 'Login dengan Google gagal: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak terdaftar.';
          break;
        case 'wrong-password':
          message = 'Password salah.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan.';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }
      throw message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> registerWithEmailPassword(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password terlalu lemah, minimal 6 karakter.';
          break;
        case 'email-already-in-use':
          message = 'Email sudah terdaftar.';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }
      throw message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Format email tidak valid.';
          break;
        case 'user-not-found':
          message = 'Email tidak terdaftar.';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }
      throw message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
      
      notifyListeners();
    } catch (e) {
      throw 'Gagal memperbarui profil: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final user = _auth.currentUser;
      final email = user?.email;
      
      if (user != null && email != null) {
        // Menggunakan EmailAuthProvider dari firebase_auth
        final credential = EmailAuthProvider.credential(
          email: email,
          password: currentPassword,
        );
        
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Password baru terlalu lemah, minimal 6 karakter.';
          break;
        case 'requires-recent-login':
          message = 'Silakan login ulang sebelum mengubah password.';
          break;
        case 'wrong-password':
          message = 'Password saat ini salah.';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }
      throw message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

 Future<void> signOut() async {
  try {
    _isLoading = true;
    notifyListeners();

    // Logout dari Firebase
    await _auth.signOut();

    // Logout dari Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    notifyListeners();
  } catch (e) {
    throw 'Gagal logout: ${e.toString()}';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  Future<void> deleteAccount(String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final user = _auth.currentUser;
      final email = user?.email;
      
      if (user != null && email != null) {
        // Menggunakan EmailAuthProvider dari firebase_auth
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        
        await user.reauthenticateWithCredential(credential);
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'requires-recent-login':
          message = 'Silakan login ulang sebelum menghapus akun.';
          break;
        case 'wrong-password':
          message = 'Password salah.';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }
      throw message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}