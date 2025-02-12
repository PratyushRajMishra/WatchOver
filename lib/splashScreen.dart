import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:watchover/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String bootText = "Initializing System...";
  int bootIndex = 0;
  final List<String> bootMessages = [
    "█ Booting Up WatchOver...",
    "█ Checking Security Protocols...",
    "█ Loading Surveillance Modules...",
    "█ Establishing Secure Connection...",
    "█ Access Granted"
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (bootIndex < bootMessages.length) {
        setState(() {
          bootText = bootMessages[bootIndex];
          bootIndex++;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 1000), () {
          // Ensure the splash screen closes before transitioning
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()), // Replace with your home screen
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Hacker-style dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo with Neon Glow
            Text(
              "WATCHOVER",
              style: GoogleFonts.orbitron(
                textStyle: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.greenAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Booting Text Animation
            Text(
              bootText,
              style: GoogleFonts.sourceCodePro(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading Bar (Fake Animation)
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}