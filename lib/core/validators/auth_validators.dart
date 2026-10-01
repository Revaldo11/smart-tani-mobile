abstract final class AuthValidators {
  static String? required(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi.';
    }

    return null;
  }

  static String? login(String? value) {
    final loginValue = value?.trim() ?? '';

    if (loginValue.isEmpty) {
      return 'Email atau nomor HP wajib diisi.';
    }

    return loginValue.contains('@')
        ? email(loginValue)
        : phone(loginValue);
  }

  static String? email(String? value) {
    final emailValue = value?.trim() ?? '';

    if (emailValue.isEmpty) {
      return 'Email wajib diisi.';
    }

    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!regex.hasMatch(emailValue)) {
      return 'Format email tidak valid.';
    }

    return null;
  }

  static String? phone(String? value) {
    final phoneValue = value?.trim() ?? '';

    if (phoneValue.isEmpty) {
      return 'Nomor HP wajib diisi.';
    }

    final regex = RegExp(r'^\+?[0-9]{8,15}$');

    if (!regex.hasMatch(phoneValue)) {
      return 'Format nomor HP tidak valid.';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi.';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter.';
    }

    return null;
  }

  static String? passwordConfirmation(
    String? value,
    String password,
  ) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi.';
    }

    if (value != password) {
      return 'Konfirmasi password tidak sama.';
    }

    return null;
  }
}
