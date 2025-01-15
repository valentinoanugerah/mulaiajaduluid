import 'package:flutter/material.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';
import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';
import 'package:mulaiajaduluid/pages/physical_health_page.dart';
import 'package:mulaiajaduluid/pages/mental_health_page.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenWidth / 402;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              _buildTopHeader(screenWidth, scaleFactor),

              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Tugas Kesehatan',
                      style: TextStyle(
                        fontSize: 24 * scaleFactor,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    // Task Categories
                    SizedBox(height: 20 * scaleFactor),
                    _buildTaskCategories(context, scaleFactor),

                    // Active Tasks
                    SizedBox(height: 20 * scaleFactor),
                    _buildActiveTasks(scaleFactor),

                    // Progress Overview
                    SizedBox(height: 20 * scaleFactor),
                    _buildProgressOverview(scaleFactor),

                    // Additional Motivation Card
                    SizedBox(height: 20 * scaleFactor),
                    _buildMotivationCard(scaleFactor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context,screenWidth, scaleFactor),
    );
  }

  Widget _buildTopHeader(double screenWidth, double scaleFactor) {
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
          Text(
            'Tugas Harian',
            style: TextStyle(
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Icon(Icons.add_circle_outline, size: 28 * scaleFactor)
        ],
      ),
    );
  }

  Widget _buildTaskCategories(BuildContext context, double scaleFactor) {
    final categories = [
      {
        'title': 'Kesehatan Fisik',
        'icon': Icons.fitness_center,
        'color': Colors.blue,
        'page': const PhysicalHealthPage()
      },
      {
        'title': 'Kesehatan Mental',
        'icon': Icons.psychology,
        'color': Colors.green,
        'page': const MentalHealthPage()
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) => 
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category['page'] as Widget)
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10 * scaleFactor),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 30 * scaleFactor,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  category['title'] as String,
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        )
      ).toList(),
    );
  }

  Widget _buildActiveTasks(double scaleFactor) {
    final tasks = [
      {
        'title': 'Olahraga Pagi',
        'progress': 0.7,
        'color': Colors.blue
      },
      {
        'title': 'Meditasi',
        'progress': 0.4,
        'color': Colors.green
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tugas Aktif',
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 15 * scaleFactor),
        ...tasks.map((task) => 
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'] as String,
                  style: TextStyle(
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: task['color'] as Color,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: task['progress'] as double,
                    backgroundColor: (task['color'] as Color).withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(task['color'] as Color),
                    minHeight: 6 * scaleFactor,
                  ),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }

  Widget _buildProgressOverview(double scaleFactor) {
    return Container(
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Overview',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  'You have completed 70% of your tasks this week!',
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('View Details'),
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
                  'Stay Motivated!',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  'Keep pushing towards your health goals!',
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.star, color: Colors.green, size: 30 * scaleFactor),
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
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(context,
             MaterialPageRoute(builder: (context) => const Dashboard()),
             );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HealthStatisticsPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  const Profile()),
            );
            break;
        }
      },
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
    );
  }
}