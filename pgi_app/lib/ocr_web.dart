// OCR implementation for web platform
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

class OCRService {
  static Future<String> extractText(FilePickerResult result) async {
    final file = result.files.single;
    final extension = file.extension?.toLowerCase();
    
    if (file.bytes != null) {
      if (extension == 'pdf') {
        return await _extractTextFromPdf(file.bytes!);
      } else if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        return await _extractTextFromImage(file.bytes!);
      } else {
        throw Exception('Unsupported file format: $extension');
      }
    } else {
      throw Exception('No file selected');
    }
  }

  static Future<String> _extractTextFromPdf(Uint8List bytes) async {
    try {
      // For web PDFs, show information message for now
      return 'PDF OCR Support (Web):\n\nDirect PDF text extraction in web browsers is currently being developed. For now, please:\n\n1. Convert your PDF pages to images (JPG/PNG) using online tools\n2. Upload the images individually for OCR\n\nSupported formats: JPG, JPEG, PNG\n\nThis feature will be enhanced in future updates with PDF.js integration for direct PDF processing in browsers.';
    } catch (e) {
      throw Exception('PDF OCR failed: $e');
    }
  }

  static Future<String> _extractTextFromImage(Uint8List bytes) async {
    try {
      final blob = html.Blob([bytes]);
      final reader = html.FileReader();
      reader.readAsDataUrl(blob);
      await reader.onLoad.first;
      final dataUrl = reader.result as String;
      
      print('Web OCR: Image converted to data URL, length: ${dataUrl.length}');
      return await _performOCR(dataUrl);
    } catch (e) {
      throw Exception('Image OCR failed: $e');
    }
  }

  static Future<String> _performOCR(String dataUrl) async {
    // Wait for OCR function to be available with retries
    for (int i = 0; i < 20; i++) {
      if (js.context.hasProperty('ocrExtractText')) {
        try {
          print('Web OCR: Calling ocrExtractText function...');
          
          // Create a completer to handle the async result
          final Completer<String> completer = Completer<String>();
          
          // Create callbacks
          void onSuccess(result) {
            final text = result?.toString() ?? 'No text found';
            print('Web OCR: Success callback with result: $text');
            if (!completer.isCompleted) {
              completer.complete(text);
            }
          }
          
          void onError(error) {
            final errorMsg = error?.toString() ?? 'Unknown error';
            print('Web OCR: Error callback with error: $errorMsg');
            if (!completer.isCompleted) {
              completer.completeError('OCR failed: $errorMsg');
            }
          }
          
          // Call the JS function and handle the Promise
          final jsFunction = js.context['ocrExtractText'];
          final promise = jsFunction.apply([dataUrl]);
          
          // Handle the promise
          promise.callMethod('then', [js.allowInterop(onSuccess)]);
          promise.callMethod('catch', [js.allowInterop(onError)]);
          
          // Set timeout
          Timer(Duration(seconds: 30), () {
            if (!completer.isCompleted) {
              completer.completeError('OCR timeout after 30 seconds');
            }
          });
          
          return await completer.future;
          
        } catch (e) {
          print('Web OCR: Error occurred: $e');
          throw Exception('OCR failed: $e');
        }
      }
      
      print('Web OCR: OCR function not available, waiting... (attempt ${i + 1}/20)');
      await Future.delayed(Duration(milliseconds: 2000));
    }
    
    throw Exception('OCR function not available after waiting 40 seconds. Please refresh the page and ensure Tesseract.js loads properly.');
  }
  
  static bool get isSupported => true;
}
