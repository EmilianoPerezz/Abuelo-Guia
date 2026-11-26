import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: texto,
      child: SizedBox(
        width: double.infinity,
        height: 72,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primario,
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            side: const BorderSide(color: AppColors.primario, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icono != null) ...[
                Icon(icono, size: 32),
                const SizedBox(width: 12),
              ],
              Flexible(child: Text(texto, textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }
}
