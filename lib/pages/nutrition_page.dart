import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';
import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 402;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              _buildTopHeader(context, screenWidth, scaleFactor),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title
                    Text(
                      'Nutrisi Sehat',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Nutrition Tips
                    SizedBox(height: 20 * scaleFactor),
                    _buildNutritionTip(
                      title: 'Makan Sayur',
                      description: 'Pastikan setidaknya 3 porsi sayuran dalam sehari untuk asupan serat.',
                      color: Colors.green,
                      scaleFactor: scaleFactor,
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    _buildNutritionTip(
                      title: 'Protein Seimbang',
                      description: 'Konsumsi sumber protein seperti daging tanpa lemak, ikan, atau kacang-kacangan.',
                      color: Colors.blue,
                      scaleFactor: scaleFactor,
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    _buildNutritionTip(
                      title: 'Hidrasi Cukup',
                      description: 'Minumlah air putih 8 gelas sehari untuk menjaga tubuh tetap terhidrasi.',
                      color: Colors.orange,
                      scaleFactor: scaleFactor,
                    ),
                    SizedBox(height: 20 * scaleFactor),
                    _buildMotivationCard(scaleFactor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context, screenWidth, scaleFactor),
    );
  }

  Widget _buildTopHeader(BuildContext context, double screenWidth, double scaleFactor) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: 20 * scaleFactor, 
        vertical: 15 * scaleFactor
      ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, size: 28 * scaleFactor),
            onPressed: () => Navigator.pop(context),
          ),
          Icon(Icons.info_outline, size: 28 * scaleFactor)
        ],
      ),
    );
  }

  Widget _buildNutritionTip({
    required String title,
    required String description,
    required Color color,
    required double scaleFactor,
  }) {
    return Container(
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 10 * scaleFactor),
          Text(
            description,
            style: TextStyle(
              fontSize: 14 * scaleFactor,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationCard(double scaleFactor) {
    return Container(
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tetap Sehat!',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  'Perubahan kecil dalam kebiasaan makanmu bisa berdampak besar untuk kesehatan.',
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.fastfood, color: Colors.orange, size: 30 * scaleFactor),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, double screenWidth, double scaleFactor) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety_outlined),
          label: 'Statistik',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HealthStatisticsPage()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  const Profile()),
            );
            break;
        }
      },
    );
  }
}
