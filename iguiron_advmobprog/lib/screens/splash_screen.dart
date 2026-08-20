import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

// enhancement 1: own UI for the splash screen that implements persistent authentication - it checks SharedPreferences for an existing session before routing to /home or /signin.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final loggedIn = await _userService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      final user = await _userService.getUser();
      currentUserId = user.id;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14213D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/nubdexchange_logo.png',
              width: 96.w,
              errorBuilder: (_, __, ___) => Icon(
                Icons.storefront,
                size: 72.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            const CustomText(
              text: 'NUBD Exchange',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontColor: Colors.white,
            ),
            SizedBox(height: 36.h),
            SizedBox(
              width: 26.w,
              height: 26.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.amber.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
