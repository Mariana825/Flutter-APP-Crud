import "package:flutter/material.dart";
import "../models/user_model.dart";
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ProfileView extends StatefulWidget {
  final User user;
  const ProfileView({
    super.key,
    required this.user,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = p.basename(pickedFile.path);

    final savedImage =
        await File(pickedFile.path).copy('${directory.path}/$fileName');

    setState(() {
      _imageFile = savedImage;
      widget.user.imagePath = savedImage.path; // SOLO RUTA
    });
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

                  // FOTO DE PERFIL
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (widget.user.imagePath != null
                            ? FileImage(File(widget.user.imagePath!))
                            : const AssetImage("assets/profile.png")
                                as ImageProvider),
                  ),

                  const SizedBox(height: 10),

                  // BOTONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.pink),
                        onPressed: () => pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo, color: Colors.pink),
                        onPressed: () => pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.user.name,
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
                    widget.user.email,
                  ),

                  profileItem(
                    Icons.lock,
                    "Contraseña",
                    "••••••••",
                  ),

                  profileItem(
                    Icons.admin_panel_settings,
                    "Rol",
                    widget.user.role,
                  ),

                  profileItem(
                    Icons.calendar_month,
                    "Fecha de registro",
                    formatDate(widget.user.registerDate),
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
          Icon(icon, color: Colors.pink),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}