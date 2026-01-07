import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/exercise_model.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final difficultyLabel = (exercise.difficulty ?? "Intermediate").toUpperCase();
    return Scaffold(
      backgroundColor: const Color(0xFF0B1021),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1021),
        title: const Text("Exercise Detail", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'exercise-${exercise.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: exercise.imageUrl!,
                        width: double.infinity,
                        height: 260,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (c, _) => Container(
                          height: 260,
                          color: const Color(0xFF0F172A),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 2),
                        ),
                        errorWidget: (c, e, s) => Container(
                          height: 260,
                          color: const Color(0xFF0F172A),
                          alignment: Alignment.center,
                          child: const Icon(Icons.broken_image, color: Colors.cyanAccent, size: 64),
                        ),
                      )
                    : Container(
                        height: 260,
                        color: const Color(0xFF0F172A),
                        alignment: Alignment.center,
                        child: const Icon(Icons.fitness_center, color: Colors.cyanAccent, size: 64),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              exercise.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(exercise.bodyPart.toUpperCase(), Colors.cyanAccent),
                _chip(difficultyLabel, Colors.pinkAccent),
                if (exercise.equipment != null) _chip(exercise.equipment!, Colors.blueAccent),
                if (exercise.target != null) _chip(exercise.target!, Colors.orangeAccent),
                if (exercise.secondaryMuscles != null)
                  ...exercise.secondaryMuscles!.map((m) => _chip(m, Colors.greenAccent)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              exercise.description.isNotEmpty ? exercise.description : "No description available for this exercise.",
              style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              "Steps",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            if (exercise.instructions.isNotEmpty)
              ...exercise.instructions.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              })
            else
              const Text(
                "Bu egzersiz için adım bilgisi bulunamadı.",
                style: TextStyle(color: Colors.white60),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill, color: Colors.black),
                      label: const Text("Start Exercise", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Exercise başlatıldı!")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add_task, color: Colors.cyanAccent),
                      label: const Text("Add to Workout", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.cyanAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to list!")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Tips",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Maintain proper form, control your range of motion, and breathe rhythmically. Stop if you feel pain.",
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              "Common Mistakes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Avoid excessive momentum, maintaining core stability, uncontrolled movements, and improper breathing.",
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              "Safety Notes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              "Warm up properly before starting. Don't load joints unexpectedly. Stop and reduce intensity if you feel pain or discomfort.",
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

