import 'package:flutter/material.dart';
import '../services/app_state.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppState.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Mes informations")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line("Nom", s.lastName ?? "—"),
            _line("Prénom", s.firstName ?? "—"),
            _line("Email", s.email ?? "—"),
            _line("Date de naissance", s.birthDate ?? "—"),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }
}