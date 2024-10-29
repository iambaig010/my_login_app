import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Call the function with a delay
    Future.delayed(Duration.zero, () {
      _checkOnboardingStatus(); // Check onboarding status
    });
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

    if (isOnboardingCompleted) {
      // Wait a brief moment before navigating
      await Future.delayed(const Duration(seconds: 1));
      // Navigate to the login screen if onboarding is already completed
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingCompleted', true); // Set onboarding as completed
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page; // Update the current page index
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();  // Mark onboarding as completed
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to login
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          OnboardingPage(
            content: "Welcome to our App!",
            imagePath: 'assets/images/onboarding1.png',
          ),
          OnboardingPage(
            content: "Easy Login with Phone Number",
            imagePath: 'assets/images/onboarding2.png',
          ),
          OnboardingPage(
            content: "Enjoy the Experience",
            imagePath: 'assets/images/onboarding3.png',
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentPage == 0 ? null : _previousPage,
              ),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text(_currentPage == 2 ? 'Get Started' : 'Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String content;
  final String imagePath;

  const OnboardingPage({
    super.key,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Text(
              content,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
