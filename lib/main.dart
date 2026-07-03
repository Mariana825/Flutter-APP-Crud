import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";

import "controllers/user_controller.dart";
import "models/user_model.dart";
import "views/login_view.dart";
import "models/log_model.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir =
      await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
  [
    UserSchema,
    LogEntrySchema,
  ],
  directory: dir.path,
);

  UserController().init(isar);

  final usersCount =
      await isar.users.count();

  if (usersCount == 0) {
    final admin = User(
      name: "Administrador Principal",
      email: "admin@test.com",
      password: "admin123",
      role: "admin",
    );

    await isar.writeTxn(() async {
      await isar.users.put(admin);
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "User Manager",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor:
              const Color(0xFF1E3A8A),
          brightness:
              Brightness.light,
        ),
      ),
      home: LoginView(
        controller: UserController(),
      ),
    );
  }
}