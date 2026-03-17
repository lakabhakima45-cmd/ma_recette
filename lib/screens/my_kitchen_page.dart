import 'package:flutter/material.dart';

class MyKitchenPage extends StatelessWidget {
  const MyKitchenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ma cuisine")),
      body: const Center(
        child: Text(
          "Contenu à venir",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}