import 'package:flutter_test/flutter_test.dart';
import 'package:smart_gst/core/security/password_hasher.dart';

void main() {
  group('PBKDF2 Password Hasher Security Tests', () {
    test('Generates random 16-byte hex salts', () {
      final salt1 = PasswordHasher.generateSalt();
      final salt2 = PasswordHasher.generateSalt();

      expect(salt1.isNotEmpty, isTrue);
      expect(salt2.isNotEmpty, isTrue);
      expect(salt1.length, 32); // 16 bytes = 32 hex chars
      expect(salt2.length, 32);
      expect(salt1, isNot(equals(salt2)));
    });

    test('Hashes password deterministically with given salt', () {
      final salt = PasswordHasher.generateSalt();
      const password = 'AdminPassword@123!';

      final hash1 = PasswordHasher.hashPassword(password, salt);
      final hash2 = PasswordHasher.hashPassword(password, salt);

      expect(hash1, equals(hash2));
      expect(hash1.length, 64); // 256-bit SHA256 = 64 hex chars
    });

    test('Different salts produce different hashes for same password', () {
      final salt1 = PasswordHasher.generateSalt();
      final salt2 = PasswordHasher.generateSalt();
      const password = 'SecurePassword456#';

      final hash1 = PasswordHasher.hashPassword(password, salt1);
      final hash2 = PasswordHasher.hashPassword(password, salt2);

      expect(hash1, isNot(equals(hash2)));
    });

    test('Verifies valid password successfully', () {
      final salt = PasswordHasher.generateSalt();
      const password = 'CorrectPassword999';

      final hash = PasswordHasher.hashPassword(password, salt);
      final isValid = PasswordHasher.verifyPassword(password, salt, hash);

      expect(isValid, isTrue);
    });

    test('Rejects incorrect password', () {
      final salt = PasswordHasher.generateSalt();
      const password = 'CorrectPassword999';
      const wrongPassword = 'WrongPassword000';

      final hash = PasswordHasher.hashPassword(password, salt);
      final isValid = PasswordHasher.verifyPassword(wrongPassword, salt, hash);

      expect(isValid, isFalse);
    });
  });
}
