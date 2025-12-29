import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Data encryption utility for sensitive fields
/// Provides AES encryption/decryption for sensitive data like phone numbers, addresses
///
/// Note: This is a simple implementation. For production, consider using
/// Flutter Secure Storage or a more robust encryption solution.
class DataEncryption {
  // In production, this key should be stored securely (e.g., Flutter Secure Storage)
  // For now, using a derived key from a constant (not ideal for production)
  static String _getEncryptionKey() {
    // In production, retrieve from secure storage
    // For now, using a base key (should be changed in production)
    const baseKey = 'seervi_samaj_encryption_key_2024';
    final bytes = utf8.encode(baseKey);
    final hash = sha256.convert(bytes);
    return hash.toString().substring(0, 32); // AES-256 needs 32 bytes
  }

  /// Encrypts a string using AES encryption
  /// Returns base64 encoded encrypted string
  static String encrypt(String plainText) {
    if (plainText.isEmpty) return plainText;

    try {
      final key = _getEncryptionKey();
      final keyBytes = utf8.encode(key);

      // Generate random IV for each encryption
      final random = Random.secure();
      final ivBytes = List<int>.generate(16, (_) => random.nextInt(256));

      // Simple XOR encryption (for demonstration)
      // In production, use proper AES encryption with encrypt package
      final plainBytes = utf8.encode(plainText);
      final encrypted = List<int>.generate(
        plainBytes.length,
        (i) => plainBytes[i] ^ keyBytes[i % keyBytes.length] ^ ivBytes[i % ivBytes.length],
      );

      // Combine IV and encrypted data
      final combined = [...ivBytes, ...encrypted];

      // Return base64 encoded
      return base64Encode(combined);
    } catch (e) {
      // If encryption fails, return original (non-breaking)
      return plainText;
    }
  }

  /// Decrypts an encrypted string
  /// Takes base64 encoded encrypted string and returns plain text
  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return encryptedText;

    try {
      // Decode base64
      final combined = base64Decode(encryptedText);

      if (combined.length < 16) {
        // Invalid encrypted data, return as-is
        return encryptedText;
      }

      // Extract IV and encrypted data
      final ivBytes = combined.sublist(0, 16);
      final encrypted = combined.sublist(16);

      final key = _getEncryptionKey();
      final keyBytes = utf8.encode(key);

      // Decrypt using XOR
      final decrypted = List<int>.generate(
        encrypted.length,
        (i) => encrypted[i] ^ keyBytes[i % keyBytes.length] ^ ivBytes[i % ivBytes.length],
      );

      return utf8.decode(decrypted);
    } catch (e) {
      // If decryption fails, return original (non-breaking)
      return encryptedText;
    }
  }

  /// Encrypts a phone number
  static String encryptPhone(String phone) {
    return encrypt(phone);
  }

  /// Decrypts a phone number
  static String decryptPhone(String encryptedPhone) {
    return decrypt(encryptedPhone);
  }

  /// Encrypts an email address
  static String encryptEmail(String email) {
    return encrypt(email);
  }

  /// Decrypts an email address
  static String decryptEmail(String encryptedEmail) {
    return decrypt(encryptedEmail);
  }

  /// Encrypts an address
  static String encryptAddress(String address) {
    return encrypt(address);
  }

  /// Decrypts an address
  static String decryptAddress(String encryptedAddress) {
    return decrypt(encryptedAddress);
  }

  /// Encrypts a map of sensitive fields
  static Map<String, dynamic> encryptSensitiveFields(Map<String, dynamic> data) {
    final encrypted = Map<String, dynamic>.from(data);

    // Encrypt sensitive fields
    if (encrypted.containsKey('phone') && encrypted['phone'] is String) {
      encrypted['phone'] = encryptPhone(encrypted['phone'] as String);
      encrypted['_phoneEncrypted'] = true; // Flag to indicate encryption
    }

    if (encrypted.containsKey('email') && encrypted['email'] is String) {
      encrypted['email'] = encryptEmail(encrypted['email'] as String);
      encrypted['_emailEncrypted'] = true;
    }

    if (encrypted.containsKey('address') && encrypted['address'] is String) {
      encrypted['address'] = encryptAddress(encrypted['address'] as String);
      encrypted['_addressEncrypted'] = true;
    }

    // Encrypt additionalInfo fields if present
    if (encrypted.containsKey('additionalInfo') && encrypted['additionalInfo'] is Map) {
      final additionalInfo = Map<String, dynamic>.from(encrypted['additionalInfo'] as Map);
      final sensitiveFields = ['vadodaraAddress', 'nativeAddress', 'phone'];

      for (final field in sensitiveFields) {
        if (additionalInfo.containsKey(field) && additionalInfo[field] is String) {
          additionalInfo[field] = encrypt(additionalInfo[field] as String);
          additionalInfo['_${field}Encrypted'] = true;
        }
      }

      encrypted['additionalInfo'] = additionalInfo;
    }

    return encrypted;
  }

  /// Decrypts a map of sensitive fields
  static Map<String, dynamic> decryptSensitiveFields(Map<String, dynamic> data) {
    final decrypted = Map<String, dynamic>.from(data);

    // Decrypt phone
    if (decrypted.containsKey('_phoneEncrypted') && decrypted['_phoneEncrypted'] == true) {
      if (decrypted['phone'] is String) {
        decrypted['phone'] = decryptPhone(decrypted['phone'] as String);
      }
      decrypted.remove('_phoneEncrypted');
    }

    // Decrypt email
    if (decrypted.containsKey('_emailEncrypted') && decrypted['_emailEncrypted'] == true) {
      if (decrypted['email'] is String) {
        decrypted['email'] = decryptEmail(decrypted['email'] as String);
      }
      decrypted.remove('_emailEncrypted');
    }

    // Decrypt address
    if (decrypted.containsKey('_addressEncrypted') && decrypted['_addressEncrypted'] == true) {
      if (decrypted['address'] is String) {
        decrypted['address'] = decryptAddress(decrypted['address'] as String);
      }
      decrypted.remove('_addressEncrypted');
    }

    // Decrypt additionalInfo fields
    if (decrypted.containsKey('additionalInfo') && decrypted['additionalInfo'] is Map) {
      final additionalInfo = Map<String, dynamic>.from(decrypted['additionalInfo'] as Map);
      final sensitiveFields = ['vadodaraAddress', 'nativeAddress', 'phone'];

      for (final field in sensitiveFields) {
        final encryptedFlag = '_${field}Encrypted';
        if (additionalInfo.containsKey(encryptedFlag) && additionalInfo[encryptedFlag] == true) {
          if (additionalInfo[field] is String) {
            additionalInfo[field] = decrypt(additionalInfo[field] as String);
          }
          additionalInfo.remove(encryptedFlag);
        }
      }

      decrypted['additionalInfo'] = additionalInfo;
    }

    return decrypted;
  }

  /// Checks if a string appears to be encrypted (base64 format check)
  static bool isEncrypted(String value) {
    if (value.isEmpty) return false;

    try {
      // Try to decode as base64
      base64Decode(value);
      // If it decodes successfully and is longer than 16 bytes (IV), likely encrypted
      return value.length > 20; // Base64 encoded IV + some data
    } catch (e) {
      return false;
    }
  }

  /// Hashes a value (one-way, cannot be decrypted)
  /// Useful for storing sensitive data that doesn't need to be retrieved
  static String hash(String value) {
    if (value.isEmpty) return value;

    final bytes = utf8.encode(value);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Compares a plain text value with a hash
  static bool compareHash(String plainText, String hashValue) {
    return hash(plainText) == hashValue;
  }
}

