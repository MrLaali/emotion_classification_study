import 'dart:async';
import 'package:flutter/material.dart';
import '../models/study_sentence.dart';
import '../services/sentence_service.dart';
import '../services/supabase_service.dart';
import '../widgets/emotion_button.dart';
import 'finish_screen.dart';

class ExperimentScreen extends StatefulWidget {
  final Map<String, String> participantInfo;

  const ExperimentScreen({super.key, required this.participantInfo});

  @override
  State<ExperimentScreen> createState() => _ExperimentScreenState();
}

class _ExperimentScreenState extends State<ExperimentScreen> {
  final sentenceService = SentenceService();
  final supabaseService = SupabaseService();

  final List<String> emotions = ['Anger', 'Fear', 'Happiness', 'Sadness'];

  List<StudySentence> trials = [];

  int currentIndex = 0;
  int timeLeft = 15;
  Timer? timer;
  Stopwatch stopwatch = Stopwatch();

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    setupExperiment();
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  Future<void> setupExperiment() async {
    try {
      final participantId = widget.participantInfo['participant_id']!;
      final age = int.parse(widget.participantInfo['age']!);
      final gender = widget.participantInfo['gender']!;
      final motherTongue = widget.participantInfo['mother_tongue']!;
      final trialCount = int.parse(widget.participantInfo['trial_count']!);

      await supabaseService.createParticipant(
        participantId: participantId,
        age: age,
        gender: gender,
        motherTongue: motherTongue,
        trialCount: trialCount,
        prolificPid: widget.participantInfo['prolific_pid'],
        prolificStudyId: widget.participantInfo['prolific_study_id'],
        prolificSessionId: widget.participantInfo['prolific_session_id'],
      );

      final allSentences = await sentenceService.loadSentences();

      final selectedTrials = sentenceService.buildTrialList(
        allSentences: allSentences,
        trialCount: trialCount,
      );

      setState(() {
        trials = selectedTrials;
        isLoading = false;
      });

      startTimer();
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  void startTimer() {
    timer?.cancel();
    stopwatch
      ..reset()
      ..start();

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

  Future<void> selectEmotion(String emotion) async {
    if (isSaving) return;

    await saveCurrentResponse(selectedEmotion: emotion, timedOut: false);
  }

  Future<void> handleTimeout() async {
    if (isSaving) return;

    await saveCurrentResponse(selectedEmotion: null, timedOut: true);
  }

  Future<void> saveCurrentResponse({
    required String? selectedEmotion,
    required bool timedOut,
  }) async {
    setState(() {
      isSaving = true;
    });

    stopwatch.stop();
    final reactionTimeMs = stopwatch.elapsedMilliseconds;

    final currentSentence = trials[currentIndex];

    try {
      await supabaseService.saveResponse(
        participantId: widget.participantInfo['participant_id']!,
        sentence: currentSentence,
        selectedEmotion: selectedEmotion,
        reactionTimeMs: reactionTimeMs,
        timedOut: timedOut,
        trialNumber: currentIndex + 1,
      );

      nextSentence();
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void nextSentence() {
    if (currentIndex < trials.length - 1) {
      setState(() {
        currentIndex++;
      });
      startTimer();
    } else {
      timer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FinishScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
    }

    final progress = (currentIndex + 1) / trials.length;
    final timerProgress = timeLeft / 15;
    final currentSentence = trials[currentIndex];

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
                    '${currentIndex + 1} / ${trials.length}',
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
                      SizedBox(
                        height: 150,
                        child: Center(
                          child: Text(
                            currentSentence.sentence,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 34,
                              height: 1.35,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.4,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 56),

                      SizedBox(
                        width: 340,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EmotionButton(
                                  label: 'Anger',
                                  onTap: () => selectEmotion('Anger'),
                                ),
                                EmotionButton(
                                  label: 'Fear',
                                  onTap: () => selectEmotion('Fear'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EmotionButton(
                                  label: 'Happiness',
                                  onTap: () => selectEmotion('Happiness'),
                                ),
                                EmotionButton(
                                  label: 'Sadness',
                                  onTap: () => selectEmotion('Sadness'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isSaving)
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Saving...',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
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
