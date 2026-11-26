import 'package:material_ui/material_ui.dart';

import '../data/requisitos.dart';
import '../services/gemini_service.dart';
import '../services/tramite.dart';
import '../theme/app_colors.dart';
import '../widgets/big_button.dart';
import '../widgets/info_card.dart';
import '../widgets/secondary_button.dart';
import 'foto_screen.dart';
import 'preguntar_screen.dart';
import 'resultado_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  Future<void> _ir(Widget pantalla) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final listos = tramite.completos.length;
    final total = requisitos.length;
    final textoAvance = listos == 0
        ? 'Revise qué documentos le faltan'
        : 'Ya tiene $listos de $total documentos. Toque aquí para ver su lista.';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hola, soy Abuelo Guía',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text('Le ayudo con su trámite, paso a paso.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: listos == 0 ? null : () => _ir(const ResultadoScreen()),
                child: InfoCard(
                  titulo: 'Pensión para adultos mayores',
                  texto: textoAvance,
                  icono: Icons.assignment_outlined,
                ),
              ),
              if (!GeminiService.tieneClave) ...[
                const SizedBox(height: 16),
                const InfoCard(
                  titulo: 'Falta conectar Gemini',
                  texto: 'Agregue su clave en el archivo .env y vuelva a abrir la app.',
                  fondo: Color(0xFFFFF0F0),
                  borde: AppColors.error,
                  icono: Icons.key_off,
                ),
              ],
              const SizedBox(height: 48),
              BigButton(
                texto: 'Tomar foto de mi documento',
                icono: Icons.camera_alt,
                onPressed: () => _ir(const FotoScreen()),
              ),
              const SizedBox(height: 20),
              SecondaryButton(
                texto: 'Hablar con el asistente',
                icono: Icons.mic,
                onPressed: () => _ir(const PreguntarScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
