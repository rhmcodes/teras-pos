import '../../../core/result/result.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<void>> forgotPassword({required String email});

  Future<Result<void>> logout();

  Future<Result<AppUser?>> getCurrentUser();
}
