import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/emotion_button.dart';
import 'finish_screen.dart';

class ExperimentScreen extends StatefulWidget {
  final Map<String, String> participantInfo;

  const ExperimentScreen({
    super.key,
    required this.participantInfo,
  });

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

    setState(() {
      timeLeft = 15;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft <= 1) {
        timer.cancel();
        handleTimeout();
      } else {
        setState(() {
          timeLeft--;
        });
      }
    });
  }

  void selectEmotion(String emotion) {
    // Later we will save:
    // widget.participantInfo
    // sentences[currentIndex]
    // selected emotion
    // reaction time
    // timeout = false

    nextSentence();
  }

  void handleTimeout() {
    // Later we will save:
    // selected emotion = null
    // timeout = true

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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.black,
                    ),
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