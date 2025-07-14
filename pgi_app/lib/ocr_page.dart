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
    final status = await Permission.photos.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gallery access permission is required')),
        );
      }
      return;
    }
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
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;
    const lightBlue = Color(0xFF64B5F6);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: isWideScreen
          ? AppBar(
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              title: Text(
                "OCR Scanner",
                style: TextStyle(color: colorScheme.onBackground),
              ),
              centerTitle: true,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: lightBlue, width: 1.5),
            ),
        ),
      ),
    );
  }
}
