import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mulaiajaduluid/pages/menjaga_lingkungan.dart';
import 'package:mulaiajaduluid/pages/menjaga_lingkungan_page.dart';
import 'package:mulaiajaduluid/pages/profile_page.dart';
import 'package:mulaiajaduluid/pages/task_page.dart';
import 'package:mulaiajaduluid/pages/physical_health_page.dart';
import 'package:mulaiajaduluid/pages/mental_health_page.dart';
import 'package:mulaiajaduluid/pages/health_statistics_page.dart';
import 'package:mulaiajaduluid/pages/input_health_data_page.dart';
import 'package:mulaiajaduluid/models/air_quality_model.dart';
import 'package:mulaiajaduluid/services/air_quality_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mulaiajaduluid/pages/health_statistics_page.dart' as HealthStatsPage;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _chatController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

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
              _buildTopHeader(screenWidth, scaleFactor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreetingSection(scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildAirQualityCard(scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildMenuSection(context, scaleFactor),
                    _buildChatInterface(scaleFactor),
                    SizedBox(height: 20 * scaleFactor),
                    _buildAdditionalInfoCard(context, scaleFactor),
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
            'Dashboard',
            style: TextStyle(
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Icon(Icons.notifications_outlined, size: 28 * scaleFactor)
        ],
      ),
    );
  }

  Widget _buildGreetingSection(double scaleFactor) {
    final user = FirebaseAuth.instance.currentUser;
    String greeting = _getGreeting();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            color: Colors.black54,
          ),
        ),
        Text(
          '${user?.displayName ?? 'Pengguna'}',
          style: TextStyle(
            fontSize: 24 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAirQualityCard(double scaleFactor) {
    final airQualityService = AirQualityService();

    return FutureBuilder<Position>(
      future: _getCurrentLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final latitude = snapshot.data?.latitude ?? 0.0;
          final longitude = snapshot.data?.longitude ?? 0.0;

          return Container(
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
                Icon(
                  Icons.air,
                  color: Colors.blue,
                  size: 30 * scaleFactor,
                ),
                SizedBox(width: 15 * scaleFactor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Air Quality',
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 5 * scaleFactor),
                      FutureBuilder<AirQualityModel>(
                        future: airQualityService.getAirQuality(latitude, longitude),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            final airQuality = snapshot.data?.hourly;
                            if (airQuality != null && airQuality.isNotEmpty) {
                              final pm10 = airQuality['pm10']?[0] ?? 'Data tidak tersedia';
                              final pm25 = airQuality['pm2_5']?[0] ?? 'Data tidak tersedia';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PM10: $pm10',
                                    style: TextStyle(
                                      fontSize: 18 * scaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'PM2.5: $pm25',
                                    style: TextStyle(
                                      fontSize: 18 * scaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return Text(
                            'Data tidak tersedia',
                            style: TextStyle(
                              fontSize: 18 * scaleFactor,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Text('Lokasi tidak tersedia');
      },
    );
  }

  Widget _buildMenuSection(BuildContext context, double scaleFactor) {
    final menuItems = [
      {
        'icon': Icons.fitness_center,
        'title': 'Menjaga Kesehatan Fisik',
        'page': const PhysicalHealthPage(),
        'color': Colors.blue
      },
      {
        'icon': Icons.psychology,
        'title': 'Menjaga Kesehatan Mental',
        'page': const MentalHealthPage(),
        'color': Colors.green
      },
      {
        'icon': Icons.eco,
        'title': 'Menjaga Lingkungan',
        'page': EnvironmentalHealthPage(),
        'color': const Color.fromARGB(255, 39, 176, 162)
      },
      {
        'icon': Icons.analytics,
        'title': 'Statistik Kesehatan',
        'page': HealthStatisticsPage(),
        'color': Colors.orange
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Input Data Kesehatan',
        'page': InputHealthDataPage(),
        'color': Colors.purple
      },
      
    ];

    return Column(
      children: menuItems.map((item) => 
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => item['page'] as Widget)
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
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 30 * scaleFactor,
                  ),
                ),
                SizedBox(width: 15 * scaleFactor),
                Expanded(
                  child: Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 18 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ).toList(),
    );
  }

  Widget _buildChatInterface(double scaleFactor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20 * scaleFactor),
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
          Padding(
            padding: EdgeInsets.all(15 * scaleFactor),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, 
                     color: Colors.blue, 
                     size: 24 * scaleFactor),
                SizedBox(width: 10 * scaleFactor),
                Text(
                  'Health Assistant',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 300 * scaleFactor,
            padding: EdgeInsets.symmetric(horizontal: 15 * scaleFactor),
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message, scaleFactor);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: EdgeInsets.all(8.0 * scaleFactor),
              child: Row(
                children: [
                  SizedBox(width: 15 * scaleFactor),
                  Text(
                    'Assistant sedang mengetik...',
                    style: TextStyle(
                      fontSize: 12 * scaleFactor,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(15 * scaleFactor),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Tanyakan tentang kesehatanmu...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20 * scaleFactor,
                        vertical: 10 * scaleFactor,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 10 * scaleFactor),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () => _sendMessage(_chatController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, double scaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * scaleFactor),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) 
            Padding(
              padding: EdgeInsets.only(right: 8 * scaleFactor),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.assistant, 
                          color: Colors.blue, 
                          size: 20 * scaleFactor),
              ),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15 * scaleFactor,
                vertical: 10 * scaleFactor,
              ),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 14 * scaleFactor,
                ),
              ),
            ),
          ),
          if (message.isUser)
            Padding(
              padding: EdgeInsets.only(left: 8 * scaleFactor),
              child: CircleAvatar(
                backgroundColor: Colors.blue.shade900,
                child: Icon(Icons.person, 
                          color: Colors.white, 
                          size: 20 * scaleFactor),
              ),
            ),
        ],
      ),
    );
  }

 

  Widget _buildAdditionalInfoCard(BuildContext context, double scaleFactor) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20 * scaleFactor),
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Improve Your Health',
                  style: TextStyle(
                    fontSize: 18 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 10 * scaleFactor),
                Text(
                  'Learn more about maintaining a healthy lifestyle',
                  style: TextStyle(
                    fontSize: 14 * scaleFactor,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, double screenWidth, double scaleFactor) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        switch (index) {
          case 0:
            // Sudah di halaman Dashboard
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HealthStatisticsPage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
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

 void _sendMessage(String text) async {
  if (text.trim().isEmpty) return;

  setState(() {
    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isTyping = true;
    _chatController.clear();
  });

  try {
    print('Sending request to AI API...');
    final response = await http.post(
      Uri.parse('http://ai.ivanz.web.id:9000/chat'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': text,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Pastikan respons memiliki kunci 'response'
      if (responseData is Map<String, dynamic> && responseData.containsKey('response')) {
        final aiResponse = responseData['response'] as String;
        setState(() {
          _messages.add(ChatMessage(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isTyping = false;
        });
      } else {
        throw Exception('Response format tidak sesuai: ${response.body}');
      }
    } else {
      throw Exception('Error status code: ${response.statusCode}, body: ${response.body}');
    }
  } catch (e) {
    print('Detailed error: $e');
    setState(() {
      _messages.add(ChatMessage(
        text: 'Error: $e',  // Tampilkan error spesifik untuk debugging
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isTyping = false;
    });
  }
}


  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi tidak diaktifkan');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak secara permanen');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour >= 12 && hour < 18) {
      return 'Selamat Siang';
    } else if (hour >= 18 && hour < 21) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}