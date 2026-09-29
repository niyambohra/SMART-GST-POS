import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Cryptographically secure password hasher implementing PBKDF2 with HMAC-SHA256
class PasswordHasher {
  static const int _iterations = 10000;
  static const int _saltLength = 16;
  static const int _keyLength = 32;

  /// Generates a random cryptographic salt encoded in hex
  static String generateSalt([int length = _saltLength]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (_) => random.nextInt(256));
    return values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Hashes a password with salt using PBKDF2-HMAC-SHA256
  static String hashPassword(String password, String saltHex) {
    final passwordBytes = utf8.encode(password);
    final saltBytes = _hexToBytes(saltHex);

    final derivedKey = _pbkdf2(passwordBytes, saltBytes, _iterations, _keyLength);
    return derivedKey.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Verifies a plain password against a stored salt and hash
  static bool verifyPassword(String password, String saltHex, String expectedHash) {
    final computedHash = hashPassword(password, saltHex);
    // Constant-time string comparison to prevent timing attacks
    if (computedHash.length != expectedHash.length) return false;
    int result = 0;
    for (int i = 0; i < computedHash.length; i++) {
      result |= computedHash.codeUnitAt(i) ^ expectedHash.codeUnitAt(i);
    }
    return result == 0;
  }

  static Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < hex.length; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }

  static Uint8List _pbkdf2(List<int> password, Uint8List salt, int iterations, int keyLength) {
    final hmac = Hmac(sha256, password);
    final result = Uint8List(keyLength);
    int hLen = 32; // SHA-256 output length
    int blocks = (keyLength + hLen - 1) ~/ hLen;

    int offset = 0;
    for (int block = 1; block <= blocks; block++) {
      final blockBytes = Uint8List(salt.length + 4);
      blockBytes.setRange(0, salt.length, salt);
      blockBytes[salt.length] = (block >> 24) & 0xFF;
      blockBytes[salt.length + 1] = (block >> 16) & 0xFF;
      blockBytes[salt.length + 2] = (block >> 8) & 0xFF;
      blockBytes[salt.length + 3] = block & 0xFF;

      var u = hmac.convert(blockBytes).bytes;
      var t = Uint8List.fromList(u);

      for (int i = 1; i < iterations; i++) {
        u = hmac.convert(u).bytes;
        for (int k = 0; k < hLen; k++) {
          t[k] ^= u[k];
        }
      }

      final copyLength = (offset + hLen > keyLength) ? keyLength - offset : hLen;
      result.setRange(offset, offset + copyLength, t.sublist(0, copyLength));
      offset += copyLength;
    }

    return result;
  }
}
