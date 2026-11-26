# Abuelo Guía

> **Equipo:** UMIZOOMI | **Campus:** Mérida UVM | **Integrantes:** Emiliano Perez, Rodrigo Ferrer, Alan Jimenez, Jonathan Alvarez

## 📱 App demostrable

**[Descargar Abuelo Guía para Android (APK)](https://github.com/EmilianoPerezz/Abuelo-Guia/releases/latest/download/AbueloGuia.apk)** · [Ver todas las versiones](https://github.com/EmilianoPerezz/Abuelo-Guia/releases)

Requiere Android 7 o superior y conexión a internet. Las instrucciones de instalación están en el [Manual de usuario](#5-manual-de-usuario).

---

## 1. Resumen ejecutivo

Abuelo Guía es una aplicación móvil con asistente de voz diseñada para ayudar a adultos mayores a realizar trámites, como el de su pensión. El usuario toma una foto de su documento y la aplicación le explica, con lenguaje sencillo, qué hace falta y cuál es el siguiente paso. Busca reducir la confusión, evitar vueltas innecesarias y disminuir la dependencia de terceros frente a trámites con textos complejos o información dispersa, apoyando a personas mayores con dificultades para comprender procedimientos o navegar interfaces cargadas de texto.

---

## 2. Boceto y concepto

### Problema detectado
La información sobre trámites suele ser confusa, estar dispersa y emplear lenguaje difícil. Muchos adultos mayores no saben qué documentos requieren, lo que puede provocar traslados innecesarios, dependencia de otras personas o perder el acceso a un apoyo.

### Propuesta de solución
Una aplicación móvil apoyada en un asistente de voz donde el usuario captura una fotografía de su documento y recibe una explicación clara y sencilla sobre qué falta y cuál es el siguiente paso a seguir.

### Alineación con los Objetivos de Desarrollo Sostenible (ODS)
- **ODS 10 (Reducción de las desigualdades):** Facilita el acceso a trámites y derechos a quienes enfrentan barreras de lectura o tecnología.
- **ODS 11 (Ciudades y comunidades sostenibles):** Favorece comunidades más inclusivas, con servicios más accesibles para las personas mayores, y puede evitar traslados innecesarios.

### Público objetivo
Adultos mayores con dificultades para entender trámites o usar aplicaciones con mucho texto.

### Qué la hace diferente
- **No hay que leer la convocatoria:** el usuario solo toma una foto y la app le dice qué documento es y si sirve.
- **Lista personal que se va marcando:** cada foto válida marca un requisito, así la persona sabe en todo momento cuánto le falta.
- **Pensada para voz:** todo se lee en voz alta y las preguntas se hacen hablando; escribir es opcional.
- **Respuestas acotadas al trámite real:** Gemini solo usa la lista oficial incluida en la app, en lugar de responder como un chat genérico.

### Boceto / diseño
| Inicio | Tomar foto | Qué falta | Preguntar |
|:---:|:---:|:---:|:---:|
| <img src="boceto/1-inicio.png" width="200"> | <img src="boceto/2-foto.png" width="200"> | <img src="boceto/3-resultado.png" width="200"> | <img src="boceto/4-preguntar.png" width="200"> |

[Ver carpeta del boceto](boceto/): Inicio, Tomar foto, Qué falta y Preguntar con voz. Los resultados que muestra son de ejemplo.

---

## 3. Documentación funcional

Trámites incluidos (versión 1.1):

| Trámite | Para quién | Documentos que revisa la app |
|---|---|---|
| Pensión para el Bienestar de las Personas Adultas Mayores | 65 años o más | Identificación oficial vigente, CURP, acta de nacimiento y comprobante de domicilio (máximo 6 meses) |
| Credencial INAPAM | 60 años o más | Los mismos cuatro, más una fotografía reciente |
| Pensión Mujeres Bienestar | Mujeres de 60 a 64 años | Identificación oficial vigente, CURP, acta de nacimiento y comprobante de domicilio |

Funciones:

- **Elegir el trámite y ver sus documentos:** en el inicio la persona toca uno de los tres trámites. La siguiente pantalla muestra arriba el trámite elegido y abajo todos los documentos que necesita, con una explicación de cada uno y si ya lo tiene, y se los lee en voz alta.

- **Foto del documento:** el usuario toma una foto con la cámara o elige una foto guardada. Gemini identifica qué documento es y si sirve (vigente, legible y, en el comprobante de domicilio, de máximo 6 meses).
- **Lista que se va marcando y se comparte entre trámites:** cada foto válida marca un requisito como "Ya lo tiene". Si la persona ya fotografió su INE para la pensión, también aparece marcada en INAPAM. Cada trámite muestra además un recordatorio (teléfonos de contacto, originales y copias, fechas de registro).
- **Explicación en lenguaje sencillo:** muestra el siguiente paso con frases cortas y letra grande, y lo lee en voz alta automáticamente.
- **Asistente de voz:** el usuario toca el micrófono, hace su pregunta y escucha la respuesta. Gemini conoce qué documentos ya tiene y cuáles le faltan. También hay preguntas sugeridas y la opción "Prefiero escribir".

La aplicación orienta, pero no valida documentos oficialmente.

Fuentes de los requisitos: convocatorias de Programas para el Bienestar (gob.mx/bienestar) e INAPAM (gob.mx/inapam). La app siempre recomienda confirmarlos en el módulo, porque pueden cambiar.

---

## 4. Documentación técnica

### Arquitectura general
1. La app captura la foto o la pregunta por voz.
2. La app envía a Gemini la imagen o el texto, junto con la lista de requisitos incluida en la app.
3. Gemini devuelve una explicación sencilla.
4. La app la muestra en pantalla y la lee en voz alta.

### Stack tecnológico
- **Aplicación móvil:** Flutter (Dart), desarrollada en Android Studio.
- **Cámara:** paquete `image_picker`.
- **Voz:** paquetes `speech_to_text` (escuchar) y `flutter_tts` (leer en voz alta).
- **Datos:** lista de requisitos incluida en la app, sin base de datos propia.
- **Conexión:** paquete `http`.
- **Inteligencia Artificial:** Google Gemini API (REST `generateContent`). Modelo: `gemini-3.5-flash-lite` (si está saturado, la app reintenta con `gemini-3.8-flash`).

### Integración de Gemini
Gemini interpreta la foto del documento, la compara con la lista de requisitos, explica qué falta y cuál es el siguiente paso, y responde las preguntas del usuario. La voz se convierte a texto en el celular antes de enviarse. Para las fotos, Gemini responde en JSON (`requisito`, `documento`, `sirve`, `explicacion`, `siguiente_paso`) y la app marca la lista con esa respuesta. Las fotos solo se envían a Gemini para revisarlas; la app no las guarda.

### Estructura del código
```
lib/
├── main.dart                 Arranque de la app y tema
├── data/requisitos.dart      Trámites incluidos y catálogo de documentos
├── services/
│   ├── gemini_service.dart   Llamadas a Gemini (revisar foto y responder preguntas)
│   ├── tramite.dart          Estado en memoria: lista marcada y conversación
│   └── voz_service.dart      Voz a texto y lectura en voz alta
├── screens/                  Inicio, Trámite (lista de documentos), Tomar foto, Resultado y Preguntar
├── theme/                    Colores y tamaños de letra
└── widgets/                  Botones, tarjetas y botón de voz reutilizables
test/widget_test.dart         Pruebas de la pantalla de inicio y de la lista
```

### Cómo ejecutar el proyecto (desarrolladores)
1. Instale Flutter y Android Studio. En Windows active el **Modo de desarrollador** (lo pide Flutter para los plugins).
2. Cree una clave de Gemini en Google AI Studio.
3. Copie `.env.example` como `.env` y pegue su clave. `.env` está en `.gitignore` y no se sube a GitHub.
4. Ejecute:
```
flutter pub get
flutter run --dart-define-from-file=.env
```
5. Para generar el APK: `flutter build apk --release --dart-define-from-file=.env`

En Android Studio agregue `--dart-define-from-file=.env` en *Run > Edit Configurations > Additional run args*.

---

## 5. Manual de usuario

Esta guía está pensada para personas que usan la aplicación por primera vez.

### Instalación o acceso
1. Desde su teléfono Android, toque [Descargar Abuelo Guía](https://github.com/EmilianoPerezz/Abuelo-Guia/releases/latest/download/AbueloGuia.apk).
2. Abra el archivo descargado. Si el teléfono lo pide, permita **instalar apps desconocidas**. Si aparece Play Protect, toque **Más detalles → Instalar de todas formas** (aparece porque la app no viene de la Play Store).
3. Cuando la aplicación lo pida, permita el uso de la cámara y del micrófono.
4. Necesita conexión a internet.

### Primeros pasos y uso diario
1. Abra la aplicación y toque el trámite que quiere hacer: **Pensión para adultos mayores**, **Credencial INAPAM** o **Pensión Mujeres Bienestar**.
2. Arriba verá el trámite que eligió y abajo **todos los documentos que necesita**, con una explicación de cada uno. La app se los lee en voz alta; toque **Escuchar la lista** para oírlos otra vez.
3. Toque **Tomar foto de mi documento** y ponga la hoja sobre una mesa, con buena luz.
4. La app le dice qué documento es, si sirve y qué hacer después, y lo marca como "Ya lo tiene".
5. Toque **Tomar foto de otro documento** para seguir completando su lista, o **Volver a mis documentos** para ver su avance.
6. Si tiene una duda, toque **Hablar con el asistente** o **Tengo una pregunta**, toque el micrófono y hable. Toque **Escuchar respuesta** para oírla otra vez.
7. Toque **Cambiar de trámite** para elegir otro. Los documentos que ya revisó siguen marcados.
8. Confirme los requisitos en el módulo oficial antes de ir.

---

## 6. Accesibilidad e impacto

### Características de accesibilidad e inclusión
- Apoyo mediante asistente de voz para reducir la carga de lectura.
- Explicaciones en lenguaje sencillo orientadas a usuarios con dificultades para entender trámites o usar aplicaciones con mucho texto.
- Diseño con letra grande, botones grandes y alto contraste.
- Pocas opciones por pantalla.

### Impacto esperado
Facilitar que los adultos mayores comprendan y avancen en trámites esenciales como su pensión con mayor autonomía, reduciendo trámites incompletos, dependencia de terceros y traslados innecesarios en la comunidad.

### Privacidad y límites
- Las fotos solo se envían a Gemini para revisarlas; la app no las guarda ni tiene base de datos.
- Se le indica a Gemini que no repita datos personales como números de CURP o direcciones.
- La app orienta, pero no sustituye la revisión oficial: siempre recomienda confirmar en el Módulo de Bienestar.
- Los teléfonos de contacto no se pueden revisar con foto; la app los muestra como recordatorio.
- Para demostraciones se recomienda usar documentos ficticios o con los datos tapados.