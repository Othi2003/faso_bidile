import 'package:faso_bidile/components/bar_navigation.dart';
import 'package:flutter/material.dart';

import '../components/categories/category_page.dart';
import '../components/categories/favorites_page.dart';
import '../components/categories/parametre.dart';
import '../components/home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigateToTab(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BarNavigation(
        onTap: (index) {
          navigateToTab(index);
        },
        SelectedItem: currentIndex,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(
            onNavigateToCategories: () => navigateToTab(1),
          ),
          const CategoriesPage(),
          FavoritesPage(
            onNavigateToCategories: () => navigateToTab(1),
          ),
          const SettingsPage(),
        ],
      ),
    );
  }
}