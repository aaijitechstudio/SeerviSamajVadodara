import 'app_exceptions.dart';

/// Represents a failure/error result in a functional programming style
/// Used for better error handling in repositories and use cases
abstract class Failure {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  /// Convert exception to failure
  factory Failure.fromException(AppException exception) {
    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is AppFirebaseException) {
      return FirebaseFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is AuthenticationException) {
      return AuthenticationFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is AuthorizationException) {
      return AuthorizationFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is NotFoundException) {
      return NotFoundFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is ConfigurationException) {
      return ConfigurationFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else if (exception is TimeoutException) {
      return TimeoutFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    } else {
      return UnknownFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError,
      );
    }
  }

  /// Convert generic exception to failure
  factory Failure.fromError(dynamic error) {
    if (error is AppException) {
      return Failure.fromException(error);
    } else if (error is Exception) {
      return UnknownFailure(
        message: error.toString(),
        originalError: error,
      );
    } else {
      return UnknownFailure(
        message: 'An unknown error occurred',
        originalError: error,
      );
    }
  }
}

/// Network-related failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Firebase-related failure
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Authentication-related failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Authorization-related failure
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Resource not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Configuration failure
class ConfigurationFailure extends Failure {
  const ConfigurationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}
