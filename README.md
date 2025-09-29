# Offline Nepali/Sinhalese → English OCR + Translation (Flutter)

## Features
- Capture or upload image
- Offline OCR via Tesseract (tessdata_fast recommended)
- Offline translation via ONNX Runtime Mobile with quantized MarianMT
- Copy/share results

## Setup
1. Install Flutter SDK and Android Studio/Xcode toolchains.
2. Place assets:
```
assets/
  tessdata/
    nep.traineddata
    sin.traineddata
    eng.traineddata
  models/
    ne_en/
      model.onnx
      spm.model
      vocab.json
    si_en/
      model.onnx
      spm.model
      vocab.json
```
3. Run `flutter pub get`.

## Export models
Use Python + optimum to export and quantize MarianMT (Helsinki-NLP/opus-mt-ne-en, .../opus-mt-si-en). Ensure the ONNX graph outputs decoded sequences for mobile.

## Android
- Add camera/photo permissions in AndroidManifest.xml if needed.
- Build: `flutter build apk --release`

## iOS
- Add NSCameraUsageDescription and NSPhotoLibraryUsageDescription in Info.plist.
- Build: `flutter build ipa --release` (requires signing).

## Notes
- Works fully offline after assets are bundled.
- For higher quality tokenization, swap in a proper SentencePiece tokenizer via FFI.

