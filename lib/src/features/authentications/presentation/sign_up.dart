import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  SignUpScreen({super.key});

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String phoneNumber = phoneController.text.trim();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Auto-verification completed.");
        await auth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, '/home');
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid phone number")),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Code sent: $verificationId");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("Code retrieval timeout: $verificationId");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _verifyPhoneNumber(context),
              child: const Text("Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
