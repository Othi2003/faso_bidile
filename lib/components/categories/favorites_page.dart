import 'parametre.dart';
import 'package:flutter/material.dart';

import 'category_page.dart';

class FavoritesPage extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;

  const FavoritesPage({super.key, this.onNavigateToCategories});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  final AppSettings _settings = AppSettings();

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> _getFavoriteRecipes() {
    final allRecipes = RecipeData.getRecipeDetails();
    final favoriteIds = _favoritesManager.favoriteRecipeIds;

    return allRecipes.values.where((recipe) {
      final recipeId = recipe['id']?.toString() ?? recipe['name'];
      return favoriteIds.contains(recipeId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = _getFavoriteRecipes();
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _settings.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Mes favoris',
            style: TextStyle(
              fontSize: w * .08,
              fontWeight: FontWeight.bold,
              color: _settings.primaryColor,
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: _settings.primaryColor),
        actions: [
          if (favoriteRecipes.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear_all,
                color: _settings.primaryColor,
              ),
              onPressed: () {
                _showClearAllDialog();
              },
              tooltip: 'Vider tous les favoris',
            ),
        ],
      ),
      body: favoriteRecipes.isEmpty
          ? _buildEmptyState(isDark)
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 9),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 0.76,
          ),
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipe: favoriteRecipes[index],
                    ),
                  ),
                );
              },
              child: ModernRecipeCard(recipe: favoriteRecipes[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune recette favorite',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des recettes à vos favoris\nen appuyant sur le cœur',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Utiliser le callback pour naviguer vers l'onglet Catégories
              if (widget.onNavigateToCategories != null) {
                widget.onNavigateToCategories!();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _settings.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text('Découvrir les recettes'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Vider les favoris',
            style: TextStyle(color: _settings.primaryColor),
          ),
          content: Text(
            'Êtes-vous sûr de vouloir retirer toutes les recettes de vos favoris ?',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                _favoritesManager.clearFavorites();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Tous les favoris ont été supprimés'),
                    backgroundColor: isDark ? Colors.grey[700] : Colors.black87,
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text('Vider'),
            ),
          ],
        );
      },
    );
  }
}