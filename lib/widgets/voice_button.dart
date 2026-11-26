import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VoiceButton extends StatelessWidget {
  final bool escuchando;
  final VoidCallback onPressed;

  const VoiceButton({
    super.key,
    required this.escuchando,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = escuchando ? AppColors.error : AppColors.primario;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: escuchando ? 'Dejar de escuchar' : 'Hablar',
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borde, width: 4),
              ),
              child: Icon(
                escuchando ? Icons.stop : Icons.mic,
                size: 72,
                color: AppColors.sobrePrimario,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          escuchando ? 'Escuchando...' : 'Toque para hablar',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.texto,
          ),
        ),
      ],
    );
  }
}
