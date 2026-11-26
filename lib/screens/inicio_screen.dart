import 'package:material_ui/material_ui.dart';

import '../data/requisitos.dart';
import '../services/gemini_service.dart';
import '../services/tramite.dart';
import '../theme/app_colors.dart';
import '../widgets/info_card.dart';
import 'tramite_screen.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  Future<void> _elegir(TipoTramite t) async {
    tramite.elegir(t);
    await Navigator.push(context, MaterialPageRoute(
      settings: const RouteSettings(name: 'tramite'),
      builder: (_) => const TramiteScreen(),
    ));
    if (mounted) setState(() {});
  }

  Widget _tarjeta(TipoTramite t) {
    final listos = tramite.listosDe(t);
    final total = t.documentos.length;
    final avance = listos == 0
        ? 'Toque para ver qué documentos necesita.'
        : 'Ya tiene $listos de $total documentos.';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Semantics(
        button: true,
        child: GestureDetector(
          onTap: () => _elegir(t),
          child: InfoCard(
            titulo: t.titulo,
            texto: '${t.paraQuien}\n$avance',
            icono: t.icono,
            borde: AppColors.borde,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Text('Le ayudo con su trámite, paso a paso. ¿Cuál quiere hacer? Toque uno.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              for (final t in tramites) _tarjeta(t),
              if (!GeminiService.tieneClave) ...[
                const SizedBox(height: 8),
                const InfoCard(
                  titulo: 'Falta conectar Gemini',
                  texto: 'Agregue su clave en el archivo .env y vuelva a abrir la app.',
                  fondo: Color(0xFFFFF0F0),
                  borde: AppColors.error,
                  icono: Icons.key_off,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
