import 'package:flutter/material.dart';
import 'screens/contact_form_screen.dart';

void main() {
  runApp(const EmotionStudyApp());
}

class EmotionStudyApp extends StatelessWidget {
  const EmotionStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotion Classification Study',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          surface: Colors.white,
        ),
      ),
      home: const ContactFormScreen(),
    );
  }
}