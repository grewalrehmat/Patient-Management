import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}


class _OCRPageState extends State<OCRPage> {
  String? _extractedText;
  bool _isLoading = false;

  Future<void> _openCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
      }
      return;
    }
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _processImage(File(pickedFile.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _processImage(File(pickedFile.path));
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _isLoading = true;
      _extractedText = null;
    });
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String formatted = _formatRecognizedText(recognizedText);
      setState(() {
        _extractedText = formatted;
        _isLoading = false;
      });
      // Log to terminal
      // ignore: avoid_print
      print('--- OCR Output ---\n$formatted');
    } catch (e) {
      setState(() {
        _extractedText = 'Failed to recognize text: $e';
        _isLoading = false;
      });
    } finally {
      textRecognizer.close();
    }
  }

  String _formatRecognizedText(RecognizedText recognizedText) {
    // Try to format as table if possible, else just join lines
    final buffer = StringBuffer();
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        buffer.writeln(line.text);
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: isWideScreen
          ? AppBar(
              backgroundColor: const Color(0xFF0F172A),
              elevation: 0,
              title: const Text(
                "OCR Scanner",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            _ocrOptionButton(
              icon: Icons.camera_alt,
              label: "Scan using Camera",
              onTap: _openCamera,
            ),
            const SizedBox(height: 16),
            _ocrOptionButton(
              icon: Icons.photo_library,
              label: "Upload from Gallery",
              onTap: _pickFromGallery,
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            if (_extractedText != null && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _extractedText!,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ocrOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 28, color: Colors.white),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
