class ExerciseModel {
  // deneme
  final String id;
  final String name;
  final String bodyPart; // e.g., "abs", "legs", "arms", "chest", "back"
  final String description;
  final String? equipment;
  final String? target;
  final List<String>? secondaryMuscles;
  final String? videoUrl;
  final String? imageUrl;
  final List<String> instructions;
  final int? sets;
  final int? reps;
  final String? difficulty; // "beginner", "intermediate", "advanced"

  ExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.description,
    this.equipment,
    this.target,
    this.secondaryMuscles,
    this.videoUrl,
    this.imageUrl,
    required this.instructions,
    this.sets,
    this.reps,
    this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'description': description,
      'equipment': equipment,
      'target': target,
      'secondaryMuscles': secondaryMuscles,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'instructions': instructions,
      'sets': sets,
      'reps': reps,
      'difficulty': difficulty,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bodyPart: map['bodyPart'] ?? '',
      description: map['description'] ?? '',
      equipment: map['equipment'],
      target: map['target'],
      secondaryMuscles: map['secondaryMuscles'] != null ? List<String>.from(map['secondaryMuscles']) : null,
      videoUrl: map['videoUrl'],
      imageUrl: map['imageUrl'],
      instructions: List<String>.from(map['instructions'] ?? []),
      sets: map['sets'],
      reps: map['reps'],
      difficulty: map['difficulty'],
    );
  }

  factory ExerciseModel.fromApi(Map<String, dynamic> map) {
    final descriptionFromApi = map['description'] as String?;
    final target = map['target'] as String?;
    final equipment = map['equipment'] as String?;
    var imageUrl = map['gifUrl'] as String?;
    if (imageUrl != null && imageUrl.startsWith('http://')) {
      // CloudFront GIF linklerini HTTPS'e yükseltelim; bazı cihazlarda http engellenebiliyor.
      imageUrl = imageUrl.replaceFirst('http://', 'https://');
    }
    final difficulty = map['difficulty'] as String? ?? 'Intermediate';
    return ExerciseModel(
      id: (map['id'] ?? '').toString(),
      name: map['name'] ?? '',
      bodyPart: map['bodyPart'] ?? '',
      description: descriptionFromApi ??
          [
            if (target != null) 'Hedef kas: $target',
            if (equipment != null) 'Ekipman: $equipment',
          ].join(' • '),
      equipment: equipment,
      target: target,
      secondaryMuscles: map['secondaryMuscles'] != null ? List<String>.from(map['secondaryMuscles']) : null,
      imageUrl: imageUrl,
      videoUrl: null,
      instructions: List<String>.from(map['instructions'] ?? []),
      sets: null,
      reps: null,
      difficulty: difficulty,
    );
  }
}

