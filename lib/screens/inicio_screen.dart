import 'package:material_ui/material_ui.dart';

import '../data/requisitos.dart';
import '../services/gemini_service.dart';
import '../services/tramite.dart';
import '../services/voz_service.dart';
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

  void _elegir(TipoTramite t) {
    setState(() => tramite.elegir(t));
    VozService.hablar('Eligió: ${t.titulo}. ${t.paraQuien}.');
  }

  Widget _tarjeta(TipoTramite t) {
    final elegido = tramite.actual.id == t.id;
    final listos = tramite.listosDe(t);
    final total = t.documentos.length;
    final avance = listos == 0 ? '' : ' Ya tiene $listos de $total documentos.';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Semantics(
        button: true,
        selected: elegido,
        child: GestureDetector(
          onTap: () => _elegir(t),
          child: InfoCard(
            titulo: t.titulo,
            texto: '${t.paraQuien}$avance',
            icono: elegido ? Icons.check_circle : t.icono,
            fondo: elegido ? AppColors.primario.withValues(alpha: 0.18) : Colors.white,
            borde: elegido ? AppColors.borde : const Color(0xFF9FB4C4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listos = tramite.listosDe(tramite.actual);

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
              Text('¿Con qué trámite le ayudo? Toque uno.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              for (final t in tramites) _tarjeta(t),
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
              const SizedBox(height: 24),
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
              if (listos > 0) ...[
                const SizedBox(height: 16),
                SecondaryButton(
                  texto: 'Ver mi lista',
                  icono: Icons.checklist,
                  onPressed: () => _ir(const ResultadoScreen()),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
