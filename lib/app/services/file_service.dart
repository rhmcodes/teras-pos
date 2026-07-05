class FileService {
  Future<String> saveCsv({
    required String fileName,
    required String content,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return 'simulated-downloads/$fileName';
  }
}
