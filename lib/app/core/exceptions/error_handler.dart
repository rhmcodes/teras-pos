import 'app_exception.dart';
import '../failures/failure.dart';

class ErrorHandler {
  const ErrorHandler._();

  static Failure fromException(Object error) {
    if (error is AppException) {
      return Failure(message: error.message, code: error.code);
    }

    return const Failure(message: 'An unexpected error occurred.');
  }
}
