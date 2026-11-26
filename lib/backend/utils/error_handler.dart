
import 'dart:async';
import 'dart:io';

import '../../services/gemini_service.dart';

enum AssistantErrorType {
  network,
  timeout,
  serviceUnavailable,
  invalidApiKey,
  rateLimit,
  invalidResponse,
  unknown,
}

class ErrorHandler {
  static String getUserMessage(Object error) {
    if (error is GeminiError) {
      return _classifyGeminiError(error.mensaje);
    }

    if (error is TimeoutException) {
      return _message(AssistantErrorType.timeout);
    }

    if (error is SocketException) {
      return _message(AssistantErrorType.network);
    }

    return _message(AssistantErrorType.unknown);
  }

  static String _classifyGeminiError(String mensaje) {
    final texto = mensaje.toLowerCase();

    if (texto.contains('conexión') ||
        texto.contains('conectarme')) {
      return _message(AssistantErrorType.network);
    }

    if (texto.contains('tardó')) {
      return _message(AssistantErrorType.timeout);
    }

    if (texto.contains('clave')) {
      return _message(AssistantErrorType.invalidApiKey);
    }

    if (texto.contains('muchas consultas')) {
      return _message(AssistantErrorType.rateLimit);
    }

    if (texto.contains('ocupado')) {
      return _message(AssistantErrorType.serviceUnavailable);
    }

    if (texto.contains('respuesta')) {
      return _message(AssistantErrorType.invalidResponse);
    }

    return _message(AssistantErrorType.unknown);
  }

  static String _message(AssistantErrorType type) {
    switch (type) {
      case AssistantErrorType.network:
        return 'No hay conexión a Internet. Revise su señal e intente otra vez.';

      case AssistantErrorType.timeout:
        return 'La respuesta tardó demasiado. Intente otra vez.';

      case AssistantErrorType.serviceUnavailable:
        return 'El asistente está ocupado. Intente otra vez en un minuto.';

      case AssistantErrorType.invalidApiKey:
        return 'La clave del asistente no funciona. Solicite ayuda técnica.';

      case AssistantErrorType.rateLimit:
        return 'Hay muchas consultas. Espere un minuto e intente otra vez.';

      case AssistantErrorType.invalidResponse:
        return 'No obtuve una respuesta. Intente decirlo de otra forma.';

      case AssistantErrorType.unknown:
        return 'Ocurrió un problema. Intente nuevamente.';
    }
  }
}

