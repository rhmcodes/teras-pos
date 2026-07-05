class PermissionService {
  Future<bool> requestStoragePermission() async {
    return true;
  }

  Future<bool> requestLocationPermission() async {
    return true;
  }

  Future<bool> requestBluetoothPermission() async {
    return true;
  }
}
