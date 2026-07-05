class AppConfig {
  const AppConfig._();

  static const String appName = 'Teras POS';
  static const String packageName = 'teras_pos';
  static const String appVersion = '1.0.4+5';
  static const String projectStage = 'Technical Test MVP';

  /// Keep this false for the technical-test build so the app can run without
  /// Firebase Console, google-services.json, or FirebaseOptions setup.
  static const bool useFirebaseRepositories = false;

  static const String backendMode = useFirebaseRepositories ? 'Firebase Repository' : 'Dummy Local Repository';
  static const String firebaseStatus = 'Prepared as optional extension point';
}
