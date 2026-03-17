import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorite_recipes';

  Future<Set<String>> getIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  Future<bool> isFavorite(String recipeId) async {
    final ids = await getIds();
    return ids.contains(recipeId);
  }

  Future<void> toggle(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_key) ?? []).toSet();

    if (ids.contains(recipeId)) {
      ids.remove(recipeId);
    } else {
      ids.add(recipeId);
    }

    await prefs.setStringList(_key, ids.toList());
  }
}
