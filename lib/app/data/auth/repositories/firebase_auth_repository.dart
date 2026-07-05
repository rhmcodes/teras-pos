import '../../../core/failures/failure.dart';
import '../../../core/result/result.dart';
import '../../../domain/auth/entities/app_user.dart';
import '../../../domain/auth/repositories/auth_repository.dart';

/// Firebase-ready extension point.
///
/// This class intentionally does not import Firebase packages so the app can run
/// without Firebase Console setup. Replace the body with Firebase Auth calls
/// when the project is moved from dummy/local mode to Firebase mode.
class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository();

  Failure get _notConfigured => const Failure(
        message: 'Firebase Auth is not configured. Use DummyAuthRepository for technical test mode.',
        code: 'firebase-not-configured',
      );

  @override
  Future<Result<AppUser>> login({required String email, required String password}) async {
    return Failed<AppUser>(_notConfigured);
  }

  @override
  Future<Result<AppUser>> register({required String name, required String email, required String password}) async {
    return Failed<AppUser>(_notConfigured);
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    return Failed<void>(_notConfigured);
  }

  @override
  Future<Result<void>> logout() async {
    return Failed<void>(_notConfigured);
  }

  @override
  Future<Result<AppUser?>> getCurrentUser() async {
    return Failed<AppUser?>(_notConfigured);
  }
}
