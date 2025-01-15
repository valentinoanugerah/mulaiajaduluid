import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';
import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';
import 'package:mulaiajaduluid/pages/importance_of_physical_health_page.dart';
import 'package:mulaiajaduluid/pages/physical_exercise_page.dart';
import 'package:mulaiajaduluid/pages/nutrition_page.dart'; // Halaman Nutrisi
import 'package:mulaiajaduluid/pages/healthylivingpage.dart'; // Halaman Pola Hidup Sehat

class PhysicalHealthPage extends StatelessWidget {
  const PhysicalHealthPage({super.key});

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
                      'Kesehatan Fisik',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Physical Health Education Cards
                    SizedBox(height: 20 * scaleFactor),
                    _buildPhysicalHealthEducationSection(context, scaleFactor),
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

  Widget _buildPhysicalHealthEducationSection(BuildContext context, double scaleFactor) {
    final physicalHealthTopics = [
      {
        'title': 'Pentingnya Aktivitas Fisik',
        'description': 'Pelajari manfaat olahraga rutin untuk kesehatan',
        'color': Colors.blue,
        'icon': Icons.directions_run,
        'page': const ImportanceOfPhysicalHealthPage(),
      },
      {
        'title': 'Latihan',
        'description': 'Tips untuk mendapatkan kebugaran optimal melalui latihan',
        'color': Colors.green,
        'icon': Icons.fitness_center,
        'page': const PhysicalExercisePage(),
      },
      {
        'title': 'Pola Hidup Sehat', // Menu Pola Hidup Sehat yang baru
        'description': 'Pelajari cara menerapkan pola hidup sehat setiap hari',
        'color': Colors.purple,
        'icon': Icons.favorite,
        'page': const HealthyLivingPage(), // Halaman Pola Hidup Sehat
      },
    ];

    final nutritionTopics = [
      {
        'title': 'Nutrisi Sehat',
        'description': 'Pentingnya pola makan yang sehat untuk mendukung kebugaran',
        'color': Colors.orange,
        'icon': Icons.food_bank,
        'page': const NutritionPage(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edukasi Kesehatan Fisik',
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15 * scaleFactor),
        // Latihan Section
        Text(
          'Latihan',
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10 * scaleFactor),
        ...physicalHealthTopics.map((topic) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => topic['page'] as Widget),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15 * scaleFactor),
            padding: EdgeInsets.all(15 * scaleFactor),
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10 * scaleFactor),
                  decoration: BoxDecoration(
                    color: (topic['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    topic['icon'] as IconData,
                    color: topic['color'] as Color,
                    size: 30 * scaleFactor,
                  ),
                ),
                SizedBox(width: 15 * scaleFactor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic['title'] as String,
                        style: TextStyle(
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: topic['color'] as Color,
                        ),
                      ),
                      SizedBox(height: 5 * scaleFactor),
                      Text(
                        topic['description'] as String,
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        SizedBox(height: 15 * scaleFactor),
        // Nutrisi Section
        Text(
          'Nutrisi',
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10 * scaleFactor),
        ...nutritionTopics.map((topic) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => topic['page'] as Widget),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 15 * scaleFactor),
            padding: EdgeInsets.all(15 * scaleFactor),
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10 * scaleFactor),
                  decoration: BoxDecoration(
                    color: (topic['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    topic['icon'] as IconData,
                    color: topic['color'] as Color,
                    size: 30 * scaleFactor,
                  ),
                ),
                SizedBox(width: 15 * scaleFactor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        topic['title'] as String,
                        style: TextStyle(
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: topic['color'] as Color,
                        ),
                      ),
                      SizedBox(height: 5 * scaleFactor),
                      Text(
                        topic['description'] as String,
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
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
