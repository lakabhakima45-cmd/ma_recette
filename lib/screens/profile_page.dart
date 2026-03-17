import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/app_state.dart';
import 'nutrition_setup_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await AppState.instance.setProfileImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),

          // 🔥 APPBAR AVEC LOGO
          appBar: AppBar(
            backgroundColor: const Color(0xFFFF8C42),
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    "assets/logo/ma_recette_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Profil",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // ===== USER CARD =====
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      // PHOTO PROFIL
                      GestureDetector(
                        onTap: () => pickImage(context),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color(0xFFFF8C42),
                          backgroundImage: appState.profileImagePath != null
                              ? FileImage(
                              File(appState.profileImagePath!))
                              : null,
                          child: appState.profileImagePath == null
                              ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 30,
                          )
                              : null,
                        ),
                      ),

                      const SizedBox(width: 20),

                      // NOM + EMAIL
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.username,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              appState.email ?? "",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // ===== OPTIONS =====
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      // Assistant nutrition
                      ListTile(
                        leading: const Icon(
                          Icons.health_and_safety,
                          color: Color(0xFFFF8C42),
                        ),
                        title: const Text("Assistant Nutrition"),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const NutritionSetupPage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      // Objectif calories
                      ListTile(
                        leading: const Icon(
                          Icons.flag,
                          color: Color(0xFFFF8C42),
                        ),
                        title: const Text("Objectif actuel"),
                        subtitle: Text(
                          "${appState.dailyGoal.toInt()} kcal / jour",
                        ),
                      ),

                      const Divider(height: 1),

                      // Changer compte
                      ListTile(
                        leading: const Icon(
                          Icons.switch_account,
                          color: Colors.blue,
                        ),
                        title: const Text("Changer de compte"),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const LoginPage(),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1),

                      // Déconnexion
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: const Text("Se déconnecter"),
                        onTap: () async {
                          await appState.logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const LoginPage(),
                            ),
                                (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}