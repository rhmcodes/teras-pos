import '../../../core/result/result.dart';
import '../../../core/usecase/base_usecase.dart';
import '../entities/location_snapshot.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocationUseCase extends BaseUseCase<LocationSnapshot, NoParams> {
  GetCurrentLocationUseCase(this._repository);

  final LocationRepository _repository;

  @override
  Future<Result<LocationSnapshot>> call(NoParams params) {
    return _repository.getCurrentLocation();
  }
}
