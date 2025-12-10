import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise_model.dart';

class ExerciseService {
  // ExerciseDB (RapidAPI) configuration
  static const String _apiHost = 'exercisedb.p.rapidapi.com';
  static const String _baseUrl = 'https://$_apiHost';
  static const String _apiKey = 'af35bb50e4msh8e6f1a6aa04dbdbp147efdjsn389d98db8f5a';

  static Map<String, String> get _headers => {
        'X-RapidAPI-Key': _apiKey,
        'X-RapidAPI-Host': _apiHost,
      };

  /// Temel GET isteği
  static Future<List<dynamic>> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('ExerciseDB isteği başarısız (${response.statusCode})');
    }

    final decoded = json.decode(response.body);
    if (decoded is List<dynamic>) {
      return decoded;
    }
    throw Exception('ExerciseDB yanıtı beklenen formatta değil');
  }

  /// Body part ve/veya ekipmana göre egzersiz listesi getirir.
  static Future<List<ExerciseModel>> fetchExercises({
    String? bodyPart,
    String? equipment,
    int limit = 40,
  }) async {
    final path = bodyPart != null && bodyPart.isNotEmpty
        ? '/exercises/bodyPart/$bodyPart'
        : '/exercises';

    final rawList = await _get(path);
    var exercises = rawList.map((e) => ExerciseModel.fromApi(e as Map<String, dynamic>)).toList();

    if (equipment != null && equipment.isNotEmpty) {
      exercises = exercises.where((ex) => ex.equipment?.toLowerCase() == equipment.toLowerCase()).toList();
    }

    if (limit > 0 && exercises.length > limit) {
      exercises = exercises.take(limit).toList();
    }

    return exercises;
  }

  /// Tüm mevcut body part değerlerini getirir.
  static Future<List<String>> fetchBodyParts() async {
    final rawList = await _get('/exercises/bodyPartList');
    return rawList.whereType<String>().toList();
  }
}

