import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:uuid/uuid.dart';
import '../widgets/choice_pill.dart';
import '../widgets/section_label.dart';
import '../widgets/full_width_choice_row.dart';
import '../widgets/age_button.dart';
import '../data/languages.dart';
import 'experiment_screen.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final uuid = const Uuid();
  String? selectedGender;
  int selectedTrialCount = 80;
  bool showError = false;
  int age = 18;
  String? selectedLanguage;

  final List<String> genderOptions = ['Male', 'Female', 'Diverse'];

  final List<int> trialOptions = [80, 120, 160, 200];

  @override
  void dispose() {
    super.dispose();
  }

  String estimatedDurationLabel(int trialCount) {
    switch (trialCount) {
      case 80:
        return '8-12 minutes';
      case 120:
        return '12-18 minutes';
      case 160:
        return '16-24 minutes';
      case 200:
        return '20-30 minutes';
      default:
        return 'approximately 10 minutes';
    }
  }

  void startStudy() {
    if (selectedGender == null || selectedLanguage == null) {
      setState(() => showError = true);
      return;
    }

    final participantId = uuid.v4().substring(0, 8).toUpperCase();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExperimentScreen(
          participantInfo: {
            'participant_id': participantId,
            'age': age.toString(),
            'gender': selectedGender!,
            'mother_tongue': selectedLanguage!,
            'trial_count': selectedTrialCount.toString(),
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final durationLabel = estimatedDurationLabel(selectedTrialCount);

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
                  DropdownSearch<String>(
                    selectedItem: selectedLanguage,
                    items: (filter, loadProps) => languages,
                    onSelected: (value) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    },
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Search language...',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(color: Colors.black26),
                          ),
                        ),
                      ),
                    ),
                    decoratorProps: DropDownDecoratorProps(
                      decoration: InputDecoration(
                        labelText: 'Native language',
                        labelStyle: const TextStyle(color: Colors.black54),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.black26),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                      ),
                    ),
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
                    'Selected length will take approximately $durationLabel.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),

                  if (showError) ...[
                    const SizedBox(height: 18),
                    const Text(
                      'Please select a gender and native language.',
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
