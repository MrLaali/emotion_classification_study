import 'dart:async';
import 'package:flutter/material.dart';

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
      home: const ExperimentScreen(),
    );
  }
}

class ExperimentScreen extends StatefulWidget {
  const ExperimentScreen({super.key});

  @override
  State<ExperimentScreen> createState() => _ExperimentScreenState();
}

class _ExperimentScreenState extends State<ExperimentScreen> {
  final List<String> sentences = [
    'I could not stop smiling after hearing the news.',
    'Everything felt heavy and empty today.',
    'I cannot believe they treated me like that.',
    'I felt something terrible was about to happen.',
  ];
  

  final List<String> emotions = [
    'Anger',
    'Fear',
    'Happiness',
    'Sadness',
  ];

  int currentIndex = 0;
  int timeLeft = 15;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    timeLeft = 15;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 1) {
        timer.cancel();
        nextSentence();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void selectEmotion(String emotion) {
    // Later we will save:
    // sentence, target emotion, chosen emotion, reaction time, participant id

    nextSentence();
  }

  void nextSentence() {
    if (currentIndex < sentences.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      timer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const FinishScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / sentences.length;
    final timerProgress = timeLeft / 15;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 24,
              left: 24,
              child: SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: timerProgress,
                      strokeWidth: 3,
                      backgroundColor: Colors.black12,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    Text(
                      '$timeLeft',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 42,
              left: 120,
              right: 120,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: Colors.black12,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${currentIndex + 1} / ${sentences.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 0.4,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sentences[currentIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          height: 1.35,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.4,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 64),
                      Wrap(
                        spacing: 22,
                        runSpacing: 22,
                        alignment: WrapAlignment.center,
                        children: emotions.map((emotion) {
                          return EmotionButton(
                            label: emotion,
                            onTap: () => selectEmotion(emotion),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmotionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const EmotionButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<EmotionButton> createState() => _EmotionButtonState();
}

class _EmotionButtonState extends State<EmotionButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final active = isHovered || isPressed;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() {
        isHovered = false;
        isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          setState(() => isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.4),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class FinishScreen extends StatelessWidget {
  const FinishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Thank you for participating.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}