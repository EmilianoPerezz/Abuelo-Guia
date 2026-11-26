import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class Cargando extends StatelessWidget {
  final String texto;

  const Cargando({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: texto,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.primario, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(strokeWidth: 7, color: AppColors.primario),
            ),
            const SizedBox(height: 20),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.texto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
