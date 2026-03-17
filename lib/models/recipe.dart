class Recipe {
  final String id;
  final String name;
  final String image;
  final int time;
  final String difficulty;
  final String dietType;
  final String categoryId;

  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  final List<String> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.time,
    required this.difficulty,
    required this.dietType,
    required this.categoryId,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      time: json['time'],
      difficulty: json['difficulty'],
      dietType: json['dietType'],
      categoryId: json['categoryId'],
      calories: json['calories'],
      protein: json['protein'],
      carbs: json['carbs'],
      fat: json['fat'],
      ingredients: List<String>.from(json['ingredients']),
      steps: List<String>.from(json['steps']),
    );
  }
}