import 'package:flutter/material.dart';
import '../data/categories.dart' as catData;
import '../data/recipe_repository.dart';
import '../models/recipe.dart';
import 'category_recipes_page.dart';
import 'recipe_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final RecipeRepository repo = RecipeRepository();
  late Future<List<Recipe>> future;

  final TextEditingController _controller = TextEditingController();
  String _query = "";
  String? _activeFilter;

  @override
  void initState() {
    super.initState();

    future = repo.loadRecipes();

    _controller.addListener(() {
      setState(() {
        _query = _controller.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _countForCategory(List<Recipe> all, String catId) {

    if (catId == "all") return all.length;

    if (catId == "vegetarien") {
      return all
          .where((r) => r.dietType.toLowerCase().trim() == "vegetarien")
          .length;
    }

    return all.where((r) => r.categoryId == catId).length;
  }

  List<Recipe> _popular(List<Recipe> all) {
    final copy = [...all];
    copy.sort((a, b) => a.time.compareTo(b.time));
    return copy.take(10).toList();
  }

  bool _matchesQuery(Recipe r, String q) {

    if (q.isEmpty) return true;

    final name = r.name.toLowerCase();
    final diff = r.difficulty.toLowerCase();
    final diet = r.dietType.toLowerCase();

    final ingredients = r.ingredients.map((e) => e.toLowerCase()).join(" ");
    final steps = r.steps.map((e) => e.toLowerCase()).join(" ");

    return name.contains(q) ||
        diff.contains(q) ||
        diet.contains(q) ||
        ingredients.contains(q) ||
        steps.contains(q);
  }

  bool _matchesFilter(Recipe r, String? filter) {

    if (filter == null) return true;

    switch (filter) {

      case "rapide":
        return r.time <= 20;

      case "healthy":
        return r.calories <= 550 && r.fat <= 20;

      case "proteine":
        return r.protein >= 25;

      case "lowcal":
        return r.calories <= 500;

      case "tendance":
        return r.categoryId == "classiques" || r.categoryId == "hiver";

      default:
        return true;
    }
  }

  List<Recipe> _searchResults(List<Recipe> all) {

    final filtered = all
        .where((r) => _matchesQuery(r, _query))
        .where((r) => _matchesFilter(r, _activeFilter))
        .toList();

    filtered.sort((a, b) {

      final aName = a.name.toLowerCase().contains(_query);
      final bName = b.name.toLowerCase().contains(_query);

      if (aName && !bName) return -1;
      if (!aName && bName) return 1;

      return a.time.compareTo(b.time);
    });

    return filtered;
  }

  void _openRecipe(Recipe r) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailPage(recipe: r),
      ),
    );
  }

  void _toggleFilter(String f) {
    setState(() {
      _activeFilter = (_activeFilter == f) ? null : f;
    });
  }

  Widget _chip(String key, String label, IconData icon) {

    final selected = _activeFilter == key;

    return ChoiceChip(
      selected: selected,
      onSelected: (_) => _toggleFilter(key),
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selectedColor: Colors.orange,
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _fallbackBg() {
    return Container(
      color: Colors.grey.withOpacity(0.15),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 34),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final categories = catData.categories;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        elevation: 0,
        title: const Text(
          "RECHERCHE",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: FutureBuilder<List<Recipe>>(

        future: future,

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final all = snapshot.data ?? [];
          final popular = _popular(all);
          final results = _searchResults(all);

          final showResults =
              _query.isNotEmpty || _activeFilter != null;

          return ListView(

            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),

            children: [

              // SEARCH BAR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade200,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.search),
                    hintText: "Une recette, des ingrédients...",
                    border: InputBorder.none,
                    suffixIcon: (_query.isEmpty)
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _controller.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // FILTERS
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [

                    _chip("tendance", "Tendance", Icons.trending_up),
                    const SizedBox(width: 8),

                    _chip("rapide", "Rapide", Icons.timer),
                    const SizedBox(width: 8),

                    _chip("healthy", "Healthy", Icons.eco),
                    const SizedBox(width: 8),

                    _chip("lowcal", "-500 kcal", Icons.local_fire_department),
                    const SizedBox(width: 8),

                    _chip("proteine", "Protéiné", Icons.fitness_center),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (!showResults) ...[

                const Text(
                  "Populaires",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 155,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: popular.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {

                      final r = popular[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _openRecipe(r),
                        child: SizedBox(
                          width: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              r.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _fallbackBg(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Parcourir",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),
              ],

              // RESULTATS FILTRES
              if (showResults)

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {

                    final r = results[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _openRecipe(r),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          r.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallbackBg(),
                        ),
                      ),
                    );
                  },
                )

              else

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemBuilder: (context, index) {

                    final cat = categories[index];
                    final count = _countForCategory(all, cat.id);

                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryRecipesPage(
                              categoryId: cat.id,
                              title: cat.title,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [

                          Image.asset(
                            cat.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => _fallbackBg(),
                          ),

                          Positioned(
                            right: 10,
                            top: 10,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.black54,
                              child: Text(
                                "$count",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),

              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoryRecipesPage(
                          categoryId: "all",
                          title: "Toutes les recettes",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text(
                    "Voir toutes les recettes",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}