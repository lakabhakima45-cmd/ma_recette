import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../database/database_helper.dart';

class RecipeRepository {

  Future<List<Recipe>> loadRecipes() async {

    final db = await DatabaseHelper.instance.database;

    final existing = await db.query('recipes');

    /// si la base est vide on charge le JSON
    if (existing.isEmpty) {

      final jsonString =
      await rootBundle.loadString('assets/data/recipes.json');

      final List data = json.decode(jsonString);

      for (var r in data) {

        await DatabaseHelper.instance.insertRecipe({
          "id": r["id"],
          "name": r["name"],
          "image": r["image"],
          "time": r["time"],
          "difficulty": r["difficulty"],
          "dietType": r["dietType"],
          "categoryId": r["categoryId"],
          "calories": r["calories"],
          "protein": r["protein"],
          "carbs": r["carbs"],
          "fat": r["fat"],

          /// on transforme les listes en texte JSON
          "ingredients": json.encode(r["ingredients"]),
          "steps": json.encode(r["steps"])
        });
      }
    }

    final result = await DatabaseHelper.instance.getRecipes();

    return result.map((e) {

      return Recipe(
        id: e["id"],
        name: e["name"],
        image: e["image"],
        time: e["time"],
        difficulty: e["difficulty"],
        dietType: e["dietType"],
        categoryId: e["categoryId"],
        calories: e["calories"],
        protein: e["protein"],
        carbs: e["carbs"],
        fat: e["fat"],

        /// on reconvertit le texte en liste
        ingredients: List<String>.from(json.decode(e["ingredients"])),
        steps: List<String>.from(json.decode(e["steps"])),
      );

    }).toList();
  }
}