import 'package:flutter_riverpod/legacy.dart';

import '../../../core/usecase/base_usecase.dart';
import '../../../domain/auth/usecases/forgot_password_usecase.dart';
import '../../../domain/auth/usecases/login_usecase.dart';
import '../../../domain/auth/usecases/logout_usecase.dart';
import '../../../domain/auth/usecases/register_usecase.dart';
import '../../../injection/app_providers.dart';
import '../states/auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(loginUseCaseProvider),
    ref.watch(registerUseCaseProvider),
    ref.watch(forgotPasswordUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(
    this._loginUseCase,
    this._registerUseCase,
    this._forgotPasswordUseCase,
    this._logoutUseCase,
  ) : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    final result = await _loginUseCase(LoginParams(email: email, password: password));

    return result.when(
      success: (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          successMessage: 'Login successful. Welcome back.',
          clearError: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          clearSuccess: true,
        );
        return false;
      },
    );
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    final result = await _registerUseCase(
      RegisterParams(name: name, email: email, password: password),
    );

    return result.when(
      success: (user) {
        state = state.copyWith(
          user: user,
          isLoading: false,
          successMessage: 'Registration successful.',
          clearError: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          clearSuccess: true,
        );
        return false;
      },
    );
  }

  Future<bool> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));

    return result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Password reset instruction has been simulated successfully.',
          clearError: true,
        );
        return true;
      },
      failure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          clearSuccess: true,
        );
        return false;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true, clearSuccess: true);
    await _logoutUseCase(const NoParams());
    state = const AuthState();
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}
