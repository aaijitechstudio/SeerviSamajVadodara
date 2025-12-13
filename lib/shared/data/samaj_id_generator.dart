import 'dart:math';

/// Utility class for generating Samaj IDs
class SamajIdGenerator {
  SamajIdGenerator._();

  /// Generate a unique Samaj ID
  /// Format: SKV-XXXX-XXXX (SKV = Seervi Kshatriya Vadodara)
  static String generateSamajId() {
    final random = Random();
    final part1 = _generateRandomPart(random);
    final part2 = _generateRandomPart(random);
    return 'SKV-$part1-$part2';
  }

  /// Generate a 4-character random alphanumeric string
  static String _generateRandomPart(Random random) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Validate Samaj ID format
  static bool isValidSamajId(String samajId) {
    final pattern = RegExp(r'^SKV-[A-Z0-9]{4}-[A-Z0-9]{4}$');
    return pattern.hasMatch(samajId);
  }
}
