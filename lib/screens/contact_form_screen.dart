import 'package:flutter/material.dart';
import '../widgets/study_text_field.dart';
import '../widgets/choice_pill.dart';
import '../widgets/section_label.dart';
import '../widgets/full_width_choice_row.dart';
import '../widgets/age_button.dart';
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
  int age = 18;

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

                  const SectionLabel('Age'),
                  const SizedBox(height: 12),

                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        AgeButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (age > 18) {
                              setState(() {
                                age--;
                              });
                            }
                          },
                        ),

                        Expanded(
                          child: Center(
                            child: Text(
                              '$age',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        AgeButton(
                          icon: Icons.add,
                          onTap: () {
                            setState(() {
                              age++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StudyTextField(
                    controller: motherTongueController,
                    label: 'Mother tongue',
                  ),

                  const SizedBox(height: 28),
                  const SectionLabel('Gender'),
                  const SizedBox(height: 12),
                  FullWidthChoiceRow(
                    children: genderOptions.map((gender) {
                      return Expanded(
                        child: ChoicePill(
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
                  const SectionLabel('Length of the experiment'),
                  const SizedBox(height: 12),
                  FullWidthChoiceRow(
                    children: trialOptions.map((count) {
                      return Expanded(
                        child: ChoicePill(
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


