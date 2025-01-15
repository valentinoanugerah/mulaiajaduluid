import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mulaiajaduluid/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({super.key});

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  String _selectedLanguage = 'en'; // Default ke English

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('languageCode') ?? 'en';
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
    // Restart aplikasi atau terapkan perubahan bahasa
    Locale newLocale = Locale(languageCode);
    MyApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Language'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLanguageOption('English', 'en'),
            _buildLanguageOption('Bahasa Indonesia', 'id'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String languageName, String languageCode) {
    return ListTile(
      title: Text(languageName),
      trailing: Radio<String>(
        value: languageCode,
        groupValue: _selectedLanguage,
        onChanged: (value) {
          if (value != null) {
            _changeLanguage(value);
          }
        },
      ),
    );
  }
}
