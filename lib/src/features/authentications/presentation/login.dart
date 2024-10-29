// ignore_for_file: unused_local_variable

import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_login_app/src/features/authentications/presentation/phone_auth.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String stateRequested;
  late String codeVerifier;
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();

    // Generate state parameter for OAuth
    stateRequested = _generateState();
    codeVerifier = _generateCodeVerifier();

    // Check if the OAuth flow is usable (Truecaller installed and configured)
    TcSdk.isOAuthFlowUsable.then((isUsable) {
      if (isUsable) {
        // Proceed with Truecaller authentication setup
        _initializeTruecallerSDK();
      } else {
        // Redirect to OTP Authentication
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneAuthScreen(), // Navigate to your OTP flow
          ),
        );
      }
    });
  }

  void _initializeTruecallerSDK() {
    // Initialize Truecaller SDK with custom options
    TcSdk.initializeSDK(
      sdkOption: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS, // or SDK_OPTION_WITH_OTP if needed
      consentHeadingOption: TcSdkOptions.SDK_CONSENT_HEADING_LOG_IN_TO,
      footerType: TcSdkOptions.FOOTER_TYPE_SKIP,
      ctaText: TcSdkOptions.CTA_TEXT_PROCEED,
      buttonShapeOption: TcSdkOptions.BUTTON_SHAPE_ROUNDED,
      buttonColor: Colors.blue.value,
      buttonTextColor: Colors.white.value,
    );

    // Listen to Truecaller SDK callback data
    streamSubscription = TcSdk.streamCallbackData.listen(
      (tcSdkCallback) {
        switch (tcSdkCallback.result) {
          case TcSdkCallbackResult.success:
            _handleSuccess(tcSdkCallback);
            break;
          case TcSdkCallbackResult.failure:
            _showSnackbar('Authentication failed: ${tcSdkCallback.error?.message}');
            break;
          case TcSdkCallbackResult.verification:
            _showSnackbar('Manual verification required!');
            break;
          default:
            _showSnackbar('Unexpected result');
        }
      },
      onError: (error) {
        _showSnackbar('Error: $error');
      },
    );
  }

  void initiateTruecallerAuth() {
    // Trigger OAuth flow
    TcSdk.isOAuthFlowUsable.then((isUsable) {
      if (isUsable) {
        // Set OAuth state and code challenge
        TcSdk.setOAuthState(stateRequested);
        TcSdk.setOAuthScopes(['profile', 'phone', 'openid']);
        TcSdk.generateCodeChallenge(codeVerifier).then((codeChallenge) {
          if (codeChallenge != null) {
            TcSdk.setCodeChallenge(codeChallenge);
            TcSdk.getAuthorizationCode();
          } else {
            _showSnackbar('Device not supported for code challenge');
          }
        });
      } else {
        _showSnackbar('Truecaller is not installed or available');
      }
    });
  }

  String _generateState() {
    // Generate a random string of 32 characters
    final random = Random.secure();
    return List.generate(32, (index) => random.nextInt(10)).join();
  }

  String _generateCodeVerifier() {
    // Generate a random code verifier using SecureRandom
    return CodeVerifierUtil.generateRandomCodeVerifier();
  }

  void _handleSuccess(TcSdkCallback tcSdkCallback) {
    // Handle successful authentication
    final tcOAuthData = tcSdkCallback.tcOAuthData!;
    final authorizationCode = tcOAuthData.authorizationCode;
    final stateReceived = tcOAuthData.state;

    // Verify state matches
    if (stateRequested == stateReceived) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackbar('State mismatch. Possible security issue');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    // Cancel the stream subscription
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: initiateTruecallerAuth,
              child: const Text('Login with Truecaller'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneAuthScreen(), // Navigate to OTP flow
                  ),
                );
              },
              child: const Text('Login with OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeVerifierUtil {
  // Method to generate a random code verifier string
  static String generateRandomCodeVerifier({int length = 128}) {
    final random = Random.secure();
    final randomValues = List<int>.generate(length, (i) => random.nextInt(256));

    // Convert random values to base64 encoding
    return base64UrlEncode(randomValues)
        .replaceAll('=', ''); // Remove padding characters if any
  }
}
