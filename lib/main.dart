import 'package:flutter/material.dart';
import 'package:faso_bidile/pages/page_accueil.dart';
import 'components/categories/category_page.dart';
import 'components/categories/parametre.dart';

void main() async {
  // S'assurer que Flutter est initialisé
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les managers avec la persistance
  final appSettings = AppSettings();
  final favoritesManager = FavoritesManager(); // Décommenté

  // Charger les données sauvegardées
  await appSettings.initialize();
  await favoritesManager.initialize(); // Décommenté

  runApp(MyApp(settings: appSettings));
}

class MyApp extends StatefulWidget {
  final AppSettings settings;

  const MyApp({super.key, required this.settings});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Attendre que les settings soient chargés
    if (!_settings.isInitialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _settings.themeMode,
      theme: ThemeData(
        scaffoldBackgroundColor: _settings.getBackgroundColor(false),
        colorScheme: _settings.getColorScheme(Brightness.light),
        appBarTheme: AppBarTheme(
          backgroundColor: _settings.getBackgroundColor(false),
          foregroundColor: _settings.primaryColor,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: _settings.getBackgroundColor(true),
        colorScheme: _settings.getColorScheme(Brightness.dark),
        appBarTheme: AppBarTheme(
          backgroundColor: _settings.getBackgroundColor(true),
          foregroundColor: _settings.primaryColor,
        ),
        useMaterial3: true,
      ),
      home: const PageAccueil(),
    );
  }
}