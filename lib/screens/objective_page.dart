import 'package:flutter/material.dart';
import '../services/app_state.dart';

class ObjectivePage extends StatefulWidget {
  const ObjectivePage({super.key});

  @override
  State<ObjectivePage> createState() => _ObjectivePageState();
}

class _ObjectivePageState extends State<ObjectivePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> updateGoal() async {
    final value = double.tryParse(_controller.text);

    if (value != null && value > 0) {
      await AppState.instance.setDailyGoal(value);
      setState(() {});
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    final double consumed = appState.todayCalories;
    final double goal = appState.dailyGoal;

    final double remaining = goal - consumed;

    final double progress =
    goal == 0 ? 0 : (consumed / goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Objectif calorique"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // 🔥 CERCLE PROGRESSION
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [

                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    color: Colors.orange,
                    backgroundColor: Colors.grey.shade300,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${(progress * 100).toInt()} %",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${consumed.toInt()} / ${goal.toInt()} kcal",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 CALORIES RESTANTES
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [

                  const Text(
                    "Calories restantes aujourd’hui",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${remaining.toInt()} kcal",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 CHANGER OBJECTIF
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Nouvel objectif kcal",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: updateGoal,
              child: const Text("Mettre à jour l'objectif"),
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () async {
                await AppState.instance.resetToday();
                setState(() {});
              },
              child: const Text("Réinitialiser la journée"),
            ),
          ],
        ),
      ),
    );
  }
}