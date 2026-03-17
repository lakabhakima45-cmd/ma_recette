import 'package:flutter/material.dart';
import '../services/app_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();

  final _prenom = TextEditingController();
  final _nom = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  DateTime? birthDate;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        birthDate = date;
      });
    }
  }

  Future<void> _register() async {

    if (!_formKey.currentState!.validate()) return;

    if (_pass.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe ne correspondent pas"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Choisis ta date de naissance"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await AppState.instance.register(
      firstName: _prenom.text,
      lastName: _nom.text,
      email: _email.text,
      password: _pass.text,
      birthDate: birthDate.toString(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compte créé avec succès"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _prenom.dispose();
    _nom.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Widget field({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      validator: (v) {

        if (v == null || v.trim().isEmpty) {
          return "Champ obligatoire";
        }

        /// validation prénom et nom
        if (label == "Prénom" || label == "Nom") {
          final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
          if (!nameRegex.hasMatch(v)) {
            return "Seulement des lettres";
          }
        }

        /// validation email
        if (label == "Email") {
          final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (!emailRegex.hasMatch(v)) {
            return "Email invalide";
          }
        }

        /// validation mot de passe
        if (label == "Mot de passe") {
          if (v.length < 6) {
            return "Minimum 6 caractères";
          }
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Créer un compte"),
        backgroundColor: const Color(0xFFFF8C42),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              field(
                label: "Prénom",
                icon: Icons.person_outline,
                controller: _prenom,
              ),

              const SizedBox(height: 15),

              field(
                label: "Nom",
                icon: Icons.person,
                controller: _nom,
              ),

              const SizedBox(height: 15),

              field(
                label: "Email",
                icon: Icons.email_outlined,
                controller: _email,
              ),

              const SizedBox(height: 15),

              field(
                label: "Mot de passe",
                icon: Icons.lock_outline,
                controller: _pass,
                obscure: _obscure1,
                suffix: IconButton(
                  icon: Icon(
                    _obscure1
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure1 = !_obscure1;
                    });
                  },
                ),
              ),

              const SizedBox(height: 15),

              field(
                label: "Confirmer le mot de passe",
                icon: Icons.lock_outline,
                controller: _confirm,
                obscure: _obscure2,
                suffix: IconButton(
                  icon: Icon(
                    _obscure2
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure2 = !_obscure2;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [

                      const Icon(Icons.calendar_today),

                      const SizedBox(width: 10),

                      Text(
                        birthDate == null
                            ? "Choisir date de naissance"
                            : "${birthDate!.day}/${birthDate!.month}/${birthDate!.year}",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  onPressed: _register,

                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}