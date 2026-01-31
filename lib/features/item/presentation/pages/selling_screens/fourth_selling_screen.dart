import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recell_bazar/features/item/presentation/providers/price_provider.dart';
import 'package:recell_bazar/features/item/presentation/state/item_state.dart';
import 'package:recell_bazar/features/item/presentation/view_model/item_viewmodel.dart';


class FourthSellingScreen extends ConsumerStatefulWidget {
  const FourthSellingScreen({super.key});

  @override
  ConsumerState<FourthSellingScreen> createState() =>
      _FourthSellingScreenState();
}

class _FourthSellingScreenState extends ConsumerState<FourthSellingScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  List<File> selectedPhotos = [];

  // ✅ Pick Photo
  Future<void> pickPhoto(ImageSource source) async {
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        selectedPhotos.add(File(file.path));
      });
    }
  }

  // ✅ Bottom Sheet
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

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneData = ref.watch(phonePriceProvider);
    final notifier = ref.read(phonePriceProvider.notifier);

    final itemState = ref.watch(itemViewModelProvider);

    // ✅ Form Validation
    final bool isFormValid =
        selectedPhotos.isNotEmpty && descriptionController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 4 of 4"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Progress Bar
            LinearProgressIndicator(
              value: 1.0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey.shade300,
              color: Colors.teal,
            ),

            const SizedBox(height: 25),

            // ===================================================
            // ✅ DISPLAY QUESTIONS
            // ===================================================

            const Text(
              "Display Condition",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // DropdownButtonFormField<String>(
            //   value: phoneData.displayCondition.isEmpty
            //       ? null
            //       : phoneData.displayCondition,
            //   decoration: InputDecoration(
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(14),
            //     ),
            //   ),
            //   items: ["Good", "Average", "Poor"]
            //       .map((e) => DropdownMenuItem(
            //             value: e,
            //             child: Text(e),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     notifier.updateField("displayCondition", value!);
            //   },
            // ),

            const SizedBox(height: 20),

            // ✅ Display Cracked
            const Text(
              "Is Display Cracked?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: phoneData.displayCracked,
                    onChanged: (v) {
                      notifier.updateField("displayCracked", v.toString());
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: phoneData.displayCracked,
                    onChanged: (v) {
                      notifier.updateField("displayCracked", v.toString());
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // ✅ Display Original
            const Text(
              "Is Display Original?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Yes"),
                    value: true,
                    groupValue: phoneData.displayOriginal,
                    onChanged: (v) {
                      notifier.updateField("displayOriginal", v.toString());
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("No"),
                    value: false,
                    groupValue: phoneData.displayOriginal,
                    onChanged: (v) {
                      notifier.updateField("displayOriginal", v.toString());
                    },
                  ),
                ),
              ],
            ),

            const Divider(height: 35),

            // ===================================================
            // ✅ PHOTO UPLOAD SECTION
            // ===================================================

            const Text(
              "Upload Photos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: showPhotoPickerSheet,
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo,
                          size: 40, color: Colors.teal),
                      SizedBox(height: 10),
                      Text("Tap to Upload Photos"),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            if (selectedPhotos.isNotEmpty)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedPhotos.map((file) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      file,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 25),

            // ===================================================
            // ✅ DESCRIPTION
            // ===================================================

            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write phone description...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 25),

            // ===================================================
            // ✅ SUBMIT BUTTON
            // ===================================================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: (!isFormValid ||
                        itemState.status == ItemStatus.loading)
                    ? null
                    : () async {
                        final itemVM =
                            ref.read(itemViewModelProvider.notifier);

                        // ✅ Upload Photos
                        List<String> uploadedUrls = [];

                        for (File photo in selectedPhotos) {
                          final url = await itemVM.uploadPhoto(photo);
                          if (url != null) uploadedUrls.add(url);
                        }

                        // ✅ Create Item
                        await itemVM.createItem(
                          sellerId: "USER_ID_HERE",
                          photos: uploadedUrls,
                          category: phoneData.category,
                          phoneModel: phoneData.phoneModel,
                          year: phoneData.year,
                          batteryHealth: phoneData.batteryHealth,
                          description: descriptionController.text,
                          basePrice: phoneData.basePrice.toString(),
                          finalPrice: phoneData.finalPrice.toString(),
                          deviceCondition: phoneData.deviceCondition,
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
                            content: Text("Item Posted Successfully ✅"),
                          ),
                        );

                        Navigator.popUntil(
                            context, (route) => route.isFirst);
                      },
                child: itemState.status == ItemStatus.loading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Submit Item",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
