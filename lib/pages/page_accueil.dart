import 'package:faso_bidile/pages/home.dart';
import 'package:flutter/material.dart';
import '../components/categories/parametre.dart';
import '../constants/images_path.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
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
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                  height: h * .79,
                  width: w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImagePath.Accueil),
                          fit: BoxFit.cover
                      )
                  ),
                )
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  height: h * .243,
                  width: w,
                  decoration: BoxDecoration(
                    // Utilisation de la couleur de background du système
                    color: _settings.getBackgroundColor(isDark),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40)
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: h * .032),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Découvrez les délices du Burkina',
                            style: TextStyle(
                              fontSize: w * .053,
                              fontWeight: FontWeight.w800,
                              // Couleur du texte adaptée au thème
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: h * .03),
                          Text(
                            'Une cuisine qui rassemble',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              // Couleur du texte adaptée au thème
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                          SizedBox(height: h * .02),
                          SizedBox(
                            width: w * .8,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()
                                    )
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                // Couleur de fond du bouton selon le thème sélectionné
                                backgroundColor: _settings.primaryColor,
                                // Couleur du texte (blanc pour contraster)
                                foregroundColor: Colors.white,
                                // Hauteur du bouton
                                minimumSize: Size(double.infinity, h * 0.06),
                                // Bordures arrondies
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                // Effet d'élévation
                                elevation: 3,
                              ),
                              child: const Text(
                                'Commencez Maintenant',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}