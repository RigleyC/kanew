/// Centralized form validators for reuse across the app.
class FormValidators {
  /// Validates email format.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email obrigatório';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email inválido';
    }

    return null;
  }

  /// Validates password with minimum length.
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Senha obrigatória';
    }

    if (value.length < minLength) {
      return 'Mínimo $minLength caracteres';
    }

    return null;
  }

  /// Validates password confirmation matches.
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação obrigatória';
    }

    if (value != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  /// Generic required field validator.
  static String? required(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName obrigatório';
    }
    return null;
  }

  /// Validates full name (at least 2 words).
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome obrigatório';
    }

    final words = value.trim().split(' ').where((w) => w.isNotEmpty).toList();
    if (words.length < 2) {
      return 'Digite nome e sobrenome';
    }

    return null;
  }

  /// Validates verification code format.
  static String? verificationCode(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) {
      return 'Código obrigatório';
    }

    if (value.trim().length < length) {
      return 'Código deve ter $length caracteres';
    }

    return null;
  }
}
