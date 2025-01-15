import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';

import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';

class MentalAndEnvironmentalHealthPage extends StatelessWidget {
  const MentalAndEnvironmentalHealthPage({super.key});

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
                      'Kesehatan Mental & Lingkungan',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Mental and Environmental Health Section
                    SizedBox(height: 20 * scaleFactor),
                    _buildHealthAndEnvironmentSection(context, scaleFactor),
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

  Widget _buildHealthAndEnvironmentSection(BuildContext context, double scaleFactor) {
    final topics = [
      {
        'title': 'Lingkungan yang Sehat, Pikiran yang Sehat',
        'description': 'Kesehatan mental kita dapat dipengaruhi oleh lingkungan yang bersih dan alami. Menjaga kebersihan lingkungan bisa mengurangi stres dan meningkatkan kesejahteraan.',
        'color': Colors.green,
        'icon': Icons.nature,
      },
      {
        'title': 'Manfaat Alam Terhadap Kesehatan Mental',
        'description': 'Interaksi dengan alam, seperti berjalan di taman atau hiking, dapat membantu meredakan kecemasan dan meningkatkan mood.',
        'color': Colors.blue,
        'icon': Icons.landscape,
      },
      {
        'title': 'Mengurangi Polusi untuk Kesehatan Mental',
        'description': 'Polusi udara dan suara bisa meningkatkan stres. Menjaga kebersihan udara dan mengurangi polusi bisa membantu meredakan kecemasan.',
        'color': Colors.orange,
        'icon': Icons.clean_hands,
      },
      {
        'title': 'Berkebun untuk Kesehatan Mental',
        'description': 'Berkebun tidak hanya bermanfaat bagi lingkungan, tetapi juga dapat menurunkan tingkat stres dan meningkatkan mood secara signifikan.',
        'color': Colors.teal,
        'icon': Icons.local_florist,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kesehatan Mental & Lingkungan',
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15 * scaleFactor),
        ...topics.map((topic) => GestureDetector(
          onTap: () {
            // Navigasi ke halaman terkait jika diperlukan
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
