# Testing Guide

This directory contains all tests for the Seervi Kshatriya Samaj Vadodara application.

## Directory Structure

```
test/
├── helpers/          # Test utility functions and helpers
├── mocks/            # Mock objects for testing
├── unit/             # Unit tests for business logic
├── widget/           # Widget tests for UI components
└── integration/      # Integration tests for full flows
```

## Running Tests

### Run all tests

```bash
flutter test
```

### Run specific test file

```bash
flutter test test/unit/core/utils/app_utils_test.dart
```

### Run tests with coverage

```bash
flutter test --coverage
```

### Generate coverage report

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

### Unit Tests

Test individual functions, classes, and utilities in isolation.

**Location:** `test/unit/`

**Examples:**

- Utility functions
- Business logic
- Model serialization
- Error handling

### Widget Tests

Test UI components and widgets.

**Location:** `test/widget/`

**Examples:**

- Custom widgets
- Form validation
- User interactions

### Integration Tests

Test complete user flows and feature interactions.

**Location:** `test/integration/`

**Examples:**

- Authentication flow
- Complete feature workflows
- End-to-end scenarios

## Test Helpers

### TestHelpers

Utility functions for common testing scenarios:

- `createContainer()` - Create ProviderContainer for testing
- `createMockDate()` - Create mock dates
- `waitFor()` - Wait for async operations

### CustomMatchers

Custom matchers for assertions:

- `isValidEmail` - Validate email format
- `isValidPhone` - Validate phone format

## Mocking

We use `mocktail` for creating mocks without code generation.

**Example:**

```dart
import 'package:mocktail/mocktail.dart';

class MockFirebaseService extends Mock implements FirebaseService {}
```

## Best Practices

1. **Test naming:** Use descriptive test names that explain what is being tested
2. **Arrange-Act-Assert:** Structure tests with clear sections
3. **Isolation:** Each test should be independent
4. **Coverage:** Aim for high coverage of critical business logic
5. **Maintainability:** Keep tests simple and readable

## Writing New Tests

1. Create test file in appropriate directory
2. Import necessary packages and test helpers
3. Write test cases using `test()` or `group()`
4. Use `expect()` for assertions
5. Run tests to verify they pass

## Example Test Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName', () {
    test('should do something when condition is met', () {
      // Arrange
      final input = 'test';

      // Act
      final result = functionToTest(input);

      // Assert
      expect(result, equals('expected'));
    });
  });
}
```
