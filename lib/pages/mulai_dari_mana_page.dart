import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';

import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';

class StartFromHerePage extends StatelessWidget {
  const StartFromHerePage({super.key});

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
                      'Mulai dari Mana?',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Steps to Start
                    SizedBox(height: 20 * scaleFactor),
                    _buildStepsSection(context, scaleFactor),
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

  Widget _buildStepsSection(BuildContext context, double scaleFactor) {
    final steps = [
      {
        'title': 'Mulai dengan Diri Sendiri',
        'description': 'Perhatikan kebiasaan sehari-hari, seperti menjaga kebersihan diri, menghindari makanan yang tidak sehat, dan cukup tidur.',
        'color': Colors.green,
        'icon': Icons.self_improvement,
      },
      {
        'title': 'Kurangi Sampah Plastik',
        'description': 'Mulailah dengan mengurangi penggunaan plastik sekali pakai dan beralih ke bahan yang lebih ramah lingkungan.',
        'color': Colors.blue,
        'icon': Icons.recycling,
      },
      {
        'title': 'Tumbuhkan Kebiasaan Sehat',
        'description': 'Lakukan olahraga secara rutin dan makan makanan yang bergizi untuk menjaga kesehatan tubuh dan mental.',
        'color': Colors.orange,
        'icon': Icons.fitness_center,
      },
      {
        'title': 'Jaga Kesehatan Mental',
        'description': 'Luangkan waktu untuk meditasi, berbicara dengan orang terdekat, dan hindari stres berlebihan.',
        'color': Colors.purple,
        'icon': Icons.psychology,
      },
      {
        'title': 'Berinteraksi dengan Alam',
        'description': 'Cobalah untuk berinteraksi lebih banyak dengan alam, seperti berjalan-jalan di taman atau berkemah untuk menyegarkan pikiran.',
        'color': Colors.teal,
        'icon': Icons.nature,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Langkah-Langkah Awal',
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15 * scaleFactor),
        ...steps.map((step) => Container(
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
                  color: (step['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  step['icon'] as IconData,
                  color: step['color'] as Color,
                  size: 30 * scaleFactor,
                ),
              ),
              SizedBox(width: 15 * scaleFactor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] as String,
                      style: TextStyle(
                        fontSize: 16 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: step['color'] as Color,
                      ),
                    ),
                    SizedBox(height: 5 * scaleFactor),
                    Text(
                      step['description'] as String,
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
