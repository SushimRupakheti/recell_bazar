import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/features/auth/domain/usecases/get_current_user.dart';
import 'package:recell_bazar/features/auth/domain/usecases/login_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:recell_bazar/features/auth/domain/usecases/register_usecase.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String password,
    required String contactNo,
    String? batchId,
  }) async {
    // ✅ RESET STATE FIRST
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _registerUsecase(
      RegisterUsecaseParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        address: address,
        password: password,
        contactNo: contactNo,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: AuthStatus.registered,
        errorMessage: null,
      ),
    );
  }

Future<void> login({
  required String email,
  required String password,
}) async {
  state = state.copyWith(
    status: AuthStatus.loading,
    errorMessage: null,
  );

  final result = await _loginUsecase(
    LoginUsecaseParams(email: email, password: password),
  );

  result.fold(
    (failure) => state = state.copyWith(
      status: AuthStatus.error,
      errorMessage: failure.message,
    ),
    (user) => state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: null,
    ),
  );
}

Future<void> getCurrentUser() async {
  state = state.copyWith(status: AuthStatus.loading);

  try {
    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) async{
        // backend didn't find the user
        await ref.read(logoutUsecaseProvider)(); // clear local storage
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
          errorMessage: failure.message,
        );
      },
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  } catch (e) {
    // unexpected error
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: e.toString(),
    );
  }
}

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      ),
    );
  }
}
