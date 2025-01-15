import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mulaiajaduluid/pages/dashboard_page.dart';
import 'package:mulaiajaduluid/pages/register_page.dart';
import 'package:mulaiajaduluid/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi email dan password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final authService = context.read<AuthService>();
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      await authService.signInWithGoogle(); // Pastikan Anda memiliki metode ini di AuthService
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 402;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20 * scaleFactor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(context, screenWidth, scaleFactor),
                SizedBox(height: 20 * scaleFactor),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 30 * scaleFactor),
                _buildSocialLoginButtons(screenWidth, scaleFactor),
                SizedBox(height: 20 * scaleFactor),
                _buildDivider(screenWidth, scaleFactor),
                SizedBox(height: 20 * scaleFactor),
                _buildLoginForm(context, screenWidth, scaleFactor),
                SizedBox(height: 20 * scaleFactor),
                _buildFooter(context, screenWidth, scaleFactor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, double screenWidth, double scaleFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 28 * scaleFactor),
          onPressed: () => Navigator.pop(context),
        ),
        Icon(Icons.help_outline, size: 28 * scaleFactor)
      ],
    );
  }

  Widget _buildSocialLoginButtons(double screenWidth, double scaleFactor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSocialButton(
          'Google', 
          'assets/img/google.png', 
          screenWidth, 
          scaleFactor,
          _handleGoogleLogin // Panggil fungsi login Google
        ),
        _buildSocialButton(
          'Apple', 
          'assets/img/apple.png', 
          screenWidth, 
          scaleFactor,
          () {
            // Tambahkan logika untuk login dengan Apple jika diperlukan
          }
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String platform, 
    String iconPath, 
    double screenWidth, 
    double scaleFactor,
    VoidCallback onPressed
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: screenWidth * 0.4,
        padding: EdgeInsets.symmetric(
          vertical: 10 * scaleFactor, 
          horizontal: 8 * scaleFactor
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath, 
              height: 20 * scaleFactor,
              width: 20 * scaleFactor,
            ),
            SizedBox(width: 8 * scaleFactor),
            Flexible(
              child: Text(
                'Login with $platform',
                style: TextStyle(
                  fontSize: 12 * scaleFactor,
                  color: Colors.black87,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double screenWidth, double scaleFactor) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black38)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 * scaleFactor),
          child: const Text(
            'or',
            style: TextStyle(color: Colors.black54),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black38)),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context, double screenWidth, double scaleFactor) {
    return Column(
      children: [
        _buildTextField('Email', false, screenWidth, scaleFactor),
        SizedBox(height: 15 * scaleFactor),
        _buildTextField('Password', true, screenWidth, scaleFactor),
        SizedBox(height: 20 * scaleFactor),
        _buildLoginButton(context, screenWidth, scaleFactor),
      ],
    );
  }

  Widget _buildTextField(
    String hint, 
    bool isPassword, 
    double screenWidth, 
    double scaleFactor
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: hint == 'Email' ? _emailController : _passwordController,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20 * scaleFactor, 
            vertical: 15 * scaleFactor
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, double screenWidth, double scaleFactor) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: Size(screenWidth, 50 * scaleFactor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: _isLoading 
        ? const CircularProgressIndicator(color: Colors.white)
        : Text(
            'Login',
            style: TextStyle(
              fontSize: 16 * scaleFactor,
              fontWeight: FontWeight.bold,
            ),
          ),
    );
  }

  Widget _buildFooter(BuildContext context, double screenWidth, double scaleFactor) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14 * scaleFactor,
            ),
            children: const [
              TextSpan(
                text: 'Register',
                style: TextStyle(
                  color: Colors .blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}