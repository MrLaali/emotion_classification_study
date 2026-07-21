import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../widgets/study_text_field.dart';
import '../widgets/choice_pill.dart';
import '../widgets/section_label.dart';
import '../widgets/full_width_choice_row.dart';
import 'experiment_screen.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final uuid = const Uuid();

  final ageController = TextEditingController(text: '18');
  final languageController = TextEditingController();

  String? selectedGender;
  bool showError = false;

  final List<String> genderOptions = ['Male', 'Female', 'Diverse'];

  @override
  void dispose() {
    ageController.dispose();
    languageController.dispose();
    super.dispose();
  }

  Map<String, String?> getProlificIds() {
    final uri = Uri.base;

    return {
      'prolific_pid': uri.queryParameters['PROLIFIC_PID'],
      'prolific_study_id': uri.queryParameters['STUDY_ID'],
      'prolific_session_id': uri.queryParameters['SESSION_ID'],
    };
  }

  void startStudy() {
    final ageText = ageController.text.trim();
    final languageText = languageController.text.trim();

    if (ageText.isEmpty || languageText.isEmpty || selectedGender == null) {
      setState(() => showError = true);
      return;
    }

    final participantId = uuid.v4().substring(0, 8).toUpperCase();
    final prolificIds = getProlificIds();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExperimentScreen(
          participantInfo: {
            'participant_id': participantId,
            'age': ageText,
            'gender': selectedGender!,
            'mother_tongue': languageText,
            'trial_count': '200',
            'prolific_pid': prolificIds['prolific_pid'] ?? '',
            'prolific_study_id':
                prolificIds['prolific_study_id'] ?? '',
            'prolific_session_id':
                prolificIds['prolific_session_id'] ?? '',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: ageController,
                    label: 'Age',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  StudyTextField(
                    controller: languageController,
                    label: 'Native language',
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
                              showError = false;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    'The experiment contains 200 sentences and takes approximately 20–30 minutes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  if (showError) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Please fill in age, native language, and gender.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
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