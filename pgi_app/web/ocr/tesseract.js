// Tesseract.js wrapper for Flutter web integration
console.log('Initializing tesseract.js wrapper...');

// Check if Tesseract is already available
console.log('Checking if Tesseract is available:', typeof Tesseract !== 'undefined');

// Wait for Tesseract to be available and define OCR function
function initializeOCR() {
  console.log('Checking Tesseract availability...', typeof Tesseract);
  
  if (typeof Tesseract !== 'undefined') {
    console.log('Tesseract is available, defining OCR function...');
    
    window.ocrExtractText = function(imageDataUrl) {
      return new Promise(async (resolve, reject) => {
        try {
          console.log('OCR: Starting text recognition...');
          console.log('OCR: Tesseract object:', Tesseract);
          
          const result = await Tesseract.recognize(imageDataUrl, 'eng', {
            logger: function(m) {
              if (m.status === 'recognizing text') {
                console.log('OCR Progress:', Math.round(m.progress * 100) + '%');
              }
            }
          });
          
          const extractedText = result.data.text || 'No text found in image';
          console.log('OCR: Text extraction completed');
          console.log('OCR: Extracted text length:', extractedText.length);
          console.log('OCR: First 100 chars:', extractedText.substring(0, 100));
          
          resolve(extractedText);
          
        } catch (error) {
          console.error('OCR: Error during text recognition:', error);
          reject('OCR processing failed: ' + error.message);
        }
      });
    };
    
    console.log('OCR function ocrExtractText defined successfully');
  } else {
    console.log('Tesseract not yet available, retrying in 1000ms...');
    setTimeout(initializeOCR, 1000);
  }
}

// Wait for DOM and then start initialization
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, starting OCR initialization...');
    setTimeout(initializeOCR, 2000); // Give more time for Tesseract to load
  });
} else {
  console.log('DOM already loaded, starting OCR initialization...');
  setTimeout(initializeOCR, 2000);
}
