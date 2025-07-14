// OCR implementation for non-web platforms  
import 'dart:io';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  static Future<String> extractText(FilePickerResult result) async {
    final file = result.files.single;
    final extension = file.extension?.toLowerCase();
    
    if (extension == 'pdf') {
      return 'PDF OCR Support:\n\nPDF text extraction is currently being developed. For now, please:\n\n1. Convert your PDF pages to images (JPG/PNG)\n2. Upload the images individually for OCR\n\nSupported formats: JPG, JPEG, PNG\n\nThis feature will be enhanced in future updates to support direct PDF processing.';
    } else if (Platform.isAndroid && (extension == 'jpg' || extension == 'jpeg' || extension == 'png')) {
      // Use Google ML Kit for images on Android
      return await _extractTextFromImageAndroid(file);
    } else if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS) && (extension == 'jpg' || extension == 'jpeg' || extension == 'png')) {
      // Use Tesseract for images on desktop
      return await _extractTextFromImageDesktop(file);
    } else {
      throw Exception('Unsupported file format: $extension');
    }
  }

  static Future<String> _extractTextFromImageAndroid(PlatformFile file) async {
    try {
      final inputImage = InputImage.fromFilePath(file.path!);
      final textRecognizer = TextRecognizer();
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();
      return recognizedText.text.isEmpty ? 'No text found in image' : recognizedText.text;
    } catch (e) {
      throw Exception('Image OCR failed: $e');
    }
  }

  static Future<String> _extractTextFromImageDesktop(PlatformFile file) async {
    try {
      if (file.path != null) {
        final text = await TesseractOcr.extractText(file.path!);
        return text.isEmpty ? 'No text found in image' : text;
      } else {
        throw Exception('No file path available');
      }
    } catch (e) {
      throw Exception('Image OCR failed: $e');
    }
  }
  
  static bool get isSupported => Platform.isWindows || Platform.isLinux || Platform.isMacOS || Platform.isAndroid;
}
