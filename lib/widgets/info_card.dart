import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class InfoCard extends StatelessWidget {
  final String titulo;
  final String texto;
  final Color fondo;
  final Color borde;
  final IconData? icono;

  const InfoCard({
    super.key,
    required this.titulo,
    required this.texto,
    this.fondo = Colors.white,
    this.borde = const Color(0xFF9FB4C4),
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$titulo. $texto',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: fondo,
          border: Border.all(color: borde, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icono != null) ...[
              Icon(icono, size: 36, color: AppColors.primario),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.texto,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    texto,
                    style: const TextStyle(
                      fontSize: 21,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.texto,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
