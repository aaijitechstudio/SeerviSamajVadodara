/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Exception thrown when a network request fails
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when Firebase operation fails
class AppFirebaseException extends AppException {
  const AppFirebaseException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  const AuthenticationException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when authorization fails (permission denied)
class AuthorizationException extends AppException {
  const AuthorizationException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when a resource is not found
class NotFoundException extends AppException {
  const NotFoundException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when a configuration is missing or invalid
class ConfigurationException extends AppException {
  const ConfigurationException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Exception thrown when an operation times out
class TimeoutException extends AppException {
  const TimeoutException(
    super.message, {
    super.code,
    super.originalError,
  });
}

/// Generic exception for unknown errors
class UnknownException extends AppException {
  const UnknownException(
    super.message, {
    super.code,
    super.originalError,
  });
}
