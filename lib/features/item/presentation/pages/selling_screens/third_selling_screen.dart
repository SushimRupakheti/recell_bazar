import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/fourth_selling_screen.dart';
import 'package:recell_bazar/features/item/presentation/widgets/progress_indicator.dart';
import 'package:recell_bazar/features/item/presentation/widgets/question_design_widget.dart';

class ThirdSellingScreen extends ConsumerStatefulWidget {
  const ThirdSellingScreen({super.key});

  @override
  ConsumerState<ThirdSellingScreen> createState() =>
      _ThirdSellingScreenState();
}

class _ThirdSellingScreenState extends ConsumerState<ThirdSellingScreen> {
  bool? cameraCondition;
  bool? features1Condition; 
  bool? chargerAvailable;

  final TextEditingController batteryController =
      TextEditingController(text: "98");
  
 Widget buildYesNoQuestion(
    String question,
    bool? value,
    Function(bool) onChanged,
  ) {
    return QuestionDesignWidget(
      question: question,
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () => onChanged(true),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: value == true ? Color(0xFF0B7C7C) : Colors.grey.shade400,
              ),
              backgroundColor: value == true
                  ? Color(0xFF0B7C7C).withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              'Yes',
              style: TextStyle(
                color: value == true ? Color(0xFF0B7C7C) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: () => onChanged(false),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: value == false ? Color(0xFF0B7C7C) : Colors.grey.shade400,
              ),
              backgroundColor: value == false
                  ? Color(0xFF0B7C7C).withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              'No',
              style: TextStyle(
                color: value == false ? Color(0xFF0B7C7C) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isFormValid =>
      cameraCondition != null &&
      features1Condition != null &&
      chargerAvailable != null &&
      batteryController.text.isNotEmpty;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFFFF1F1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily:'Montserrat-Bold' ,
        ),
        title: const Text("Answer The Questions Below"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StepProgressIndicator(
              currentStep: 2,
              totalSteps: 4,
            ),
            const SizedBox(height: 32),

            // Questions
            buildYesNoQuestion(
              "Is their a problem with the camera?",
              cameraCondition,
              (v) => setState(() => cameraCondition = v),
            ),

            buildYesNoQuestion(
              "Are your speakers,flashlight,or microphone working?",
              features1Condition,
              (v) => setState(() => features1Condition = v),
            ),

            buildYesNoQuestion(
              "Do you have the original power adapter and cable?",
              chargerAvailable,
              (v) => setState(() => chargerAvailable = v),
            ),

            // Year Question
            QuestionDesignWidget(
              question: "What is your battery health?",
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: TextField(
                  controller: batteryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Battery Health (%)",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 190),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0B7C7C), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF0B7C7C),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FourthSellingScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B7C7C),
                    disabledBackgroundColor: Color(0xFF0B7C7C).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
