import "package:flutter/material.dart";
import "package:isar/isar.dart";

import "../controllers/user_controller.dart";
import "../models/log_model.dart";

class BitacoraView extends StatefulWidget {
  const BitacoraView({super.key});

  @override
  State<BitacoraView> createState() => _BitacoraViewState();
}

class _BitacoraViewState extends State<BitacoraView> {

  final UserController controller = UserController();

 Future<List<LogEntry>> getLogs() async {
  final logs = await controller.isar.logEntrys.where().findAll();

  logs.sort(
    (a, b) => b.date.compareTo(a.date),
  );

  return logs;
}

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF48FB1),
        title: const Text("Bitácora"),
        centerTitle: true,
      ),

      body: FutureBuilder<List<LogEntry>>(
        future: getLogs(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final logs = snapshot.data!;

          if (logs.isEmpty) {
            return const Center(
              child: Text(
                "No existen registros.",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: logs.length,

            itemBuilder: (context, index) {

              final log = logs[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(

                  leading: Icon(
                    log.action == "Inicio de sesión"
                        ? Icons.login
                        : Icons.logout,
                    color: Colors.pink,
                  ),

                  title: Text(log.userName),

                  subtitle: Text(
                    "${log.action}\n${formatDate(log.date)}",
                  ),

                ),
              );
            },
          );
        },
      ),
    );
  }
}
