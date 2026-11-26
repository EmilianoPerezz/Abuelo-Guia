import 'package:material_ui/material_ui.dart';

import '../data/requisitos.dart';
import '../services/tramite.dart';
import '../services/voz_service.dart';
import '../theme/app_colors.dart';
import '../widgets/big_button.dart';
import '../widgets/info_card.dart';
import '../widgets/result_card.dart';
import '../widgets/secondary_button.dart';
import 'foto_screen.dart';
import 'preguntar_screen.dart';

class ResultadoScreen extends StatefulWidget {
  final bool recienRevisado;

  const ResultadoScreen({super.key, this.recienRevisado = false});

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.recienRevisado) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _leer());
    }
  }

  String get _siguientePaso {
    final revision = tramite.ultimaRevision;
    if (widget.recienRevisado && revision != null && revision.siguientePaso.isNotEmpty) {
      return revision.siguientePaso;
    }
    final faltan = tramite.faltantes;
    if (faltan.isEmpty) {
      return 'Ya tiene todos sus documentos. Llévelos a su Módulo de Bienestar.';
    }
    return 'Consiga su ${faltan.first.nombre.toLowerCase()} y tómele una foto.';
  }

  void _leer() {
    final revision = tramite.ultimaRevision;
    final partes = <String>[];
    if (widget.recienRevisado && revision != null) {
      partes.add('Su foto es: ${revision.documento}. ${revision.explicacion}');
    }
    final faltan = tramite.faltantes;
    if (faltan.isEmpty) {
      partes.add('Ya tiene todos los documentos.');
    } else {
      partes.add('Le falta: ${faltan.map((r) => r.nombre).join(', ')}.');
    }
    partes.add('Siguiente paso: $_siguientePaso');
    VozService.hablar(partes.join(' '));
  }

  void _ir(Widget pantalla, {bool reemplazar = false}) {
    VozService.callar();
    final ruta = MaterialPageRoute(builder: (_) => pantalla);
    if (reemplazar) {
      Navigator.pushReplacement(context, ruta);
    } else {
      Navigator.push(context, ruta);
    }
  }

  @override
  Widget build(BuildContext context) {
    final revision = tramite.ultimaRevision;
    final mostrarFoto = widget.recienRevisado && revision != null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryButton(
                texto: 'Volver al inicio',
                icono: Icons.home,
                onPressed: () {
                  VozService.callar();
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
              ),
              const SizedBox(height: 24),
              Text(mostrarFoto ? 'Esto es lo que encontré' : 'Sus documentos',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              if (mostrarFoto) ...[
                InfoCard(
                  titulo: revision.documento,
                  texto: revision.explicacion,
                  fondo: revision.sirve ? const Color(0xFFE6F2E8) : const Color(0xFFFFF3E0),
                  borde: revision.sirve ? AppColors.exito : const Color(0xFF8A4B00),
                  icono: revision.sirve ? Icons.thumb_up_alt_outlined : Icons.info_outline,
                ),
                const SizedBox(height: 24),
                Text('Su lista para la pensión',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
              ],
              for (final r in requisitos) ...[
                ResultCard(texto: r.nombre, completo: tramite.tiene(r.id)),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              InfoCard(
                titulo: 'Siguiente paso',
                texto: _siguientePaso,
                icono: Icons.directions_walk,
              ),
              const SizedBox(height: 12),
              const InfoCard(
                titulo: 'No olvide',
                texto: notaTelefonos,
                icono: Icons.phone,
              ),
              const SizedBox(height: 16),
              Text(notaOficial, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              SecondaryButton(
                texto: 'Escuchar',
                icono: Icons.volume_up,
                onPressed: _leer,
              ),
              const SizedBox(height: 16),
              BigButton(
                texto: 'Tengo una pregunta',
                icono: Icons.mic,
                onPressed: () => _ir(const PreguntarScreen()),
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                texto: tramite.faltantes.isEmpty ? 'Tomar otra foto' : 'Tomar foto de otro documento',
                icono: Icons.camera_alt,
                onPressed: () => _ir(const FotoScreen(), reemplazar: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
