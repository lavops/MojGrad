
class User {
  final int id;
  final String username;
  final String password;
  final String name;

  User({
    this.id,
    this.username,
    this.password,
    this.name
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
    );
  }
}