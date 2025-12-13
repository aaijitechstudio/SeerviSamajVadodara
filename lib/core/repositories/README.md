# Repository Pattern

This directory contains the repository pattern implementation for the application. The repository pattern provides an abstraction layer between the data source and business logic, making the code more testable and maintainable.

## Structure

```
lib/core/repositories/
├── base_repository.dart          # Base repository interface
├── repository_providers.dart     # Riverpod providers for repositories
└── README.md                     # This file
```

## Benefits

1. **Testability**: Easy to mock repositories for unit testing
2. **Maintainability**: Centralized data access logic
3. **Flexibility**: Easy to switch data sources (Firebase, REST API, etc.)
4. **Error Handling**: Consistent error handling across all repositories
5. **Type Safety**: Strong typing with Dart's type system

## Usage

### 1. Define Repository Interface

Create an interface in the feature's data layer:

```dart
// lib/features/members/data/repositories/user_repository.dart
abstract class UserRepository {
  Future<({Failure? failure, UserModel? data})> getUserById(String userId);
  Future<({Failure? failure, List<UserModel>? data})> getAllMembers();
}
```

### 2. Implement Repository

Implement the interface using Firebase or other data sources:

```dart
// lib/features/members/data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<({Failure? failure, UserModel? data})> getUserById(String userId) async {
    try {
      // Implementation
    } catch (e) {
      final exception = ErrorHandler.handleException(e);
      final failure = ErrorHandler.exceptionToFailure(exception);
      return (failure: failure, data: null);
    }
  }
}
```

### 3. Register Repository Provider

Add to `repository_providers.dart`:

```dart
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRepositoryImpl(firestore: firestore);
});
```

### 4. Use in Providers

Use the repository in your Riverpod providers:

```dart
class MembersController extends Notifier<MembersState> {
  Future<void> loadMembers() async {
    final repository = ref.read(userRepositoryProvider);
    final result = await repository.getAllMembers();

    if (result.failure != null) {
      // Handle error
      return;
    }

    // Use result.data
  }
}
```

## Error Handling

All repositories use the centralized error handling system:

- Exceptions are converted to `Failure` objects
- Consistent error messages
- Type-safe error handling

## Return Pattern

Repositories use a record pattern for return values:

```dart
({Failure? failure, T? data})
```

This allows:

- Type-safe error handling
- Clear success/failure states
- Easy pattern matching

## Best Practices

1. **Always handle errors**: Use `ErrorHandler` for all exceptions
2. **Return records**: Use the `({failure, data})` pattern
3. **Make repositories testable**: Accept dependencies via constructor
4. **Keep interfaces focused**: One repository per domain entity
5. **Document public methods**: Add clear documentation

## Migration Guide

To migrate from `FirebaseService` to repositories:

1. Create repository interface
2. Implement repository
3. Add provider
4. Update provider to use repository
5. Test thoroughly
6. Remove old `FirebaseService` calls

## Examples

See:

- `lib/features/members/data/repositories/` - User repository example
- `lib/features/home/data/repositories/` - Post repository example
