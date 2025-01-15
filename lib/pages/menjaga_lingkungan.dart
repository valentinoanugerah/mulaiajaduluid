import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';

import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';

class ImportanceOfEnvironmentalHealthPage extends StatelessWidget {
  const ImportanceOfEnvironmentalHealthPage({super.key});

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
                      'Pentingnya Menjaga Lingkungan dan Kesehatan',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Content Sections
                    SizedBox(height: 20 * scaleFactor),
                    _buildContentSection(
                      title: 'Definisi',
                      description: 'Menjaga lingkungan berarti menjaga keseimbangan alam agar dapat mendukung kehidupan manusia dan makhluk lainnya.',
                      color: Colors.green,
                      scaleFactor: scaleFactor,
                    ),

                    SizedBox(height: 20 * scaleFactor),
                    _buildContentSection(
                      title: 'Mengapa Penting?',
                      description: 'Lingkungan yang sehat dapat meningkatkan kualitas hidup, mendukung kesehatan fisik dan mental, serta mengurangi risiko penyakit.',
                      color: Colors.blue,
                      scaleFactor: scaleFactor,
                    ),

                    SizedBox(height: 20 * scaleFactor),
                    _buildContentSection(
                      title: 'Dampak',
                      description: 'Kerusakan lingkungan dapat menyebabkan perubahan iklim, polusi, dan ancaman terhadap kesehatan kita. Oleh karena itu, menjaga lingkungan sangat penting.',
                      color: Colors.orange,
                      scaleFactor: scaleFactor,
                    ),

                    // Motivation Card
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

  Widget _buildContentSection({
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
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jaga Kesehatan dan Lingkunganmu!',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  'Setiap tindakan kecil untuk lingkungan dapat memberikan dampak besar untuk kesehatan kita.',
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.nature_people, color: Colors.green, size: 30 * scaleFactor),
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
          icon: Icon(Icons.eco),
          label: 'Statistik Lingkungan',
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
