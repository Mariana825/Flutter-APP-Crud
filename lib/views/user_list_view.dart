import "package:flutter/material.dart";
import "../controllers/user_controller.dart";
import "../models/user_model.dart";
import "users_form_view.dart";
import "profile_view.dart";
import "bitacora_view.dart";
import "login_view.dart";

class UserListView extends StatefulWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  final UserController _userController = UserController();

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = _userController.currentUser?.role == "admin";

    return Scaffold(
       resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFF3F7),
      appBar: AppBar(
  backgroundColor: const Color(0xFFF48FB1),
  title: Text(
    isAdmin ? "Panel Administrador" : "Panel Reader",
  ),
  centerTitle: true,
  actions: [

    // Ver bitácora
    IconButton(
      icon: const Icon(Icons.history),
      tooltip: "Bitácora",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BitacoraView(),
          ),
        );
      },
    ),

    // Cerrar sesión
    IconButton(
      icon: const Icon(Icons.logout),
      tooltip: "Cerrar sesión",
      onPressed: () async {

        await _userController.logout();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => LoginView(
              controller: UserController(),
            ),
          ),
          (route) => false,
        );
      },
    ),
  ],
),
     body: SafeArea(
  child: Column(
        children: [
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF06292),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.person_add),
                  label: const Text("Agregar usuario"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserFormView(),
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                ),
              ),
            ),

          Expanded(
            child: FutureBuilder<List<User>>(
              future: _userController.getAllUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final users = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileView(user: user),
                            ),
                          );
                        },
                        contentPadding: const EdgeInsets.all(15),

                        leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileView(user: user),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                user.role == "admin"
                                    ? Colors.pink
                                    : Colors.pink.shade300,
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        title: Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${user.email}\nRol: ${user.role}",
                          ),
                        ),

                        trailing: isAdmin
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserFormView(
                                            userToEdit: user,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Eliminar usuario"),
        content: const Text(
          "¿Quieres eliminar este usuario?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await _userController.deleteUser(user.id);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Eliminar"),
          ),
        ],
      );
    },
  );
},
                                  ),
                                ],
                              )
                            : const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey,
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
     )
    );
  }
}