import 'package:flutter/foundation.dart';

class FavoritesStore {
  FavoritesStore._();
  static final FavoritesStore instance = FavoritesStore._();

  // On stocke les IDs des recettes en favoris
  final ValueNotifier<Set<String>> ids = ValueNotifier<Set<String>>({});

  bool isFav(String id) => ids.value.contains(id);

  void toggle(String id) {
    final copy = {...ids.value};
    if (copy.contains(id)) {
      copy.remove(id);
    } else {
      copy.add(id);
    }
    ids.value = copy; // IMPORTANT: nouvelle instance => rebuild partout
  }

  void remove(String id) {
    final copy = {...ids.value}..remove(id);
    ids.value = copy;
  }

  void clear() => ids.value = {};
}