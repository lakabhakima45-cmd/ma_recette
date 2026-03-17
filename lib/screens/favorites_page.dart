import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _open(BuildContext context, Recipe r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(recipe: r),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        final favs = AppState.instance.favoriteRecipes;

        if (favs.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Aucun favori pour l’instant ",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Favoris",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: favs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final r = favs[i];
              return ListTile(
                onTap: () => _open(context, r),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    r.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  r.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text("${r.time} min • ${r.difficulty}"),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    AppState.instance.toggleFavorite(r);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}