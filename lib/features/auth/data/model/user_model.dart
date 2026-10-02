class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  static String? _asNullableString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    return value.toString();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: _asNullableString(json['phone']),
      avatarUrl: _asNullableString(json['avatar_url']),
    );
  }
}
