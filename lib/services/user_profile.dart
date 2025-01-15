// lib/services/user_profile.dart

class UserProfile {
  final String weight;
  final String height;

  UserProfile({required this.weight, required this.height});

  // Mengonversi UserProfile menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'height': height,
    };
  }

  // Membaca data dari Firestore dan mengonversinya ke dalam UserProfile
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      weight: map['weight'] ?? '',
      height: map['height'] ?? '',
    );
  }
}
