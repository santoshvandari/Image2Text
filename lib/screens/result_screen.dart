import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResultScreen extends StatelessWidget {
  final String extractedText;
  final File image;

  const ResultScreen({
    required this.extractedText,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Extracted Text'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Extracted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    extractedText.isNotEmpty
                        ? extractedText
                        : 'No text was extracted from the image.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: extractedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Text copied to clipboard!')),
                    );
                  },
                  icon: Icon(Icons.copy),
                  label: Text('Copy'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
