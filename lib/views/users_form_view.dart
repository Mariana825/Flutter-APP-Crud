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
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();

    if (widget.userToEdit != null) {
      _nameCtrl.text = widget.userToEdit!.name;
      _emailCtrl.text = widget.userToEdit!.email;
      _passCtrl.text = widget.userToEdit!.password;
      _confirmPassCtrl.text = widget.userToEdit!.password;

      _isAdmin = widget.userToEdit!.role == "admin";
    }
  }

  // ================= VALIDACIONES =================

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El nombre es obligatorio";
    }

    final name = value.trim();

    if (name.length < 6 || name.length > 60) {
      return "Debe tener entre 6 y 60 caracteres";
    }

    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(name)) {
      return "Solo letras";
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "El correo es obligatorio";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Correo inválido";
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
      return "Debe incluir una mayúscula";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Debe incluir un símbolo";
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Confirma tu contraseña";
    }

    if (value != _passCtrl.text) {
      return "No coincide";
    }

    return null;
  }

  // ================= GUARDAR =================

  Future<void> processForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim();
    final controller = UserController();

    final exists = await controller.emailExists(email);

    if (exists &&
        (widget.userToEdit == null ||
            widget.userToEdit!.email.toLowerCase() != email.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Este correo ya existe")),
      );
      return;
    }

    final newUser = User(
      name: _nameCtrl.text.trim(),
      email: email,
      password: _passCtrl.text.trim(),
      role: _isAdmin ? "admin" : "reader",
    );

    if (widget.userToEdit != null) {
      newUser.id = widget.userToEdit!.id;
      newUser.registerDate = widget.userToEdit!.registerDate;
      await UserController().updateUser(newUser);
    } else {
      await UserController().addUser(newUser);
    }

    Navigator.pop(context);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8BBD0),
        title: Text(
          widget.userToEdit != null ? "Editar Usuario" : "Nuevo Usuario",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(
                  controller: _nameCtrl,
                  label: "Nombre",
                  validator: validateName,
                ),
                const SizedBox(height: 15),

                _buildField(
                  controller: _emailCtrl,
                  label: "Correo",
                  validator: validateEmail,
                ),
                const SizedBox(height: 15),

                _buildField(
                  controller: _passCtrl,
                  label: "Contraseña",
                  obscure: true,
                  validator: validatePassword,
                ),
                const SizedBox(height: 15),

                _buildField(
                  controller: _confirmPassCtrl,
                  label: "Confirmar contraseña",
                  obscure: true,
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 15),

                SwitchListTile(
                  activeColor: const Color(0xFFF48FB1),
                  title: const Text("¿Es administrador?"),
                  value: _isAdmin,
                  onChanged: (value) {
                    setState(() => _isAdmin = value);
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: processForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF48FB1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Guardar",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= WIDGET REUTILIZABLE =================

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFF48FB1), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}