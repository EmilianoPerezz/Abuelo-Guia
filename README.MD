# Abuelo Guía

> **Equipo:** UMIZOOMI | **Campus:** Mérida UVM | **Integrantes:** Emiliano Perez, Rodrigo Ferrer, Alan Jimenez, Jonathan Alvarez

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
* **ODS 10 (Reducción de las desigualdades):** Facilita el acceso a trámites y derechos a quienes enfrentan barreras de lectura o tecnología.
* **ODS 11 (Ciudades y comunidades sostenibles):** Favorece comunidades más inclusivas, con servicios más accesibles para las personas mayores, y puede evitar traslados innecesarios.

### Público objetivo
Adultos mayores con dificultades para entender trámites o usar aplicaciones con mucho texto.

### Boceto / diseño
![Boceto de Abuelo Guía](boceto/): Inicio, Tomar foto, Qué falta y Preguntar con voz. Los resultados que muestra son de ejemplo.

---

## 3. Documentación funcional

Funciones planeadas para el MVP:

* **Foto del documento:** el usuario toma una foto desde la aplicación y la envía a analizar.
* **Revisión de requisitos:** compara el documento con la lista de requisitos del trámite e indica lo que ya tiene y lo que falta.
* **Explicación en lenguaje sencillo:** muestra el siguiente paso con frases cortas y letra grande.
* **Asistente de voz:** el usuario toca un botón, hace su pregunta y puede escuchar la respuesta.

La aplicación orienta, pero no valida documentos oficialmente.

---

## 4. Documentación técnica

### Arquitectura general (planeada)
1. La app captura la foto o la pregunta por voz.
2. La app envía a Gemini la imagen o el texto, junto con la lista de requisitos incluida en la app.
3. Gemini devuelve una explicación sencilla.
4. La app la muestra en pantalla y la lee en voz alta.

### Stack tecnológico (planeado)
* **Aplicación móvil:** Flutter (Dart), desarrollada en Android Studio.
* **Cámara:** paquete `image_picker`.
* **Voz:** paquetes `speech_to_text` (escuchar) y `flutter_tts` (leer en voz alta).
* **Datos:** lista de requisitos incluida en la app, sin base de datos propia.
* **Inteligencia Artificial:** Google Gemini mediante Firebase AI Logic (`firebase_core` y `firebase_ai`). Modelo: [PENDIENTE]

### Integración de Gemini
Gemini interpreta la foto del documento, la compara con la lista de requisitos, explica qué falta y cuál es el siguiente paso, y responde las preguntas del usuario. La voz se convierte a texto en el celular antes de enviarse. La app no guardará las fotos en una base de datos propia.

---

## 5. Manual de usuario

Esta guía está pensada para personas que usan la aplicación por primera vez. Describe el funcionamiento planeado.

### Instalación o acceso
1. Instale Abuelo Guía en su teléfono Android. [PENDIENTE: enlace a la app demostrable]
2. Cuando la aplicación lo pida, permita el uso de la cámara y del micrófono.
3. Necesita conexión a internet.

### Primeros pasos y uso diario
1. Abra la aplicación.
2. Toque **Tomar foto de mi documento** y ponga la hoja sobre una mesa, con buena luz.
3. Lea qué documentos ya tiene, cuál le falta y qué hacer después.
4. Si tiene una duda, toque **Tengo una pregunta** y hable.
5. Toque **Escuchar respuesta** para oírla.
6. Confirme los requisitos en la oficina oficial.

---

## 6. Accesibilidad e impacto

### Características de accesibilidad e inclusión
* Apoyo mediante asistente de voz para reducir la carga de lectura.
* Explicaciones en lenguaje sencillo orientadas a usuarios con dificultades para entender trámites o usar aplicaciones con mucho texto.
* Diseño con letra grande, botones grandes y alto contraste.
* Pocas opciones por pantalla.

### Impacto esperado
Facilitar que los adultos mayores comprendan y avancen en trámites esenciales como su pensión con mayor autonomía, reduciendo trámites incompletos, dependencia de terceros y traslados innecesarios en la comunidad.