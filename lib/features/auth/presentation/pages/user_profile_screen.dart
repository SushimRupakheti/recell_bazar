import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/usecases/update_profile_image_usecase.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/auth/data/datasources/remote/auth_remote_datasource.dart';

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
    contactNo: session.getUserPhoneNumber() ?? '',
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

  ImageProvider<Object>? _resolveProfileImageProvider(AuthEntity user) {
    // If user picked an image this session, use it
    if (_pickedImage != null) return FileImage(_pickedImage!);

    final p = user.profileImage;
    if (p == null || p.isEmpty) return null;

    try {
      // Absolute http(s) URL
      if (p.startsWith('http://') || p.startsWith('https://')) return NetworkImage(p);

      // file:// URI on device
      if (p.startsWith('file://')) {
        final filePath = Uri.parse(p).toFilePath();
        return FileImage(File(filePath));
      }

      // Relative path returned from backend (e.g. /uploads/xxx.jpg or uploads/xxx.jpg)
      final origin = Uri.parse(ApiEndpoints.baseUrl).origin; // e.g. http://10.0.2.2:5050
      final candidate = p.startsWith('/') ? p : '/$p';
      final url = '$origin$candidate';
      return NetworkImage(url);
    } catch (e) {
      return null;
    }
  }

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

  // --------------------
  // Show Update Profile Dialog
  // --------------------
  Future<void> _showUpdateDialog(AuthEntity user) async {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final contactNoController = TextEditingController(text: user.contactNo);
    final addressController = TextEditingController(text: user.address);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Update Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: user.email),
                  decoration: const InputDecoration(
                    labelText: "Email (cannot be changed)",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFE0E0E0),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: contactNoController,
                  decoration: const InputDecoration(
                    labelText: "Contact No",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != true) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Are you sure you want to update your profile?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || user.authId == null) return;

    setState(() => _uploading = true);

    try {
      final updatedUser = await ref
          .read(authRemoteDataSourceProvider)
          .updateUser(user.authId!, {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'contactNo': contactNoController.text.trim(),
        'address': addressController.text.trim(),
      });

      if (updatedUser != null) {
        // Update local session
        final session = ref.read(userSessionServiceProvider);
        await session.saveUserSession(
          userId: updatedUser.id!,
          email: updatedUser.email,
          firstName: updatedUser.firstName,
          lastName: updatedUser.lastName,
          contactNo: updatedUser.contactNo,
          address: updatedUser.address,
          profileImage: updatedUser.profileImage,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
          setState(() {});
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update profile")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => _uploading = false);
  }

  // --------------------
  // Show Change Password Dialog
  // --------------------
  Future<void> _showChangePasswordDialog(AuthEntity user) async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: oldPasswordController,
                    obscureText: obscureOld,
                    decoration: InputDecoration(
                      labelText: "Current Password",
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(obscureOld ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setDialogState(() => obscureOld = !obscureOld),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setDialogState(() => obscureNew = !obscureNew),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setDialogState(() => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(null),
                        child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          final oldPw = oldPasswordController.text.trim();
                          final newPw = newPasswordController.text.trim();
                          final confirmPw = confirmPasswordController.text.trim();

                          if (oldPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("All fields are required")),
                            );
                            return;
                          }
                          if (newPw.length < 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("New password must be at least 6 characters")),
                            );
                            return;
                          }
                          if (newPw != confirmPw) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("New passwords do not match")),
                            );
                            return;
                          }
                          Navigator.of(ctx).pop({
                            'oldPassword': oldPw,
                            'newPassword': newPw,
                          });
                        },
                        child: const Text("Change", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (result == null || user.authId == null) return;

    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Password Change"),
        content: const Text("Are you sure you want to change your password?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _uploading = true);

    try {
      // Verify current password by attempting login
      dynamic loginResult;
      try {
        loginResult = await ref
            .read(authRemoteDataSourceProvider)
            .login(user.email, result['oldPassword']!);
      } catch (_) {
        loginResult = null;
      }

      if (loginResult == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Current password is incorrect")),
          );
        }
        setState(() => _uploading = false);
        return;
      }

      // Current password verified — now update with new password
      final updatedUser = await ref
          .read(authRemoteDataSourceProvider)
          .updateUser(user.authId!, {
        'password': result['newPassword'],
      });

      if (updatedUser != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password changed successfully")),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to change password")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Read session directly to ensure latest SharedPreferences values are used
    final session = ref.read(userSessionServiceProvider);
    final user = AuthEntity(
      authId: session.getUserId(),
      firstName: session.getFirstName() ?? '',
      lastName: session.getUserLastName() ?? '',
      email: session.getUserEmail() ?? '',
      contactNo: session.getUserPhoneNumber() ?? '',
      address: session.getUserAddress() ?? '',
      profileImage: session.getUserProfileImage() ?? '',
    );

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
                      backgroundImage: _resolveProfileImageProvider(user),
                      child: _resolveProfileImageProvider(user) == null
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
                              shape: BoxShape.circle, color: Color(0xFF0B7C7C)),
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
                _buildReadOnlyField("Address", user.address),
                _buildReadOnlyField("Contact No", user.contactNo),
                _buildReadOnlyField("Email", user.email),
                _buildReadOnlyField("Password", "**********"),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _showUpdateDialog(user),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text(
                      "Update Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      side: const BorderSide(color: Colors.teal, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _showChangePasswordDialog(user),
                    icon: const Icon(Icons.lock_outline),
                    label: const Text(
                      "Change Password",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
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
