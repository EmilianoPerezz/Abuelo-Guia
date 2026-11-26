import 'package:material_ui/material_ui.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        scaffoldBackgroundColor: AppColors.fondo,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primario,
          primary: AppColors.primario,
          onPrimary: AppColors.sobrePrimario,
          error: AppColors.error,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.texto),
          titleLarge: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.texto),
          bodyLarge: TextStyle(
              fontSize: 22,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: AppColors.texto),
          bodyMedium: TextStyle(
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: AppColors.texto),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primario,
          foregroundColor: AppColors.sobrePrimario,
          titleTextStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
          toolbarHeight: 72,
        ),
      );
}
