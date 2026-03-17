import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _keyFor(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${d.year}-${two(d.month)}-${two(d.day)}";
  }

  String _labelFor(DateTime d) {
    const days = ["L", "M", "M", "J", "V", "S", "D"];
    return days[d.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {

        final state = AppState.instance;
        final now = DateTime.now();

        // 🔥 7 derniers jours
        final days = List.generate(7, (i) {
          final d = now.subtract(Duration(days: 6 - i));
          final key = _keyFor(d);
          final val = state.history[key] ?? 0;
          return (date: d, value: val);
        });

        final values = days.map((e) => e.value).toList();

        // 🔥 total réel
        final total = values.fold<double>(0, (s, v) => s + v);

        // 🔥 jours avec données
        final activeDays = values.where((v) => v > 0).length;

        // 🔥 moyenne réelle
        final avg = activeDays == 0 ? 0 : total / activeDays;

        final goal = state.dailyGoal;

        // 🔥 jours respectés
        final successfulDays =
            values.where((v) => v > 0 && v <= goal).length;

        final successRate =
        activeDays == 0 ? 0 : ((successfulDays / activeDays) * 100).toInt();

        String badge;

        if (successRate >= 85) {
          badge = "Semaine parfaite !";
        } else if (successRate >= 60) {
          badge = "Très bonne régularité";
        } else if (successRate >= 30) {
          badge = "Continue tes efforts";
        } else {
          badge = "Nouvelle semaine, nouveau départ";
        }

        final maxY = values.isEmpty
            ? 1000.0
            : (values.reduce((a, b) => a > b ? a : b) + 200)
            .clamp(400.0, 4000.0);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Progression",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
            centerTitle: true,
          ),

          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            children: [

              // 🔥 Résumé
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Résumé de la semaine",
                      style:
                      TextStyle(fontWeight: FontWeight.w900),
                    ),

                    const SizedBox(height: 8),

                    Text("${total.toStringAsFixed(0)} kcal consommées"),

                    Text(
                        "Moyenne : ${avg.toStringAsFixed(0)} kcal / jour"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔥 Score
              _card(
                child: Column(
                  children: [

                    Text(
                      "$successRate%",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.orange,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                        "$successfulDays jours respectés sur $activeDays"),

                    const SizedBox(height: 6),

                    LinearProgressIndicator(
                      value: activeDays == 0
                          ? 0
                          : successfulDays / activeDays,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                      const AlwaysStoppedAnimation(
                          Colors.orange),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔥 Badge
              _card(
                child: Column(
                  children: [

                    const Text(
                      "Badge de la semaine",
                      style:
                      TextStyle(fontWeight: FontWeight.w900),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      badge,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 🔥 Graphique
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Évolution quotidienne",
                      style:
                      TextStyle(fontWeight: FontWeight.w900),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          maxY: maxY,
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true),

                          titlesData: FlTitlesData(

                            leftTitles: const AxisTitles(
                                sideTitles:
                                SideTitles(showTitles: false)),

                            topTitles: const AxisTitles(
                                sideTitles:
                                SideTitles(showTitles: false)),

                            rightTitles: const AxisTitles(
                                sideTitles:
                                SideTitles(showTitles: false)),

                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,

                                getTitlesWidget: (value, meta) {

                                  final i = value.toInt();

                                  if (i < 0 || i > 6) {
                                    return const SizedBox();
                                  }

                                  return Padding(
                                    padding:
                                    const EdgeInsets.only(top: 8),

                                    child: Text(
                                      _labelFor(days[i].date),

                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                          barGroups: List.generate(7, (i) {

                            return BarChartGroupData(
                              x: i,

                              barRods: [

                                BarChartRodData(
                                  toY: days[i].value,
                                  width: 18,

                                  borderRadius:
                                  BorderRadius.circular(6),

                                  color: days[i].value > goal
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: child,
    );
  }
}