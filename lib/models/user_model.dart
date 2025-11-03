import 'package:hive/hive.dart';

part 'user_model.g.dart'; 

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String role;

  @HiveField(4)
  String? cooperativeName;

  @HiveField(5)
  String? cooperativeId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.cooperativeName,
    this.cooperativeId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final coop = json['cooperative'];
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      cooperativeName: coop?['name'],
      cooperativeId: coop?['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'cooperative': {'name': cooperativeName, 'id': cooperativeId},
  };
}
