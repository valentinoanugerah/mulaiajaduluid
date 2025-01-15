import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';

import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/kesehatan_mental_dan_lingkungan_page.dart';
import 'package:mulaiajaduluid/pages/menjaga_lingkungan.dart';
import 'package:mulaiajaduluid/pages/mulai_dari_mana_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';


class EnvironmentalHealthPage extends StatelessWidget {
  const EnvironmentalHealthPage({super.key});

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
                      'Kesehatan Lingkungan dan Tubuh',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Environmental Health Education Cards
                    SizedBox(height: 20 * scaleFactor),
                    _buildEnvironmentHealthSection(context, scaleFactor),
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

  Widget _buildEnvironmentHealthSection(BuildContext context, double scaleFactor) {
    final environmentHealthTopics = [
      {
        'title': 'Pengertian Kesehatan Lingkungan',
        'description': 'Pelajari apa itu kesehatan lingkungan dan bagaimana lingkungan mempengaruhi kesehatan kita.',
        'color': Colors.green,
        'icon': Icons.nature,
        'page': const ImportanceOfEnvironmentalHealthPage(),
      },
      {
        'title': 'Mulai dari Mana?',
        'description': 'Tips untuk mulai menjaga lingkungan sekitar dan kesehatan diri sendiri.',
        'color': Colors.blue,
        'icon': Icons.lightbulb_outline,
        'page': const StartFromHerePage(),
      },
      {
        'title': 'Kesehatan Mental dan Lingkungan',
        'description': 'Hubungan antara lingkungan yang sehat dan kesehatan mental kita.',
        'color': Colors.purple,
        'icon': Icons.psychology,
        'page': const MentalAndEnvironmentalHealthPage(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edukasi Kesehatan Lingkungan',
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15 * scaleFactor),
        ...environmentHealthTopics.map((topic) => GestureDetector(
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
