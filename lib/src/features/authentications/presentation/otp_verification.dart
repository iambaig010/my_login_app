import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;

  const OTPVerificationScreen({super.key, required this.verificationId});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifyOTP(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      await auth.signInWithCredential(credential);
      print("OTP verified successfully.");
      otpController.clear();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print("Failed to verify OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "OTP"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : () => _verifyOTP(context),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text("Verify OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
