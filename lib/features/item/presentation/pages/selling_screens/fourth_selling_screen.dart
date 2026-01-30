import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/item/presentation/pages/selling_screens/second_selling_screen.dart';
import 'package:recell_bazar/features/item/presentation/widgets/progree_indicator.dart';
import 'package:recell_bazar/features/item/presentation/widgets/question_design_widget.dart';

class FourthSellingScreen extends ConsumerStatefulWidget {
  const FourthSellingScreen({super.key});

  @override
  ConsumerState<FourthSellingScreen> createState() =>
      _FourthSellingScreenState();
}

class _FourthSellingScreenState extends ConsumerState<FourthSellingScreen> {
  bool? displayCondition;
  bool? displayCracked;
  bool? displayOriginal;

  final TextEditingController batteryController = TextEditingController(
    text: "98",
  );
  
  // Description Controller
  final TextEditingController descriptionController = TextEditingController();

  // Photos List (later you can connect image picker)
  List<String> selectedPhotos = [];

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
                color: value == true ? Colors.teal : Colors.grey.shade400,
              ),
              backgroundColor: value == true
                  ? Colors.teal.withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Yes',
              style: TextStyle(
                color: value == true ? Colors.teal : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: () => onChanged(false),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: value == false ? Colors.teal : Colors.grey.shade400,
              ),
              backgroundColor: value == false
                  ? Colors.teal.withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'No',
              style: TextStyle(
                color: value == false ? Colors.teal : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get isFormValid =>
      displayCondition != null &&
      displayCracked != null &&
      displayOriginal != null &&
      batteryController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      selectedPhotos.isNotEmpty;


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
          fontFamily: 'Montserrat-Bold',
        ),
        title: const Text("Answer The Questions Below"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const StepProgressIndicator(currentStep: 3, totalSteps: 4),
            const SizedBox(height: 32),

            // Questions
            buildYesNoQuestion(
              "IS your display the original one that came with the phone?",
              displayOriginal,
              (v) => setState(() => displayOriginal = v),
            ),
            buildYesNoQuestion(
              "Is your display working properly?",
              displayCondition,
              (v) => setState(() => displayCondition = v),
            ),

            buildYesNoQuestion(
              "Is your display cracked?",
              displayCracked,
              (v) => setState(() => displayCracked = v),
            ),

            //PHOTOS
                        // =====================================================
            // ✅ PHOTO FIELD (NOT RELATED TO YES/NO)
            // =====================================================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upload Phone Photos",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
                // TODO: Add Image Picker Here
                setState(() {
                  selectedPhotos.add("dummy_photo");
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.camera_alt,
                        size: 40, color: Colors.teal),
                    const SizedBox(height: 8),
                    Text(
                      selectedPhotos.isEmpty
                          ? "Tap to upload photos"
                          : "${selectedPhotos.length} photo(s) selected",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // =====================================================
            // ✅ DESCRIPTION FIELD (NOT RELATED TO YES/NO)
            // =====================================================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Add Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write details about your phone...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),



            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.teal, width: 2),
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
                      color: Colors.teal,
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
                              builder: (context) => SecondSellingScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    disabledBackgroundColor: Colors.teal.withOpacity(0.4),
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
