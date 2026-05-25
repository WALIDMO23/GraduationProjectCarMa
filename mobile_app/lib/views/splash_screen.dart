import 'package:flutter/material.dart';
import 'package:graduation_project/core/comeponents/app_image.dart';
import 'package:graduation_project/views/home/home.dart';
import 'package:graduation_project/views/login.dart';
import 'package:graduation_project/logic/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();
    
    // Simulate splash delay while loading auth state
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      auth.loadCurrentUser(),
    ]);

    if (!mounted) return;

    if (auth.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C398E),
      body: const Center(
        child: AppImage(
          image: 'servishero_loading.json',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
