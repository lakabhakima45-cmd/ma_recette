import 'package:flutter/material.dart';
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import 'recipe_detail_page.dart';

class CategoryRecipesPage extends StatefulWidget {
  final String categoryId;
  final String title;

  const CategoryRecipesPage({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<CategoryRecipesPage> createState() => _CategoryRecipesPageState();
}

class _CategoryRecipesPageState extends State<CategoryRecipesPage> {
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

  bool _match(Recipe r) {
    if (widget.categoryId == "all") return true;

    if (widget.categoryId == "vegetarien") {
      return r.dietType.toLowerCase() == "vegetarien";
    }

    return r.categoryId == widget.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          final all = snapshot.data ?? [];
          final list = all.where(_match).toList();

          if (list.isEmpty) {
            return const Center(child: Text("Aucune recette trouvée."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final r = list[i];

              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => openRecipe(r),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        r.image,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey.withOpacity(0.15),
                          child: const Icon(Icons.image_outlined),
                        ),
                      ),
                    ),
                    title: Text(
                      r.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _miniInfo(Icons.schedule, "${r.time} min"),
                          _miniInfo(Icons.local_fire_department_outlined, "${r.calories} kcal"),
                          _miniInfo(Icons.star_outline, r.difficulty),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}