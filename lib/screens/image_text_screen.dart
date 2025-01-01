import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:img2txt/services/gemini_service.dart';

class ImageToTextScreen extends StatefulWidget {
  @override
  _ImageToTextScreenState createState() => _ImageToTextScreenState();
}

class _ImageToTextScreenState extends State<ImageToTextScreen> {
  File? _image;
  String _extractedText = '';
  bool _isLoading = false;
  final GeminiService _geminiService = GeminiService(
    apiKey:
        'AIzaSyAspL2br8MSbkm-TcOGM3Mz5YBVVQolX2o', // Replace with your actual API key
  );

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _extractedText = '';
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final text = await _geminiService.getTextFromImage(_image!);
      setState(() {
        _extractedText = text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to Text'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 16),
            if (_image != null) ...[
              Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
            ],
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_extractedText.isNotEmpty) ...[
              Text(
                'Extracted Text:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_extractedText),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
