import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ResultCard extends StatelessWidget {
  final String texto;
  final bool completo;

  const ResultCard({
    super.key,
    required this.texto,
    required this.completo,
  });

  @override
  Widget build(BuildContext context) {
    final color = completo ? AppColors.exito : AppColors.error;
    final icono = completo ? Icons.check_circle : Icons.cancel;
    final etiqueta = completo ? 'Ya lo tiene' : 'Falta';

    return Semantics(
      label: '$etiqueta: $texto',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icono, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    etiqueta,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Text(
                    texto,
                    style: const TextStyle(
                      fontSize: 22,
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
