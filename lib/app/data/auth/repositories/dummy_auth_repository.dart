import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../datasources/auth_local_datasource.dart';
import '../../../domain/auth/entities/app_user.dart';
import '../../../domain/auth/repositories/auth_repository.dart';

class DummyAuthRepository implements AuthRepository {
  DummyAuthRepository(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _localDataSource.login(email, password);
      return Success<AppUser>(user.toEntity());
    } catch (error) {
      return Failed<AppUser>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _localDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return Success<AppUser>(user.toEntity());
    } catch (error) {
      return Failed<AppUser>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<void>> forgotPassword({required String email}) async {
    try {
      await _localDataSource.forgotPassword(email);
      return const Success<void>(null);
    } catch (error) {
      return Failed<void>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _localDataSource.logout();
      return const Success<void>(null);
    } catch (error) {
      return Failed<void>(ErrorHandler.fromException(error));
    }
  }

  @override
  Future<Result<AppUser?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCurrentUser();
      return Success<AppUser?>(user?.toEntity());
    } catch (error) {
      return Failed<AppUser?>(ErrorHandler.fromException(error));
    }
  }
}
