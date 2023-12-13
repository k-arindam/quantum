class QuantumUser {
  final String id;
  final String name;
  final String email;
  final String password;

  const QuantumUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory QuantumUser.fromJson(Map json) {
    return QuantumUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final json = {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };

    if (!includePassword) {
      json.remove('password');
    }

    return json;
  }
}
