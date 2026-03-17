import 'package:flutter/material.dart';
import '../services/app_state.dart';

class NutritionSetupPage extends StatefulWidget {
  const NutritionSetupPage({super.key});

  @override
  State<NutritionSetupPage> createState() => _NutritionSetupPageState();
}

class _NutritionSetupPageState extends State<NutritionSetupPage> {

  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  String gender = "female";
  String goal = "lose";
  String activity = "medium";

  double _parseHeight() {
    String h = heightCtrl.text.toLowerCase();
    h = h.replaceAll("m", "").replaceAll(",", ".");

    double height = double.tryParse(h) ?? 0;

    if (height < 3) {
      height = height * 100;
    }

    return height;
  }

  double calculateCalories() {

    final weight = double.tryParse(weightCtrl.text) ?? 0;
    final height = _parseHeight();
    final age = double.tryParse(ageCtrl.text) ?? 0;

    double bmr;

    if (gender == "male") {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    double activityFactor = 1.2;

    if (activity == "medium") activityFactor = 1.375;
    if (activity == "high") activityFactor = 1.55;

    double calories = bmr * activityFactor;

    if (goal == "lose") calories -= 400;
    if (goal == "gain") calories += 300;

    if (calories < 1200) calories = 1200;

    return calories;
  }

  double calculateIMC() {

    final weight = double.tryParse(weightCtrl.text) ?? 0;
    final height = _parseHeight();

    double heightM = height / 100;

    if (heightM == 0) return 0;

    return weight / (heightM * heightM);
  }

  Map<String,double> calculateMacros(double calories){

    double protein = (calories * 0.30) / 4;
    double carbs = (calories * 0.40) / 4;
    double fats = (calories * 0.30) / 9;

    return {
      "protein": protein,
      "carbs": carbs,
      "fats": fats
    };
  }

  @override
  Widget build(BuildContext context) {

    final appState = AppState.instance;

    return Scaffold(

      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text("Assistant Nutrition"),
        backgroundColor: Colors.orange,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            _buildCard(
              title: "Informations",
              child: Column(
                children: [
                  _buildField(weightCtrl, "Poids (kg)"),
                  const SizedBox(height: 12),
                  _buildField(heightCtrl, "Taille (cm ou 1m65)"),
                  const SizedBox(height: 12),
                  _buildField(ageCtrl, "Âge"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Sexe",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _genderButton("female", "Femme"),
                  _genderButton("male", "Homme"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Activité",
              child: Column(
                children: [
                  _activityButton("low", "Faible"),
                  _activityButton("medium", "Modérée"),
                  _activityButton("high", "Élevée"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildCard(
              title: "Objectif",
              child: Column(
                children: [
                  _goalButton("lose", "🔥 Perdre du poids"),
                  _goalButton("maintain", "⚖️ Maintien"),
                  _goalButton("gain", "💪 Prise de masse"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: () async {

                  final calories = calculateCalories();
                  final imc = calculateIMC();
                  final macros = calculateMacros(calories);

                  if (calories == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Remplis correctement poids, taille et âge"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(

                      title: const Text("Ton programme nutrition"),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Text("Calories : ${calories.toInt()} kcal / jour"),

                          const SizedBox(height:10),

                          Text("IMC : ${imc.toStringAsFixed(1)}"),

                          const SizedBox(height:10),

                          Text("Protéines : ${macros["protein"]!.toInt()} g"),
                          Text("Glucides : ${macros["carbs"]!.toInt()} g"),
                          Text("Lipides : ${macros["fats"]!.toInt()} g"),

                        ],
                      ),

                      actions: [
                        TextButton(
                          child: const Text("Valider"),
                          onPressed: () async {

                            await appState.setDailyGoal(calories);

                            Navigator.pop(context);
                            Navigator.pop(context);

                          },
                        )
                      ],
                    ),
                  );
                },

                child: const Text(
                  "Calculer mon programme",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _genderButton(String value, String text) {
    return ChoiceChip(
      label: Text(text),
      selected: gender == value,
      onSelected: (_) {
        setState(() => gender = value);
      },
      selectedColor: Colors.orange,
    );
  }

  Widget _activityButton(String value, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: activity == value,
        onSelected: (_) {
          setState(() => activity = value);
        },
        selectedColor: Colors.orange,
      ),
    );
  }

  Widget _goalButton(String value, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: goal == value,
        onSelected: (_) {
          setState(() => goal = value);
        },
        selectedColor: Colors.orange,
      ),
    );
  }
}