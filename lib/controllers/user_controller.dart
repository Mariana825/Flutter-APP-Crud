import "package:isar/isar.dart";
import "../models/user_model.dart";
import "../models/log_model.dart";

class UserController {
  static final UserController _instance =
      UserController._internal();

  UserController._internal();

  factory UserController() {
    return _instance;
  }

  late Isar _isar;
  Isar get isar => _isar;

  User? currentUser;

  void init(Isar isar) {
    _isar = isar;
  }
  // REGISTRAR EN BITÁCORA
Future<void> addLog(
  String userName,
  String action,
) async {
  final log = LogEntry(
    userName: userName,
    action: action,
  );

  await _isar.writeTxn(() async {
    await _isar.logEntrys.put(log);
  });
}

  // LOGIN
Future<bool> login(
  String email,
  String password,
) async {
  final user = await _isar.users
      .filter()
      .emailEqualTo(email)
      .passwordEqualTo(password)
      .findFirst();

  if (user != null) {
    currentUser = user;

    // Registrar inicio de sesión
    await addLog(
      user.name,
      "Inicio de sesión",
    );

    return true;
  }

  return false;
}

  // CREAR
  Future<void> addUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  // ACTUALIZAR
  Future<void> updateUser(User user) async {
    await _isar.writeTxn(() async {
      await _isar.users.put(user);
    });
  }

  // ELIMINAR
  Future<void> deleteUser(int id) async {
    await _isar.writeTxn(() async {
      await _isar.users.delete(id);
    });
  }

  // OBTENER TODOS
  Future<List<User>> getAllUsers() async {
    return await _isar.users.where().findAll();
  }

  // VALIDAR CORREO REPETIDO
  Future<bool> emailExists(String email) async {
    final user = await _isar.users
        .filter()
        .emailEqualTo(email)
        .findFirst();

    return user != null;
  }


  // CERRAR SESIÓN
Future<void> logout() async {
  if (currentUser != null) {
    await addLog(
      currentUser!.name,
      "Cierre de sesión",
    );
  }

  currentUser = null;
}
}