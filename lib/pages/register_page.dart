import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mulaiajaduluid/pages/login_page.dart';
import 'package:mulaiajaduluid/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }

    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua field')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final authService = context.read<AuthService>();
      await authService.registerWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      
      // Update display name after successful registration
      await authService.updateUserProfile(
        displayName: _nameController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
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
    final screenHeight = MediaQuery.of(context).size.height;
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
                // Top Header
                _buildTopHeader(context, screenWidth, scaleFactor),

                // Register Title
                SizedBox(height: 20 * scaleFactor),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 32 * scaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                

                

                // Register Form
                SizedBox(height: 20 * scaleFactor),
                _buildRegisterForm(context, screenWidth, scaleFactor),

                // Footer
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

  

 

  

  Widget _buildRegisterForm(BuildContext context, double screenWidth, double scaleFactor) {
    return Column(
      children: [
        _buildTextField('Full Name', false, screenWidth, scaleFactor),
        SizedBox(height: 15 * scaleFactor),
        _buildTextField('Email', false, screenWidth, scaleFactor),
        SizedBox(height: 15 * scaleFactor),
        _buildTextField('Password', true, screenWidth, scaleFactor),
        SizedBox(height: 15 * scaleFactor),
        _buildTextField('Confirm Password', true, screenWidth, scaleFactor),
        SizedBox(height: 20 * scaleFactor),
        _buildRegisterButton(context, screenWidth, scaleFactor),
      ],
    );
  }

  Widget _buildTextField(
    String hint, 
    bool isPassword, 
    double screenWidth, 
    double scaleFactor
  ) {
    final controller = hint == 'Full Name' 
        ? _nameController
        : hint == 'Email'
            ? _emailController
            : hint == 'Password'
                ? _passwordController
                : _confirmPasswordController;

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
        controller: controller,
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

  Widget _buildRegisterButton(BuildContext context, double screenWidth, double scaleFactor) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegister,
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
            'Register',
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Already have an account? ",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14 * scaleFactor,
            ),
            children: const [
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  color: Colors.blue,
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