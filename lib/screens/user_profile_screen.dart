import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/usecases/update_profile_image_usecase.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';

// --------------------
// Current User Provider (synchronous, reads from SharedPreferences)
// --------------------
final currentUserProvider = Provider<AuthEntity>((ref) {
  final session = ref.read(userSessionServiceProvider);

  return AuthEntity(
    authId: session.getUserId(),
    firstName: session.getFirstName() ?? '',
    lastName: session.getUserLastName() ?? '',
    email: session.getUserEmail() ?? '',
    contactNo: session.getUserPhoneNumber(),
    address: session.getUserAddress() ?? '',
    // profileImage can be null initially
    profileImage: session.getUserProfileImage() ?? '',
  );
});

// --------------------
// User Profile Screen
// --------------------
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;

  // --------------------
  // Pick & Upload Profile Image
  // --------------------
  Future<void> _pickImage(AuthEntity user) async {
    if (user.authId == null) return;

    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Select Image Source",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );

    if (option != null) {
      final pickedFile =
          await _picker.pickImage(source: option, imageQuality: 80);
      if (pickedFile != null) {
        setState(() => _pickedImage = File(pickedFile.path));
        setState(() => _uploading = true);

        final updateResult = await ref
            .read(updateProfilePictureUsecaseProvider)
            .call(UpdateProfilePictureUsecaseParams(
              authId: user.authId!,
              imageFile: File(pickedFile.path),
            ));

        updateResult.fold(
          (failure) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message))),
          (updatedUser) async {
            // Save updated profile image locally
            await ref
                .read(userSessionServiceProvider)
                .saveProfileImage(updatedUser.profileImage!);

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Profile updated")));

            // Refresh the current user provider
            setState(() {});
          },
        );

        setState(() => _uploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Image
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : (user.profileImage != null &&
                                  user.profileImage!.isNotEmpty
                              ? NetworkImage(user.profileImage!)
                              : const AssetImage(
                                  'assets/images/profile.jpg'))
                              as ImageProvider<Object>?,
                      child: (user.profileImage == null ||
                                  user.profileImage!.isEmpty) &&
                              _pickedImage == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _pickImage(user),
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildReadOnlyField("First Name", user.firstName),
                _buildReadOnlyField("Last Name", user.lastName),
                _buildReadOnlyField("Address", user.address ?? ""),
                _buildReadOnlyField("Contact No", user.contactNo ?? ""),
                _buildReadOnlyField("Email", user.email),
                _buildReadOnlyField(
                    "Password", user.password != null ? "********" : ""),
              ],
            ),
          ),
          if (_uploading)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    final controller = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
