import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends BaseUseCase<AppUser, LoginParams> {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}

class LoginParams {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;
}
