import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:recell_bazar/core/usecase/app_usecase.dart';
import 'package:recell_bazar/features/auth/data/repositories/auth_repository.dart';
import 'package:recell_bazar/features/auth/domain/entities/auth_entity.dart';
import 'package:recell_bazar/features/auth/domain/repositories/auth_repository.dart';

// Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final userSession = ref.read(userSessionServiceProvider);
  return GetCurrentUserUsecase(
    authRepository: authRepository,
    userSession: userSession,
  );
});

class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;
  final UserSessionServices _userSession;

  GetCurrentUserUsecase({
    required IAuthRepository authRepository,
    required UserSessionServices userSession,
  })  : _authRepository = authRepository,
        _userSession = userSession;

  // No stray getter here - use `_userSession.getUserId()` inside `call()`.

  @override
  Future<Either<Failure, AuthEntity>> call() async {
    // Get userId from SharedPreferences
    final authId = _userSession.getUserId();

    print("GetCurrentUserUsecase: Current User ID = $authId");


    if (authId == null) {
      return Left(LocalDatabaseFailure(message: "No current user found"));
    }

    // Fetch user from repository
    return _authRepository.getCurrentUser(authId);
  }
}
