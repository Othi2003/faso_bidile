// ======================================================
// Fichier: lib/models/app_settings.dart
// ======================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // Clés pour SharedPreferences
  static const String _themeModeKey = 'theme_mode';
  static const String _colorThemeKey = 'color_theme';

  // Thème
  ThemeMode _themeMode = ThemeMode.light;
  String _colorTheme = 'default';

  // Indicateur de chargement initial
  bool _isInitialized = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get colorTheme => _colorTheme;
  bool get isInitialized => _isInitialized;

  // Initialisation - à appeler au démarrage de l'app
  Future<void> initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();

    // Charger le mode thème
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.light.index;
    _themeMode = ThemeMode.values[themeModeIndex];

    // Charger le thème de couleur
    _colorTheme = prefs.getString(_colorThemeKey) ?? 'default';

    _isInitialized = true;
    notifyListeners();
  }

  // Méthodes de mise à jour avec sauvegarde
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> setColorTheme(String theme) async {
    _colorTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorThemeKey, theme);
    notifyListeners();
  }

  // Couleur primaire selon le thème sélectionné
  Color get primaryColor {
    switch (_colorTheme) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      default:
        return Colors.brown;
    }
  }

  // Couleur de background adaptée
  Color getBackgroundColor(bool isDark) {
    if (isDark) {
      return Colors.grey[900]!;
    }

    switch (_colorTheme) {
      case 'blue':
        return Colors.blue[50]!;
      case 'green':
        return Colors.green[50]!;
      case 'purple':
        return Colors.purple[50]!;
      case 'orange':
        return Colors.orange[50]!;
      default:
        return const Color(0xFFFCF8F5);
    }
  }

  // Couleur claire pour la navigation
  Color getNavigationBackgroundColor(bool isDark) {
    if (isDark) {
      return Colors.grey[850]!;
    }

    switch (_colorTheme) {
      case 'blue':
        return Colors.blue[100]!;
      case 'green':
        return Colors.green[100]!;
      case 'purple':
        return Colors.purple[100]!;
      case 'orange':
        return Colors.orange[100]!;
      default:
        return Colors.brown[100]!;
    }
  }

  // Obtenir les couleurs du thème
  ColorScheme getColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness
    );
  }

  // Réinitialiser les paramètres
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.light;
    _colorTheme = 'default';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeModeKey);
    await prefs.remove(_colorThemeKey);

    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppSettings _settings = AppSettings();

  @override
  void initState() {
    super.initState();
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
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _settings.getBackgroundColor(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Header personnalisé
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Paramètres',
                style: TextStyle(
                  fontSize: w * .08,
                  fontWeight: FontWeight.bold,
                  color: _settings.primaryColor,
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Section Apparence
                  _buildSection(
                    'Apparence',
                    Icons.palette,
                    [
                      _buildThemeSelector(),
                      _buildColorThemeSelector(),
                    ],
                    isDark,
                  ),
                  const SizedBox(height: 20),

                  // Section À propos
                  _buildSection(
                    'À propos',
                    Icons.info,
                    [
                      _buildActionTile(
                        'Aide et support',
                        'Obtenir de l\'aide ou signaler un problème',
                        Icons.help,
                        _showHelp,
                      ),
                      _buildActionTile(
                        'À propos de l\'application',
                        'Informations sur l\'application',
                        Icons.info_outline,
                        _showAbout,
                      ),
                    ],
                    isDark,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: _settings.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _settings.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? Colors.grey[600] : Colors.grey),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSelector() {
    return ListTile(
      title: const Text('Mode d\'affichage'),
      subtitle: Text(_getThemeModeText()),
      trailing: const Icon(Icons.chevron_right),
      onTap: _showThemeDialog,
    );
  }

  Widget _buildColorThemeSelector() {
    return ListTile(
      title: const Text('Couleur du thème'),
      subtitle: Text(_getColorThemeText()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _getThemeColor(),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: _showColorThemeDialog,
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: _settings.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Méthodes utilitaires
  String _getThemeModeText() {
    switch (_settings.themeMode) {
      case ThemeMode.light:
        return 'Clair';
      case ThemeMode.dark:
        return 'Sombre';
      case ThemeMode.system:
        return 'Automatique';
    }
  }

  String _getColorThemeText() {
    switch (_settings.colorTheme) {
      case 'blue':
        return 'Bleu';
      case 'green':
        return 'Vert';
      case 'purple':
        return 'Violet';
      case 'orange':
        return 'Orange';
      default:
        return 'Marron (par défaut)';
    }
  }

  Color _getThemeColor() {
    return _settings.primaryColor;
  }

  // Dialogues
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mode d\'affichage'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Clair', ThemeMode.light, Icons.light_mode),
            _buildThemeOption('Sombre', ThemeMode.dark, Icons.dark_mode),
            _buildThemeOption('Automatique', ThemeMode.system, Icons.auto_mode),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, ThemeMode mode, IconData icon) {
    return RadioListTile<ThemeMode>(
      title: Row(
        children: [
          Icon(icon, size: 20, color: _settings.primaryColor),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      value: mode,
      groupValue: _settings.themeMode,
      activeColor: _settings.primaryColor,
      onChanged: (value) {
        if (value != null) {
          _settings.setThemeMode(value);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showColorThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Couleur du thème'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildColorOption('Par défaut', 'default', Colors.brown),
            _buildColorOption('Bleu', 'blue', Colors.blue),
            _buildColorOption('Vert', 'green', Colors.green),
            _buildColorOption('Violet', 'purple', Colors.purple),
            _buildColorOption('Orange', 'orange', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(String title, String colorKey, Color color) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      value: colorKey,
      groupValue: _settings.colorTheme,
      activeColor: _settings.primaryColor,
      onChanged: (value) {
        if (value != null) {
          _settings.setColorTheme(value);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Aide et support',
          style: TextStyle(color: _settings.primaryColor),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment utiliser l\'application :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _settings.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text('• Explorez vos plats par catégorie'),
              const Text('• Ajoutez vos favoris en appuyant sur le cœur'),
              const Text('• Découvrez des recettes traditionnelles'),
              const Text('• Personnalisez l\'apparence dans les paramètres'),
              const SizedBox(height: 16),
              Text(
                'Besoin d\'aide ?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _settings.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Contactez-nous à : yawothi@gmail.com'),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: _settings.primaryColor,
            ),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'À propos',
          style: TextStyle(color: _settings.primaryColor),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Faso Bidilé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _settings.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0'),
            const SizedBox(height: 16),
            const Text('Découvrez la richesse culinaire du Burkina Faso à travers nos recettes traditionnelles.'),
            const SizedBox(height: 16),
            Text(
              'Développé avec ❤️ pour préserver notre patrimoine culinaire',
              style: TextStyle(
                color: _settings.primaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: _settings.primaryColor,
            ),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}