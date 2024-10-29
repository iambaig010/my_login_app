import 'package:flutter/material.dart';
import 'package:my_login_app/src/features/authentications/presentation/otp_verification.dart';
import 'package:my_login_app/src/features/authentications/presentation/phone_auth.dart';
import 'package:my_login_app/src/features/authentications/presentation/login.dart'; 
import 'package:my_login_app/src/features/authentications/presentation/sign_up.dart';
import 'package:my_login_app/src/features/homescreen/homescreen.dart';
import 'package:my_login_app/src/features/onboarding/onboardig_screen.dart';
import 'package:my_login_app/src/features/splash/splash_screen.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/phoneAuth':
        return MaterialPageRoute(builder: (_) => PhoneAuthScreen());

      case '/otpVerification':
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(verificationId: verificationId),
        );

      case '/home': // Add this case for HomeScreen
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case '/signUp':
        return MaterialPageRoute(builder: (_) => SignUpScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen()); 

      case '/splash':
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
