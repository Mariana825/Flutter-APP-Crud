import "package:flutter/material.dart";
import "../controllers/user_controller.dart";
import "../models/user_model.dart";


class UserFormView extends StatefulWidget {
  final User? userToEdit;

  const UserFormView({
    Key? key,
    this.userToEdit,
  }) : super(key: key);

  @override
  State<UserFormView> createState() =>
      _UserFormViewState();
}

class _UserFormViewState
    extends State<UserFormView> {
  final _formKey =
      GlobalKey<FormState>();

  final _nameCtrl =
      TextEditingController();
  final _emailCtrl =
      TextEditingController();
  final _passCtrl =
      TextEditingController();
  final _confirmPassCtrl =
      TextEditingController();
      

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();

    if (widget.userToEdit != null) {
      _nameCtrl.text =
          widget.userToEdit!.name;
      _emailCtrl.text =
          widget.userToEdit!.email;
      _passCtrl.text =
          widget.userToEdit!.password;
      _confirmPassCtrl.text =
          widget.userToEdit!.password;

      _isAdmin =
          widget.userToEdit!.role ==
              "admin";
    }
  }
  String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "El nombre es obligatorio";
  }

  final name = value.trim();

  if (name.length < 6 || name.length > 60) {
    return "El nombre debe tener entre 6 y 60 caracteres";
  }

  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(name)) {
    return "Solo se permiten letras";
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "El correo es obligatorio";
  }

  final email = value.trim();

  final emailRegex =
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!emailRegex.hasMatch(email)) {
    return "Formato de correo inválido";
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "La contraseña es obligatoria";
  }

  if (value.length < 8) {
    return "Mínimo 8 caracteres";
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Debe incluir al menos una mayúscula";
  }

  if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return "Debe incluir al menos un símbolo";
  }

  return null;
}

String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Confirma tu contraseña";
  }

  if (value != _passCtrl.text) {
    return "Las contraseñas no coinciden";
  }

  return null;
}

  Future<void> processForm() async {
    if (!_formKey.currentState!
        .validate()) return;
  final email = _emailCtrl.text.trim();

  final controller = UserController();

  // 🔴 VALIDACIÓN DE CORREO DUPLICADO
  final exists = await controller.emailExists(email);

  // Si estás editando, permitir el mismo correo del usuario actual
  if (exists &&
      (widget.userToEdit == null ||
          widget.userToEdit!.email.toLowerCase() != email.toLowerCase())) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Este correo ya está registrado"),
      ),
    );
    return;
  }

    final newUser = User(
  name: _nameCtrl.text.trim(),
  email: _emailCtrl.text.trim(),
  password: _passCtrl.text.trim(),
  role: _isAdmin ? "admin" : "reader",
);

// Si se está editando un usuario,
// conservar la fecha de registro original.
if (widget.userToEdit != null) {
  newUser.registerDate = widget.userToEdit!.registerDate;
}


    if (widget.userToEdit != null) {
      newUser.id =
          widget.userToEdit!.id;

      await UserController()
          .updateUser(newUser);
    } else {
      await UserController()
          .addUser(newUser);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.userToEdit != null
              ? "Editar Usuario"
              : "Nuevo Usuario",
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration:
                    const InputDecoration(
                  labelText: "Nombre",
                ),
                  validator: validateName,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _emailCtrl,
                decoration:
                    const InputDecoration(
                  labelText: "Correo",
                ),
                 validator: validateEmail,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _passCtrl,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Contraseña",
                ),
                 validator: validatePassword,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller:
                    _confirmPassCtrl,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Confirmar contraseña",
                ),
                 validator: validateConfirmPassword,
              ),
              const SizedBox(height: 15),

              SwitchListTile(
                title: const Text(
                  "¿Es administrador?",
                ),
                value: _isAdmin,
                onChanged: (value) {
                  setState(() {
                    _isAdmin = value;
                  });
                },
              ),

              ElevatedButton(
                onPressed: processForm,
                child: const Text(
                  "Guardar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}