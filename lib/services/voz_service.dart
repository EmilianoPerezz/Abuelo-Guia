import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VozService {
  static final FlutterTts _tts = FlutterTts();
  static final SpeechToText _stt = SpeechToText();
  static bool _ttsListo = false;
  static bool _sttListo = false;

  static Future<void> hablar(String texto) async {
    try {
      if (!_ttsListo) {
        await _tts.setLanguage('es-MX');
        await _tts.setSpeechRate(0.42);
        await _tts.setPitch(1.0);
        _ttsListo = true;
      }
      await _tts.stop();
      await _tts.speak(texto);
    } catch (_) {}
  }

  static Future<void> callar() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  static Future<bool> escuchar({
    required void Function(String texto, bool terminado) alEscuchar,
    required void Function() alTerminar,
  }) async {
    await callar();
    try {
      if (!_sttListo) {
        _sttListo = await _stt.initialize(
          onStatus: (estado) {
            if (estado == 'done' || estado == 'notListening') alTerminar();
          },
          onError: (_) => alTerminar(),
        );
      }
      if (!_sttListo) return false;
      await _stt.listen(
        listenOptions: SpeechListenOptions(
          localeId: 'es_MX',
          listenFor: const Duration(seconds: 40),
          pauseFor: const Duration(seconds: 4),
          partialResults: true,
        ),
        onResult: (r) => alEscuchar(r.recognizedWords, r.finalResult),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> dejarDeEscuchar() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }
}
