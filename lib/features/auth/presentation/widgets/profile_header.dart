import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/presentation/pages/user_profile_screen.dart';

class ProfileHeader extends ConsumerStatefulWidget {
  const ProfileHeader({super.key});

  @override
  ConsumerState<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  ImageProvider<Object>? _resolveProfileImageProvider(String? profileImage) {
    final p = profileImage;
    if (p == null || p.isEmpty) return null;

    try {
      if (p.startsWith('http://') || p.startsWith('https://')) {
        return NetworkImage(p);
      }

      if (p.startsWith('file://')) {
        final filePath = Uri.parse(p).toFilePath();
        return FileImage(File(filePath));
      }

      final origin = Uri.parse(ApiEndpoints.baseUrl).origin;
      final candidate = p.startsWith('/') ? p : '/$p';
      final url = '$origin$candidate';
      return NetworkImage(url);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.read(userSessionServiceProvider);
    final firstName = (session.getFirstName() ?? '').trim();
    final lastName = (session.getUserLastName() ?? '').trim();
    final fullName = ('$firstName $lastName').trim();
    final profileImage = session.getUserProfileImage();
    final imageProvider = _resolveProfileImageProvider(profileImage);

    return InkWell(
      onTap: () async {
        // Navigate to UserProfileScreen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UserProfileScreen(),
          ),
        );

        if (!mounted) return;
        setState(() {});
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: imageProvider,
            child:
                imageProvider == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Show Profile',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
