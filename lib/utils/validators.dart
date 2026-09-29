class AppValidators {
  /// Validates standard 15-character Indian GSTIN format:
  /// 2 digits (state code) + 5 letters (PAN) + 4 digits (PAN) + 1 letter (PAN) + 1 digit/letter (entity code) + 'Z' + 1 check digit
  static String? validateGstin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional unless required
    }
    final trimmed = value.trim().toUpperCase();
    final gstinRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    if (!gstinRegex.hasMatch(trimmed)) {
      return 'Enter a valid 15-digit Indian GSTIN (e.g. 27AABCF1234F1Z5)';
    }
    return null;
  }

  /// Validates 10-character Indian PAN format: 5 letters + 4 digits + 1 letter
  static String? validatePan(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final trimmed = value.trim().toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(trimmed)) {
      return 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
    }
    return null;
  }

  /// Validates Indian 10-digit mobile number
  static String? validatePhone(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) return 'Phone number is required';
      return null;
    }
    final trimmed = value.trim().replaceAll(RegExp(r'\s+|-'), '');
    final phoneRegex = RegExp(r'^[6-9]\d{9}$');
    if (!phoneRegex.hasMatch(trimmed)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  /// Validates 6-digit Indian PIN Code
  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final trimmed = value.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(trimmed)) {
      return 'Enter a valid 6-digit PIN code';
    }
    return null;
  }

  /// Validates required text
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates positive numeric value
  static String? validatePositiveNumber(String? value, String fieldName, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final numVal = double.tryParse(value.trim());
    if (numVal == null) {
      return 'Enter a valid number for $fieldName';
    }
    if (allowZero ? numVal < 0 : numVal <= 0) {
      return '$fieldName must be ${allowZero ? 'zero or positive' : 'greater than zero'}';
    }
    return null;
  }

  /// Validates integer quantity
  static String? validateInteger(String? value, String fieldName, {bool allowZero = true}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final intVal = int.tryParse(value.trim());
    if (intVal == null) {
      return 'Enter a valid whole number for $fieldName';
    }
    if (allowZero ? intVal < 0 : intVal <= 0) {
      return '$fieldName must be ${allowZero ? '0 or greater' : 'greater than 0'}';
    }
    return null;
  }

  /// Validates email address
  static String? validateEmail(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      if (required) return 'Email address is required';
      return null;
    }
    final trimmed = value.trim();
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }
}

