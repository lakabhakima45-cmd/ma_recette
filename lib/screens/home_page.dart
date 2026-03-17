import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';
import 'recipe_detail_page.dart';
import 'smart_recommendation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final RecipeRepository repo = RecipeRepository();
  late Future<List<Recipe>> future;

  @override
  void initState() {
    super.initState();
    future = repo.loadRecipes();
  }

  void openRecipe(Recipe r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailPage(recipe: r)),
    );
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
              onPressed: () async {

                final value = double.tryParse(controller.text);

                if (value != null && value > 0) {
                  await appState.setDailyGoal(value);
                  setState(() {});
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

        return Scaffold(

          backgroundColor: const Color(0xFFF7F8FA),

          // 🔥 APPBAR AVEC LOGO
          appBar: AppBar(
            backgroundColor: Colors.orange,
            elevation: 0,

            title: Row(
              children: [

                Container(
                  width: 32,
                  height: 32,
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
                  "Ma Recette",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            actions: [

              IconButton(
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const SmartRecommendationPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          body: Column(
            children: [

              // HEADER OBJECTIF
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
                      borderRadius: BorderRadius.circular(10),

                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white30,
                        valueColor:
                        const AlwaysStoppedAnimation(
                            Colors.white),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      appState.remainingCalories >= 0
                          ? "Il reste ${appState.remainingCalories.toInt()} kcal"
                          : "Tu as dépassé de ${(-appState.remainingCalories).toInt()} kcal",

                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LISTE RECETTES
              Expanded(
                child: FutureBuilder<List<Recipe>>(

                  future: future,

                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    final recipes = snapshot.data!;

                    return GridView.builder(

                      padding: const EdgeInsets.all(16),

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),

                      itemCount: recipes.length,

                      itemBuilder: (context, index) {

                        final r = recipes[index];

                        final isFav =
                        appState.favoriteRecipes.contains(r);

                        return InkWell(

                          borderRadius:
                          BorderRadius.circular(20),

                          onTap: () => openRecipe(r),

                          child: ClipRRect(

                            borderRadius:
                            BorderRadius.circular(20),

                            child: Stack(

                              children: [

                                Image.asset(
                                  r.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin:
                                      Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black
                                            .withOpacity(0.6),
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                ),

                                // FAVORI
                                Positioned(
                                  top: 8,
                                  right: 8,

                                  child: GestureDetector(

                                    onTap: () {
                                      appState
                                          .toggleFavorite(r);
                                    },

                                    child: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons
                                          .favorite_border,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),

                                // INFOS RECETTE
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        r.name,
                                        style:
                                        const TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Row(
                                        children: [

                                          Container(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),

                                            decoration:
                                            BoxDecoration(
                                              color:
                                              Colors.black54,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10),
                                            ),

                                            child: Text(
                                              "${r.calories} kcal",
                                              style:
                                              const TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                              width: 6),

                                          Container(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),

                                            decoration:
                                            BoxDecoration(
                                              color:
                                              Colors.black54,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10),
                                            ),

                                            child: Text(
                                              "${r.time} min",
                                              style:
                                              const TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
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