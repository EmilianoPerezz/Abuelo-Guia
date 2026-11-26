import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/big_button.dart';
import 'widgets/result_card.dart';
import 'widgets/voice_button.dart';

void main() => runApp(const AbueloGuiaApp());

class AbueloGuiaApp extends StatelessWidget {
  const AbueloGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abuelo Guía',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PruebaScreen(),
    );
  }
}

class PruebaScreen extends StatelessWidget {
  const PruebaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abuelo Guía')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Qué desea hacer?',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            BigButton(
              texto: 'Tomar foto de mi documento',
              icono: Icons.camera_alt,
              onPressed: () {},
            ),
            const SizedBox(height: 20),
            BigButton(
              texto: 'Tengo una pregunta',
              icono: Icons.mic,
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            const ResultCard(texto: 'Identificación oficial', completo: true),
            const SizedBox(height: 12),
            const ResultCard(texto: 'Comprobante de domicilio', completo: false),
            const SizedBox(height: 24),
            Center(
              child: VoiceButton(escuchando: false, onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}