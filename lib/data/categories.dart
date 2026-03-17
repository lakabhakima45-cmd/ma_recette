class Category {
  final String id;
  final String title; // affichage (peut contenir \n)
  final String image; // chemin asset
  final List<String> keywords;

  const Category({
    required this.id,
    required this.title,
    required this.image,
    required this.keywords,
  });
}

const categories = <Category>[
  Category(
    id: "hiver",
    title: "Hiver",
    image: "assets/images/hiver.jpg",
    keywords: ["hiver", "soupe", "potage", "raclette", "tartiflette", "gratin"],
  ),
  Category(
    id: "etudiant",
    title: "Etudiant\nfauché",
    image: "assets/images/etudiant.jpg",
    keywords: ["étudiant", "etudiant", "budget", "pas cher", "rapide", "simple"],
  ),
  Category(
    id: "printemps",
    title: "Printemps",
    image: "assets/images/printemps.jpg",
    keywords: ["printemps", "frais", "salade", "légumes", "legumes", "light"],
  ),
  Category(
    id: "vegetarien",
    title: "Végétarien",
    image: "assets/images/vegetarien.jpg",
    keywords: ["végétarien", "vegetarien", "sans viande"],
  ),
  Category(
    id: "sans_gluten",
    title: "Sans gluten",
    image: "assets/images/sans_gluten.webp",
    keywords: ["sans gluten", "gluten free", "gluten-free"],
  ),
  Category(
    id: "classiques",
    title: "Les classiques",
    image: "assets/images/classiques.jpg",
    keywords: ["classique", "tradition", "familial", "grand-mère", "grand mere"],
  ),
];
