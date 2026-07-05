import '../domain/location/entities/location_snapshot.dart';

class LocationService {
  Future<LocationSnapshot> getCurrentLocation() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));

    return const LocationSnapshot(
      latitude: -6.200000,
      longitude: 106.816666,
      locationName: 'Jakarta Store Demo',
    );
  }
}
