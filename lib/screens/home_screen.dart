import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:img2txt/services/gemini_service.dart';
import 'package:img2txt/widgets/image_picker_sheet.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isLoading = false;
  final GeminiService _geminiService =
      GeminiService(apiKey: 'AIzaSyAspL2br8MSbkm-TcOGM3Mz5YBVVQolX2o');

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final text = await _geminiService.getTextFromImage(_image!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            extractedText: text,
            image: _image!,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
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
        title: Text('Image to Text Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () => showImagePickerSheet(context, _pickImage),
              icon: Icon(Icons.add_a_photo),
              label: Text('Select Image'),
            ),
            SizedBox(height: 16),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
