import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  int id;

  String name;

  String email;

  String pass;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.pass,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        pass: json['pass'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'pass': pass,
      };
}
