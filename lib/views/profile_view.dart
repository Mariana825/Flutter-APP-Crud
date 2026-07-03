import "package:flutter/material.dart";
import "../models/user_model.dart";

class ProfileView extends StatelessWidget {
  final User user;

  const ProfileView({
    super.key,
    required this.user,
  });

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3F7),
      appBar: AppBar(
        title: const Text("Perfil del usuario"),
        backgroundColor: const Color(0xFFF48FB1),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(
                      "assets/profile.png",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC2185B),
                    ),
                  ),

                  const SizedBox(height: 30),

                  profileItem(
                    Icons.email,
                    "Correo",
                    user.email,
                  ),

                  profileItem(
                    Icons.lock,
                    "Contraseña",
                    user.password,
                  ),

                  profileItem(
                    Icons.admin_panel_settings,
                    "Rol",
                    user.role,
                  ),

                  profileItem(
                    Icons.calendar_month,
                    "Fecha de registro",
                    formatDate(user.registerDate),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.pink,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}