import "package:isar/isar.dart";

part "log_model.g.dart";

@collection
class LogEntry {
  Id id = Isar.autoIncrement;

  late String userName;

  // "Inicio de sesión" o "Cierre de sesión"
  late String action;

  // Fecha y hora del evento
  DateTime date = DateTime.now();

  LogEntry({
    required this.userName,
    required this.action,
  });
}