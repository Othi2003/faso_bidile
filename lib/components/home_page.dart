import 'package:flutter/material.dart';

import 'categories/category_page.dart';
import 'categories/parametre.dart';

class ImagePath {
  static String accueil = 'assets/img1.png';
  static String explore = 'assets/img2.png';
}

class HomePage extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;

  const HomePage({super.key, this.onNavigateToCategories});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        child: Padding(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(
            children: [
              SizedBox(height: h * 0.02),
              Text(
                'Bienvenue sur\nFaso Bidilé !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: w * 0.09,
                  fontWeight: FontWeight.bold,
                  color: _settings.primaryColor,
                  letterSpacing: 0.5,
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Que souhaitez-vous cuisiner aujourd\'hui ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: w * 0.065,
                        height: 1.3,
                        color: isDark ? Colors.white.withOpacity(0.9) : Colors.grey[800],
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    Container(
                      height: h * 0.25,
                      width: w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _settings.primaryColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Container(
                              width: w,
                              height: h * 0.25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(ImagePath.explore),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: w,
                              height: h * 0.25,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _settings.primaryColor.withOpacity(0.1),
                                    _settings.primaryColor.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: w,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _settings.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _settings.primaryColor.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _settings.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: _settings.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.restaurant_menu,
                        color: _settings.primaryColor,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Nous vous proposons les meilleures\nrecettes culinaires du Faso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.04,
                        color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey[700],
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: w * 0.5,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            _settings.primaryColor,
                            _settings.primaryColor.withOpacity(0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _settings.primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.onNavigateToCategories != null) {
                            widget.onNavigateToCategories!();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Voir plus',
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}