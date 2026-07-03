import "package:isar/isar.dart";

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;

  late String name;
  late String email;
  late String password;
  late String role;

  // Fecha en que se registró el usuario
  DateTime registerDate = DateTime.now();

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}