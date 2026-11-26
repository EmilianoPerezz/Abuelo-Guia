import 'package:material_ui/material_ui.dart';

import '../services/tramite.dart';
import '../services/voz_service.dart';
import '../theme/app_colors.dart';
import '../widgets/big_button.dart';
import '../widgets/info_card.dart';
import '../widgets/result_card.dart';
import '../widgets/secondary_button.dart';
import 'foto_screen.dart';
import 'preguntar_screen.dart';

class TramiteScreen extends StatefulWidget {
  const TramiteScreen({super.key});

  @override
  State<TramiteScreen> createState() => _TramiteScreenState();
}

class _TramiteScreenState extends State<TramiteScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _leer());
  }

  void _leer() {
    final actual = tramite.actual;
    final faltan = tramite.faltantes;
    final lista = tramite.requisitos.map((r) => r.nombre).join(', ');
    var texto = 'Eligió: ${actual.titulo}. Necesita ${tramite.requisitos.length} documentos: $lista.';
    if (faltan.isEmpty) {
      texto += ' Ya tiene todos.';
    } else if (faltan.length < tramite.requisitos.length) {
      texto += ' Le falta: ${faltan.map((r) => r.nombre).join(', ')}.';
    }
    texto += ' Para empezar, toque Tomar foto de mi documento.';
    VozService.hablar(texto);
  }

  Future<void> _ir(Widget pantalla) async {
    VozService.callar();
    await Navigator.push(context, MaterialPageRoute(builder: (_) => pantalla));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final actual = tramite.actual;
    final total = tramite.requisitos.length;
    final listos = tramite.listosDe(actual);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryButton(
                texto: 'Cambiar de trámite',
                icono: Icons.arrow_back,
                onPressed: () {
                  VozService.callar();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
              Text('Usted eligió', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              InfoCard(
                titulo: actual.titulo,
                texto: actual.paraQuien,
                icono: actual.icono,
                fondo: AppColors.primario.withValues(alpha: 0.18),
                borde: AppColors.borde,
              ),
              const SizedBox(height: 24),
              Text('Documentos que necesita',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                listos == 0
                    ? 'Son $total. Tómele una foto a cada uno.'
                    : 'Ya tiene $listos de $total.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              for (final r in tramite.requisitos) ...[
                ResultCard(texto: '${r.nombre}\n${r.detalle}', completo: tramite.tiene(r.id)),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              InfoCard(
                titulo: 'No olvide',
                texto: actual.notaExtra,
                icono: Icons.lightbulb_outline,
              ),
              const SizedBox(height: 24),
              BigButton(
                texto: 'Tomar foto de mi documento',
                icono: Icons.camera_alt,
                onPressed: () => _ir(const FotoScreen()),
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                texto: 'Hablar con el asistente',
                icono: Icons.mic,
                onPressed: () => _ir(const PreguntarScreen()),
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                texto: 'Escuchar la lista',
                icono: Icons.volume_up,
                onPressed: _leer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
