import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class BigButton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback onPressed;
  final Color color;

  const BigButton({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    this.color = AppColors.primario,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: texto,
      child: SizedBox(
        width: double.infinity,
        height: 80,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icono, size: 36),
          label: Text(texto, textAlign: TextAlign.center),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: AppColors.sobrePrimario,
            textStyle:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            side: const BorderSide(color: AppColors.borde, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
