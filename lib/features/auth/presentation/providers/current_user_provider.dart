

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';

final currentUserProvider = Provider<AuthEntity>((ref) {
  final session = ref.read(userSessionServiceProvider);

  return AuthEntity(
    authId: session.getUserId(),
    firstName: session.getFirstName() ?? '',
    lastName: session.getUserLastName() ?? '',
    email: session.getUserEmail() ?? '',
    contactNo: session.getUserPhoneNumber() ?? '',
    address: session.getUserAddress() ?? '',
  );
});
