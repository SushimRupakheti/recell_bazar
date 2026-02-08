import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recell_bazar/features/auth/presentation/pages/user_profile_screen.dart';
import 'package:recell_bazar/features/item/presentation/providers/price_provider.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';
import 'package:recell_bazar/features/item/presentation/widgets/progress_indicator.dart';
import 'package:recell_bazar/features/item/presentation/widgets/question_design_widget.dart';

class FourthSellingScreen extends ConsumerStatefulWidget {
  const FourthSellingScreen({super.key});

  @override
  ConsumerState<FourthSellingScreen> createState() =>
      _FourthSellingScreenState();
}

class _FourthSellingScreenState extends ConsumerState<FourthSellingScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  bool? displayOriginal;
  bool? displayCracked;
  bool? displayCondition;
  List<File> selectedPhotos = [];

  @override
  void initState() {
    super.initState();

    // Schedule provider update after first frame to avoid lifecycle error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      final notifier = ref.read(phonePriceProvider.notifier);
      notifier.setSellerId(currentUser.authId ?? '');
    });
  }

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
                color: value == true
                    ? const Color(0xFF0B7C7C)
                    : Colors.grey.shade400,
              ),
              backgroundColor: value == true
                  ? const Color(0xFF0B7C7C).withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Yes',
              style: TextStyle(
                color:
                    value == true ? const Color(0xFF0B7C7C) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: () => onChanged(false),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: value == false
                    ? const Color(0xFF0B7C7C)
                    : Colors.grey.shade400,
              ),
              backgroundColor: value == false
                  ? const Color(0xFF0B7C7C).withOpacity(0.1)
                  : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'No',
              style: TextStyle(
                color:
                    value == false ? const Color(0xFF0B7C7C) : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PICK PHOTO
  Future<void> pickPhoto(ImageSource source) async {
    final XFile? file =
        await picker.pickImage(source: source, imageQuality: 70);

    if (file != null) {
      setState(() {
        selectedPhotos.add(File(file.path));
      });
    }
  }

  void showPhotoPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose From Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get isFormValid =>
      displayOriginal != null &&
      displayCracked != null &&
      displayCondition != null &&
      selectedPhotos.isNotEmpty &&
      descriptionController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final phoneData = ref.watch(phonePriceProvider);
    final notifier = ref.read(phonePriceProvider.notifier);
    final itemState = ref.watch(itemViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
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
            const StepProgressIndicator(
              currentStep: 3,
              totalSteps: 4,
            ),

            const SizedBox(height: 32),

            buildYesNoQuestion(
              "Is your display Original?",
              displayOriginal,
              (v) {
                setState(() => displayOriginal = v);
                notifier.updateField("displayOriginal", v);
              },
            ),
            buildYesNoQuestion(
              "Is your display cracked?",
              displayCracked,
              (v) {
                setState(() => displayCracked = v);
                notifier.updateField("displayCracked", v);
              },
            ),
            buildYesNoQuestion(
              "Is your display pixelated, damaged or non-functional?",
              displayCondition,
              (v) {
                setState(() => displayCondition = v);
                notifier.updateField("displayCondition", v);
              },
            ),

            // PHOTO UPLOAD
            QuestionDesignWidget(
              question: "Upload Phone Photos",
              child: GestureDetector(
                onTap: showPhotoPickerSheet,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFF0B7C7C), width: 2),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 40, color: Color(0xFF0B7C7C)),
                        SizedBox(height: 8),
                        Text("Tap to upload photos"),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (selectedPhotos.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedPhotos.map((file) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            ],

            // DESCRIPTION
            QuestionDesignWidget(
              question: "Description",
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Write phone description...",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BOTTOM BUTTONS
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
                        horizontal: 60, vertical: 16),
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (!isFormValid ||
                          itemState.status == ItemStatus.loading)
                      ? null
                      : () async {
                          final itemVM =
                              ref.read(itemViewModelProvider.notifier);

                          List<String> uploadedUrls = [];

                          for (File photo in selectedPhotos) {
                            final url = await itemVM.uploadPhoto(photo);
                            debugPrint('uploadPhoto returned: $url');
                            if (url != null) uploadedUrls.add(url);
                          }

                          debugPrint('All uploadedUrls: $uploadedUrls');

                          // If uploads failed and there are no URLs, abort and show error
                          if (uploadedUrls.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to upload photos. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          await itemVM.createItem(
                            sellerId: phoneData.sellerId,
                            photos: uploadedUrls,
                            category: phoneData.category,
                            phoneModel: phoneData.phoneModel,
                            year: phoneData.year,
                            batteryHealth: phoneData.batteryHealth,
                            description: descriptionController.text,
                            basePrice: phoneData.basePrice.toString(),
                            finalPrice: phoneData.finalPrice.toString(),
                            chargerAvailable: phoneData.chargerAvailable,
                            factoryUnlock: phoneData.factoryUnlock,
                            liquidDamage: phoneData.liquidDamage,
                            switchOn: phoneData.switchOn,
                            receiveCall: phoneData.receiveCall,
                            features1Condition: phoneData.features1Condition,
                            features2Condition: phoneData.features2Condition,
                            cameraCondition: phoneData.cameraCondition,
                            displayCondition: phoneData.displayCondition,
                            displayCracked: phoneData.displayCracked,
                            displayOriginal: phoneData.displayOriginal,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Item Posted Successfully"),
                            ),
                          );

                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B7C7C),
                    disabledBackgroundColor:
                        const Color(0xFF0B7C7C).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: itemState.status == ItemStatus.loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
