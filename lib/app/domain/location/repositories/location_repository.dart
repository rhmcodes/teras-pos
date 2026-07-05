import '../../../core/result/result.dart';
import '../entities/location_snapshot.dart';

abstract class LocationRepository {
  Future<Result<LocationSnapshot>> getCurrentLocation();
}
