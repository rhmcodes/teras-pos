import '../../../core/exceptions/error_handler.dart';
import '../../../core/result/result.dart';
import '../../../domain/location/entities/location_snapshot.dart';
import '../../../domain/location/repositories/location_repository.dart';
import '../../../services/location_service.dart';

class DummyLocationRepository implements LocationRepository {
  DummyLocationRepository(this._locationService);

  final LocationService _locationService;

  @override
  Future<Result<LocationSnapshot>> getCurrentLocation() async {
    try {
      final snapshot = await _locationService.getCurrentLocation();
      return Success<LocationSnapshot>(snapshot);
    } catch (error) {
      return Failed<LocationSnapshot>(ErrorHandler.fromException(error));
    }
  }
}
