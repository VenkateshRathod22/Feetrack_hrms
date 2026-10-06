import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vlr/controllers/auth_controller.dart';
import 'package:vlr/services/custom_text.dart';
import 'package:vlr/services/theme.dart';
import 'package:vlr/views/screens/auth_screens/sign_in_screen.dart';
import 'package:vlr/views/screens/dashboard/dashboard_screen.dart';

import '../../../services/constants.dart';
import '../../base/custom_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer.run(() {
        Future.delayed(const Duration(seconds: 2), () {
          checkAuth();
        });
      });
    });
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Preload login background
    await precacheImage(
      const AssetImage(Assets.imagesLoginBg),
      context,
    );

    // Preload logo
    await precacheImage(
      const AssetImage(Assets.imagesLogo),
      context,
    );

    if (!mounted) return;

    final authController = Get.find<AuthController>();

    String token = authController.getUserToken();

    if (token.isNotEmpty) {
      final response = await authController.fetchProfile();

      if (response.isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const DashboardScreen(
                    isComingForSplashScreen: true,
                  )),
        );
      } else {
        authController.logOutPost();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, animation, __) => const SignInScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesSplaceBg),
            fit: BoxFit.cover,
          ),
        ),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sizedBoxHeight(height: 300),
            CustomImage(
              path: Assets.imagesLogoWhite,
              height: size.height * .1,
              width: size.height * .3,
            ),
            sizedBoxHeight(height: 16),
            CustomText(
              "TRACK. MANAGE. GROW.",
              style: Helper(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 16.sp, color: white, letterSpacing: 1.0),
            ),
            const Spacer(),
            CircularProgressIndicator(
              color: primaryColor,
              backgroundColor: white,
            ),
            sizedBoxHeight(height: 12),
            CustomText(
              "Loading...",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: white,
                  ),
            ),
            sizedBoxHeight(height: 100)
          ],
        ),
      ),
    );
  }
}
