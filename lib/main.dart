import 'package:material_ui/material_ui.dart';
import 'screens/inicio_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const AbueloGuiaApp());

class AbueloGuiaApp extends StatelessWidget {
  const AbueloGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abuelo Guía',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const InicioScreen(),
    );
  }
}
