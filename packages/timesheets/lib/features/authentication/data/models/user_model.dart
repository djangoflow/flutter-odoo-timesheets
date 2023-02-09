import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  String id;

  String firstName;
  String lastName;
  String displayName;

  String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        displayName: json['display_name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'displayName': displayName,
        'email': email,
      };
}
