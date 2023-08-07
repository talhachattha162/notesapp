class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  // Convert the User object to a map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  // Create a User object from a map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
    );
  }
}
