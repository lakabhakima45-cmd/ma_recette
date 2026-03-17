import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';
import 'recipe_detail_page.dart';

class SmartRecommendationPage extends StatefulWidget {
  const SmartRecommendationPage({super.key});

  @override
  State<SmartRecommendationPage> createState() =>
      _SmartRecommendationPageState();
}

class _SmartRecommendationPageState
    extends State<SmartRecommendationPage> {

  final repo = RecipeRepository();
  late Future<List<Recipe>> future;

  @override
  void initState() {
    super.initState();
    future = repo.loadRecipes();
  }

  void _showGoalDialog(AppState appState) {
    final controller =
    TextEditingController(text: appState.dailyGoal.toInt().toString());

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Modifier objectif journalier"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              suffixText: "kcal",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  appState.setDailyGoal(value);
                }
                Navigator.pop(context);
              },
              child: const Text("Valider"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final appState = AppState.instance;

        double progress =
        (appState.todayCalories / appState.dailyGoal).clamp(0, 1);

        final bool exceeded =
            appState.todayCalories > appState.dailyGoal;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),
          appBar: AppBar(
            title: const Text("Recommandations"),
            backgroundColor: Colors.orange,
          ),
          body: Column(
            children: [

              // ===== HEADER =====
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Objectif journalier",
                          style:
                          TextStyle(color: Colors.white70),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Colors.white),
                          onPressed: () =>
                              _showGoalDialog(appState),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${appState.todayCalories.toInt()} / ${appState.dailyGoal.toInt()} kcal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white30,
                        valueColor:
                        AlwaysStoppedAnimation(
                          exceeded
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      exceeded
                          ? "Tu as dépassé de ${ (appState.todayCalories - appState.dailyGoal).toInt()} kcal"
                          : "Il reste ${appState.remainingCalories.toInt()} kcal",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== RECOMMENDATIONS =====
              Expanded(
                child: FutureBuilder<List<Recipe>>(
                  future: future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final recommended =
                    appState.recommendRecipes(snapshot.data!);

                    if (recommended.isEmpty) {
                      return const Center(
                        child: Text(
                          "Aucune recette adaptée ",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: recommended.length,
                      itemBuilder: (context, index) {
                        final recipe = recommended[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                          margin:
                          const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: Image.asset(
                              recipe.image,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                            title: Text(recipe.name),
                            subtitle:
                            Text("${recipe.calories} kcal"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipeDetailPage(
                                          recipe: recipe),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}