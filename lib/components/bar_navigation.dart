import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'categories/parametre.dart';

class BarNavigation extends StatefulWidget {
  final int SelectedItem;
  final Function(int) onTap;
  const BarNavigation({super.key, required this.onTap, required this.SelectedItem});

  @override
  State<BarNavigation> createState() => _BarNavigationState();
}

class _BarNavigationState extends State<BarNavigation> {
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

    return Container(
      color: _settings.getNavigationBackgroundColor(isDark),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .015, vertical: h * .01),
        child: GNav(
          gap: 10,
          tabBorderRadius: 100,
          backgroundColor: _settings.getNavigationBackgroundColor(isDark),
          activeColor: Colors.white,
          color: isDark ? Colors.grey[400] : _settings.primaryColor.withOpacity(0.7),
          tabBackgroundGradient: LinearGradient(
            colors: [
              _settings.primaryColor.withOpacity(0.7),
              _settings.primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          iconSize: 30,
          textSize: 18,
          padding: EdgeInsets.symmetric(horizontal: w * .01, vertical: h * .01),
          tabs: const [
            GButton(icon: CupertinoIcons.home, text: 'Accueil'),
            GButton(icon: Icons.category_outlined, text: 'Catégories'),
            GButton(icon: Icons.favorite_border, text: 'Favoris'),
            GButton(icon: Icons.settings, text: 'Paramètres'),
          ],
          onTabChange: widget.onTap,
          selectedIndex: widget.SelectedItem,
        ),
      ),
    );
  }
}