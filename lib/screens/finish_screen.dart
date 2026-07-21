import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FinishScreen extends StatefulWidget {
  final bool isProlificParticipant;

  const FinishScreen({
    super.key,
    required this.isProlificParticipant,
  });

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  static const String completionCode = 'C19W7FKN';

  static final Uri prolificCompletionUrl = Uri.parse(
    'https://app.prolific.com/submissions/complete?cc=$completionCode',
  );

  Timer? redirectTimer;
  bool redirectFailed = false;

  @override
  void initState() {
    super.initState();

    if (widget.isProlificParticipant) {
      redirectTimer = Timer(
        const Duration(seconds: 5),
        redirectToProlific,
      );
    }
  }

  @override
  void dispose() {
    redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> redirectToProlific() async {
    try {
      final launched = await launchUrl(
        prolificCompletionUrl,
        webOnlyWindowName: '_self',
      );

      if (!launched && mounted) {
        setState(() {
          redirectFailed = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          redirectFailed = true;
        });
      }
    }
  }

  Future<void> copyCompletionCode() async {
    await Clipboard.setData(
      const ClipboardData(text: completionCode),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Completion code copied.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.black,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Thank you for participating!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    height: 1.3,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),

                if (widget.isProlificParticipant) ...[
                  const SizedBox(height: 20),
                  Text(
                    redirectFailed
                        ? 'Automatic redirection was unsuccessful. Please use the button below.'
                        : 'You will be redirected back to Prolific automatically.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Completion code',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: copyCompletionCode,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            completionCode,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.copy,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: redirectToProlific,
                    child: Container(
                      width: 220,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Return to Prolific',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}