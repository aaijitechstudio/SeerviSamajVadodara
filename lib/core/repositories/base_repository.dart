import '../errors/failure.dart';

/// Base repository interface
/// All repositories should implement this interface
/// Provides common CRUD operations
abstract class BaseRepository<T, ID> {
  /// Get a single entity by ID
  Future<({Failure? failure, T? data})> getById(ID id);

  /// Get all entities
  Future<({Failure? failure, List<T>? data})> getAll();

  /// Create a new entity
  Future<({Failure? failure, T? data})> create(T entity);

  /// Update an existing entity
  Future<({Failure? failure, T? data})> update(ID id, T entity);

  /// Delete an entity by ID
  Future<({Failure? failure, bool? success})> delete(ID id);
}

/// Repository result wrapper
/// Used to return either data or failure
class RepositoryResult<T> {
  final T? data;
  final Failure? failure;

  const RepositoryResult({
    this.data,
    this.failure,
  });

  bool get isSuccess => failure == null && data != null;
  bool get isFailure => failure != null;

  /// Create success result
  factory RepositoryResult.success(T data) {
    return RepositoryResult(data: data);
  }

  /// Create failure result
  factory RepositoryResult.failure(Failure failure) {
    return RepositoryResult(failure: failure);
  }
}
