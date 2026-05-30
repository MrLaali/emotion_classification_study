import 'package:flutter/material.dart';
import '../widgets/study_text_field.dart';
import 'experiment_screen.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final motherTongueController = TextEditingController();

  String? selectedGender;
  int selectedTrialCount = 80;
  bool showError = false;

  final List<String> genderOptions = ['Male', 'Female', 'Diverse'];

  final List<int> trialOptions = [80, 120, 160, 200];

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    motherTongueController.dispose();
    super.dispose();
  }

  int estimatedMinutes(int trialCount) {
    return (trialCount * 15 / 60).round();
  }

  void startStudy() {
    if (ageController.text.trim().isEmpty ||
        selectedGender == null ||
        motherTongueController.text.trim().isEmpty) {
      setState(() => showError = true);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExperimentScreen(
          participantInfo: {
            'name': nameController.text.trim(),
            'age': ageController.text.trim(),
            'gender': selectedGender!,
            'mother_tongue': motherTongueController.text.trim(),
            'trial_count': selectedTrialCount.toString(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minutes = estimatedMinutes(selectedTrialCount);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Emotion Classification Study',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.2,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please enter your information before starting.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),

                  StudyTextField(
                    controller: nameController,
                    label: 'Name or participant code',
                  ),
                  const SizedBox(height: 16),
                  StudyTextField(
                    controller: ageController,
                    label: 'Age',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  StudyTextField(
                    controller: motherTongueController,
                    label: 'Mother tongue',
                  ),

                  const SizedBox(height: 28),
                  const _SectionLabel('Gender'),
                  const SizedBox(height: 12),
                  _FullWidthChoiceRow(
                    children: genderOptions.map((gender) {
                      return Expanded(
                        child: _ChoicePill(
                          label: gender,
                          selected: selectedGender == gender,
                          onTap: () {
                            setState(() {
                              selectedGender = gender;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  const _SectionLabel('Length of the experiment'),
                  const SizedBox(height: 12),
                  _FullWidthChoiceRow(
                    children: trialOptions.map((count) {
                      return Expanded(
                        child: _ChoicePill(
                          label: '$count',
                          selected: selectedTrialCount == count,
                          onTap: () {
                            setState(() {
                              selectedTrialCount = count;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    'Selected length will take approximately $minutes minutes.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),

                  if (showError) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Please fill in age, gender, and mother tongue.',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],

                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: startStudy,
                    child: Container(
                      width: 170,
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}


class _ChoicePill extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_ChoicePill> createState() => _ChoicePillState();
}

class _ChoicePillState extends State<_ChoicePill> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.black,
              width: 1.3,
            ),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}


class _FullWidthChoiceRow extends StatelessWidget {
  final List<Widget> children;

  const _FullWidthChoiceRow({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children
          .expand(
            (child) => [
              child,
              if (child != children.last) const SizedBox(width: 12),
            ],
          )
          .toList(),
    );
  }
}