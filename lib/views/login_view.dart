import "package:flutter/material.dart";
import "../controllers/user_controller.dart";
import "user_list_view.dart";

class LoginView extends StatefulWidget {
  final UserController controller;

  const LoginView({super.key, required this.controller});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String message = "";

  InputDecoration customDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFE91E63),
      ),
      filled: true,
      fillColor: const Color(0xFFFFF5F8),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFF8BBD0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Color(0xFFE91E63),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }

  Future<void> processLogin() async {
    if (!_formKey.currentState!.validate()) return;

    bool success = await widget.controller.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserListView(),
        ),
      );
    } else {
      setState(() {
        message = "Correo o contraseña incorrectos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFD6E7),
              Color(0xFFFFF1F6),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(.25),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8BBD0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "¡Bienvenida!",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC2185B),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Inicia sesión para continuar",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 35),

                    TextFormField(
                      controller: emailController,
                      decoration: customDecoration(
                        label: "Correo electrónico",
                        icon: Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Ingresa tu correo";
                        }

                        if (!RegExp(
                          r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return "Correo inválido";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: customDecoration(
                        label: "Contraseña",
                        icon: Icons.lock_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Ingresa tu contraseña";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: processLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF06292),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: Colors.pink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (message.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}