import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            // HERO IMAGE
            Hero(
              tag: recipe.id,
              child: Image.asset(
                recipe.image,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [

                  Text(
                    "${recipe.calories} kcal",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Ingrédients",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.ingredients
                      .map(
                        (i) => Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          bottom: 6),
                      child: Text("• $i"),
                    ),
                  )
                      .toList(),

                  const SizedBox(height: 20),

                  const Text(
                    "Préparation",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...recipe.steps
                      .map(
                        (s) => Padding(
                      padding:
                      const EdgeInsets
                          .only(
                          bottom: 8),
                      child: Text("• $s"),
                    ),
                  )
                      .toList(),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                      ElevatedButton
                          .styleFrom(
                        backgroundColor:
                        Colors.orange,
                        padding:
                        const EdgeInsets
                            .symmetric(
                            vertical:
                            14),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              15),
                        ),
                      ),
                      onPressed: () {
                        appState.addCalories(
                            recipe.calories
                                .toDouble());

                        ScaffoldMessenger.of(
                            context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Ajouté à la journée"),
                          ),
                        );
                      },
                      child: const Text(
                        "Ajouter à ma journée",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}