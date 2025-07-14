import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

// Conditional import for OCR service
import 'ocr_io.dart' if (dart.library.html) 'ocr_web.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String? _extractedText;
  bool _isLoading = false;

  Future<void> _pickAndProcessFile({bool isPdf = false}) async {
    setState(() {
      _isLoading = true;
      _extractedText = null;
    });

    try {
      FilePickerResult? result;

      if (isPdf) {
        // Specifically pick PDF files
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false,
          withData: kIsWeb,
        );
      } else {
        // Pick image files
        result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: kIsWeb,
        );
      }

      if (result != null) {
        String text = await OCRService.extractText(result);
        setState(() {
          _extractedText = text;
        });
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: isWideScreen
          ? AppBar(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text(
                'Upload & OCR',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 0,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.document_scanner, size: 72, color: Colors.white70),
            const SizedBox(height: 20),
            const Text(
              'Upload & Extract Text',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // File selection buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickAndProcessFile(isPdf: false),
                    icon: const Icon(Icons.image),
                    label: const Text('Choose Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _pickAndProcessFile(isPdf: true),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Choose PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Loading indicator
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 16),
                    Text(
                      'Processing file...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            
            // Extracted text display
            if (_extractedText != null && !_isLoading) ...[
              const Text(
                'Extracted Text:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _extractedText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
