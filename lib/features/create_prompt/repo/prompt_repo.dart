import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PromptRepo {
  static final dio = Dio();

  static Future<String> generateId(String prompt) async {
    try {
      final Map data = {'prompt': prompt, 'aspect_ratio': 'social_story_9_16'};

      final response = await dio.post(
        dotenv.env['API_URL']!,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "x-freepik-api-key": dotenv.env['API_KEY'],
          },
        ),
      );

      final taskId = response.data['data']['task_id'];

      return taskId;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Failed to generate task ID: $error");
    }
  }

  static Future<String> generateImage(String prompt) async {
    try {
      
      final taskId = await generateId(prompt);

      await Future.delayed(const Duration(seconds: 20));

      final response = await dio.get(
        "${dotenv.env['API_URL']!}/$taskId",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "x-freepik-api-key": dotenv.env['API_KEY'],
          },
        ),
      );

      final imageUrl = response.data['data']['generated'][0];
      return imageUrl;
    } catch (error) {
      debugPrint(error.toString());
      throw Exception("Failed to generate task ID: $error");
    }
  }
}
