import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../services/gemini_service.dart';
import '../services/tramite.dart';
import '../services/voz_service.dart';
import '../theme/app_colors.dart';
import '../widgets/big_button.dart';
import '../widgets/cargando.dart';
import '../widgets/info_card.dart';
import '../widgets/secondary_button.dart';
import 'resultado_screen.dart';

class FotoScreen extends StatefulWidget {
  const FotoScreen({super.key});

  @override
  State<FotoScreen> createState() => _FotoScreenState();
}

class _FotoScreenState extends State<FotoScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _foto;
  bool _revisando = false;
  String? _error;

  Future<void> _tomar(ImageSource origen) async {
    setState(() => _error = null);
    XFile? archivo;
    try {
      archivo = await _picker.pickImage(
        source: origen,
        maxWidth: 1600,
        imageQuality: 75,
      );
    } catch (_) {
      setState(() => _error = 'No pude abrir la cámara. Revise que la app tenga permiso.');
      return;
    }
    if (archivo == null) return;

    final bytes = await archivo.readAsBytes();
    final tipo = archivo.name.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
    setState(() {
      _foto = bytes;
      _revisando = true;
    });
    VozService.hablar('Estoy revisando su documento. Espere un momento, por favor.');

    try {
      final revision = await GeminiService.revisarDocumento(bytes, tipo);
      tramite.guardarRevision(revision);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResultadoScreen(recienRevisado: true)),
      );
    } catch (e) {
      final mensaje = e is GeminiError ? e.mensaje : 'Algo salió mal. Intente otra vez.';
      VozService.hablar(mensaje);
      if (!mounted) return;
      setState(() {
        _revisando = false;
        _error = mensaje;
      });
    }
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
              SecondaryButton(
                texto: 'Volver',
                icono: Icons.arrow_back,
                onPressed: () {
                  VozService.callar();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
              Text('Tome una foto de su documento',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Para: ${tramite.actual.titulo}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text('Ponga la hoja sobre una mesa, con buena luz.',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              _MarcoFoto(foto: _foto),
              const SizedBox(height: 20),
              if (_revisando)
                const Cargando(texto: 'Estoy revisando su documento...')
              else ...[
                if (_error != null) ...[
                  InfoCard(
                    titulo: 'Intente otra vez',
                    texto: _error!,
                    fondo: const Color(0xFFFFF0F0),
                    borde: AppColors.error,
                    icono: Icons.info_outline,
                  ),
                  const SizedBox(height: 20),
                ],
                BigButton(
                  texto: 'Tomar foto',
                  icono: Icons.camera_alt,
                  onPressed: () => _tomar(ImageSource.camera),
                ),
                const SizedBox(height: 16),
                SecondaryButton(
                  texto: 'Usar una foto guardada',
                  icono: Icons.photo_library,
                  onPressed: () => _tomar(ImageSource.gallery),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MarcoFoto extends StatelessWidget {
  final Uint8List? foto;

  const _MarcoFoto({this.foto});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BordePunteado(),
      child: Container(
        width: double.infinity,
        height: 300,
        padding: const EdgeInsets.all(10),
        child: foto == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description_outlined, size: 72, color: AppColors.primario),
                  SizedBox(height: 12),
                  Text(
                    'Aquí aparecerá su foto',
                    style: TextStyle(fontSize: 22, color: AppColors.texto),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(foto!, fit: BoxFit.contain),
              ),
      ),
    );
  }
}

class _BordePunteado extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = AppColors.primario
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final ruta = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)));
    for (final metrica in ruta.computeMetrics()) {
      double d = 0;
      while (d < metrica.length) {
        canvas.drawPath(metrica.extractPath(d, d + 12), pincel);
        d += 20;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
