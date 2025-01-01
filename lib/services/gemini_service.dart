import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class GeminiService {
  final String apiKey;
  late GenerativeModel model;

  GeminiService({required this.apiKey}) {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> getTextFromImage(File imageFile) async {
    try {
      // Read image data
      final imageData = await imageFile.readAsBytes();

      // Create content part for the image
      final imagePart = DataPart('image/jpeg', imageData);

      // Create prompt
      final prompt =
          TextPart('Extract all text from this image and return it.');

      // Generate content
      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      return response.text ?? 'No text found in the image';
    } catch (e) {
      throw Exception('Error processing image: $e');
    }
  }
}
