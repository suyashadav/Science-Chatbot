import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'string_similarity.dart';

class ChatbotService {
  static final FlutterTts tts = FlutterTts();
  static List<Map<String, String>>? _dataset;

  static Future<void> initialize() async {
    try {
      final csvString =
          await rootBundle.loadString('assets/biology_qa_dataset.csv');
      final list = const CsvToListConverter().convert(csvString);

      _dataset = list.sublist(1).map((row) {
        return {
          'question': row[0].toString(),
          'answer': row[1].toString(),
          'image': row.length > 2 ? row[2].toString() : '',
        };
      }).toList();

      // Initialize TTS settings
      await tts.setLanguage('en-US');
      await tts.setPitch(1.0);
      await tts.setSpeechRate(0.6);
    } catch (e) {
      throw Exception('Failed to load dataset: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> processUserInput(
      String input) async {
    if (_dataset == null)
      return [
        {'answer': "Bot is initializing...", 'image': ''}
      ];

    final questions = _splitQuestions(input);
    final responses = <Map<String, dynamic>>[];

    for (var question in questions) {
      final processed = await _processSingleQuestion(question);
      responses.add(processed);
    }

    return responses.isEmpty
        ? [
            {'answer': "Could you rephrase your question?", 'image': ''}
          ]
        : responses;
  }

  static List<String> _splitQuestions(String input) {
    return input
        .split(RegExp(r'[.?]'))
        .where((q) => q.trim().isNotEmpty)
        .map((q) => q.trim())
        .toList();
  }

  static Future<Map<String, dynamic>> _processSingleQuestion(
      String question) async {
    final datasetQuestions = _dataset!.map((e) => e['question']!).toList();
    final match = StringSimilarity.findBestMatch(
        question.toLowerCase(), datasetQuestions);
    final bestMatch = match.bestMatch;

    if (bestMatch.rating > 0.4) {
      final response = _dataset!.firstWhere(
        (e) => e['question']!.toLowerCase() == bestMatch.target.toLowerCase(),
        orElse: () => _findRelatedAnswer(question),
      );
      return response;
    }
    return _findRelatedAnswer(question);
  }

  static Map<String, String> _findRelatedAnswer(String question) {
    final keywords = question
        .toLowerCase()
        .split(RegExp(r'\W+'))
        .where((k) => k.length > 3)
        .toList();

    if (keywords.isEmpty)
      return {'answer': "Please ask a more specific question.", 'image': ''};

    final potential = _dataset!.where((row) {
      final qText = row['question']!.toLowerCase();
      return keywords.any((k) => qText.contains(k));
    }).toList();

    if (potential.isNotEmpty) {
      potential.sort((a, b) {
        final aCount = keywords
            .where((k) => a['question']!.toLowerCase().contains(k))
            .length;
        final bCount = keywords
            .where((k) => b['question']!.toLowerCase().contains(k))
            .length;
        return bCount.compareTo(aCount);
      });

      return {
        'answer': "Related to your question: ${potential.first['answer']}",
        'image': potential.first['image']!
      };
    }

    return {
      'answer':
          "I couldn't find information about that. Could you ask differently?",
      'image': ''
    };
  }

  static Future<void> speak(String text) async {
    try {
      await tts.speak(text);
    } catch (e) {
      print('Text-to-speech error: $e');
    }
  }
}
