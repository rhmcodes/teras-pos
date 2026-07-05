import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase extends BaseUseCase<void, NoParams> {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<void>> call(NoParams params) {
    return _repository.logout();
  }
}
