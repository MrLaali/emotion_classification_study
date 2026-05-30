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
  final genderController = TextEditingController();
  final motherTongueController = TextEditingController();

  bool showError = false;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    motherTongueController.dispose();
    super.dispose();
  }

  void startStudy() {
    if (ageController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty ||
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
            'gender': genderController.text.trim(),
            'mother_tongue': motherTongueController.text.trim(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
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
                  controller: genderController,
                  label: 'Gender',
                ),
                const SizedBox(height: 16),
                StudyTextField(
                  controller: motherTongueController,
                  label: 'Mother tongue',
                ),

                if (showError) ...[
                  const SizedBox(height: 18),
                  const Text(
                    'Please fill in age, gender, and mother tongue.',
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
    );
  }
}