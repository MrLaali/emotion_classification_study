import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/contact_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kybyiuttzhcalezwrklt.supabase.co',
    anonKey: 'sb_publishable_sLaLfbSD-zgaOHjmK6MyoQ_d1ubwt1b',
  );

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