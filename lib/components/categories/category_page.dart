import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/images_path.dart';
import 'parametre.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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

    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Entrées',
        'count': '6 recettes',
        'image': ImagePath.entrees,
      },
      {
        'name': 'Plats principaux',
        'count': '12 recettes',
        'image': ImagePath.plats,
      },
      {
        'name': 'Desserts',
        'count': '6 recettes',
        'image': ImagePath.desserts,
      },
      {
        'name': 'Boissons',
        'count': '8 recettes',
        'image': ImagePath.boissons,
      },
    ];

    return Scaffold(
      backgroundColor: _settings.getBackgroundColor(isDark),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Catégories',
                  style: TextStyle(
                    fontSize: w * .08,
                    fontWeight: FontWeight.bold,
                    color: _settings.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: h * .02),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double gridHeight = constraints.maxHeight;
                    double cellHeight = gridHeight / 2;
                    double availableWidth = constraints.maxWidth - 4;
                    double cellWidth = availableWidth / 2;
                    double aspectRatio = cellWidth / cellHeight;

                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailPage(
                                  categoryName: categories[index]['name'],
                                ),
                              ),
                            );
                          },
                          child: CategoryCardWithImage(
                            category: categories[index],
                            primaryColor: _settings.primaryColor,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCardWithImage extends StatelessWidget {
  final Map<String, dynamic> category;
  final Color primaryColor;

  const CategoryCardWithImage({
    super.key,
    required this.category,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                category['image'],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['count'],
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeData {
  static Map<String, Map<String, dynamic>> getRecipeDetails() {
    return {
      // ENTRÉES
      'Zamné sauté': {
        'name': 'Zamné sauté',
        'image': 'assets/zamnesaute.jpg',
        'cookingTime': '45 min',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Zamné précuit', 'quantity': '500 g', 'image': 'assets/zamne.webp'},
          {'name': 'Viande hachée crue', 'quantity': '500 g', 'image': 'assets/viande.jpg'},
          {'name': 'Oignon cru', 'quantity': ' 3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Poivron cru', 'quantity': '2', 'image': 'assets/poivron.jpg'},
          {'name': 'Huile végétale', 'quantity': '25 Cl', 'image': 'assets/huile.jpg'},
        ],
        'steps': [
          'Bouillir le zamné pendant 30 minutes et éssorer',
          'Dans une casserole au feu, mettre l’huile et faire revenir la viande hachée, le poivron et les oignons finement découpés : laisser cuire 5 a 10 minutes',
          'Ajouter le zamné au contenu sur le feu et laisser mijoter 5 minutes puis servir',
        ]
      },

      'Salade de Kienebdo': {
        'name': 'Salade de Kienebdo',
        'image': 'assets/saladekienebdo.png',
        'cookingTime': '55 min',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Feuilles de kienebdo', 'quantity': '3 assiettées', 'image': 'assets/feuillekienebdo.png'},
          {'name': 'Ail cru', 'quantity': ' 6 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Oignon cru', 'quantity': '4 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Poisson frais', 'quantity': '0.5 Kg', 'image': 'assets/poisson.jpg'},
          {'name': 'Huile végétale', 'quantity': '6 c. à soupe', 'image': 'assets/huile.jpg'},
          {'name': 'Sel iodé', 'quantity': '1 pincée', 'image': 'assets/sel.jpg'},
          {'name': 'Vinaigre', 'quantity': '1 cuillérée', 'image': 'assets/vinaigre.jpg'},
        ],
        'steps': [
          'Trier, laver et découper les feuilles de kienebdo',
          'Mettre les feuilles de kienebdo dans la casserole contenant 2 litres et demi d’eau bouillante et attendre 40 minutes',
          'Laver le poisson a l’eau contenant une cuillérée de vinaigre et rincer',
          'Cuire le poisson a la vapeur et enlever les arrêtes',
          'Laver et découper les oignons et écraser l’ail',
          'Mettre les oignons dans une casserole contenant de l’huile chaude et ajouter une pincée de sel',
          '5 minutes après, ajouter le poisson désossé et attendre 10 minutes',
          'Ajouter les feuilles bouillies dans la casserole, remuer et servir'
        ]
      },

      'Poaloanga sauté': {
        'name': 'Poaloanga sauté',
        'image': 'assets/poaloanga1.png',
        'cookingTime': '2h30',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Feuilles séchées de poaloanga', 'quantity': '750 g', 'image': 'assets/poaloanga.png'},
          {'name': 'Oignon cru', 'quantity': '3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '5', 'image': 'assets/tomate.webp'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Huile végétale', 'quantity': '150 ml', 'image': 'assets/huile.jpg'},
          {'name': 'Ail cru', 'quantity': '5 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Epices au choix', 'quantity': '', 'image': 'assets/epices.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Laver et bouillir pendant 2 heures les feuilles de Poaloanga à l’eau simple puis essorer',
          'Laver et couper finement les oignons, tomates, poivrons et écraser l’ail',
          'Faire revenir les légumes coupés dans l’huile',
          'Ajouter un peu d’eau puis laisser cuire pendant 10 minutes',
          'Saler, épicer et ajouter les feuilles précuites de poaloanga',
          'Mélanger, laisser mijoter au moins 7 minutes à feu doux puis servir',
        ]
      },

      'Dounkoum': {
        'name': 'Dounkoum',
        'image': 'assets/dounkoum.png',
        'cookingTime': '6h15',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Jeunes feuilles de Dounkoum', 'quantity': '1 Kg', 'image': 'assets/feuillesdounkoum.png'},
          {'name': 'Beurre de karité', 'quantity': '200 g', 'image': 'assets/beurrekarite.jpg'},
          {'name': 'Oignon cru', 'quantity': '3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '3', 'image': 'assets/tomate.webp'},
          {'name': 'Poivron cru', 'quantity': '3', 'image': 'assets/poivron.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Laver et bouillir pendant 6 heures les feuilles de dounkoum puis les essorer',
          'Couper finement les oignons, tomates et poivrons',
          'Dans une casserole au feu, faire fondre le beurre de karité et y faire revenir les légumes découpés',
          'Laisser mijoter 5 minutes, ajouter un peu de sel et ajouter les feuilles précuites',
          'Laisser le tout mijoter quelques minutes à feu doux puis servir',
        ]
      },

      'Salade de Koumvando': {
        'name': 'Salade de Koumvando',
        'image': 'assets/saladekoumvando.png',
        'cookingTime': '45 min',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Feuilles fraîches d\'aubergine locale', 'quantity': '3 bols', 'image': 'assets/feuillesaubergine.jpg'},
          {'name': 'Oignon cru', 'quantity': '1 bulbe', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '2', 'image': 'assets/tomate.webp'},
          {'name': 'Concombre', 'quantity': '1', 'image': 'assets/concombre.jpg'},
          {'name': 'Œuf', 'quantity': '2', 'image': 'assets/oeuf.jpg'},
          {'name': 'Huile végétale', 'quantity': '', 'image': 'assets/huile.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Porter à ébullition de l’eau dans une casserole et y renverser les feuilles d’aubergine lavées et découpées : laisser bouillir pendant 45 minutes',
          'Essorer, presser et disposer dans un plateau',
          'Découper l’oignon, les tomates, les oeufs bouillis et le concombre pour garnir le plateau et c\'est prêt !',
        ]
      },

      'Salade soumbala-moringa': {
        'name': 'Salade soumbala-moringa',
        'image': 'assets/saladesoumbala.png',
        'cookingTime': '1 jour + 12h30',
        'category': 'Entrées',
        'servings': 1,
        'ingredients': [
          {'name': 'Graines de néré cru', 'quantity': '500 g', 'image': 'assets/néré.webp'},
          {'name': 'Feuilles fraîches de moringa', 'quantity': '50 g', 'image': 'assets/moringa.jpg'},
          {'name': 'Tomates fraîches', 'quantity': '3', 'image': 'assets/tomate.webp'},
          {'name': 'Citron cru', 'quantity': '1', 'image': 'assets/citron.jpg'},
          {'name': 'Poivron vert cru', 'quantity': '2', 'image': 'assets/poivron.jpg'},
          {'name': 'Huile d\'arachide', 'quantity': '2 c. à soupe', 'image': 'assets/huile.jpg'},
        ],
        'steps': [
          'Faire bouillir les graines de néré pendant 1 jour, puis enlever la peau au pilon et laver proprement',
          'Cuire les graines obtenues pendant 12 heures et essorer',
          'Laver et bouillir pendant 15 minutes les feuilles de moringa',
          'Découper en petit « dé » la tomate, le poivron et l’oignon',
          'Mélanger le tout avec le soumbala et le moringa',
          'Asperger du jus de citron, une a deux cuillerées d’huile d\'arachide, saler et servir'
        ]
      },

      // PLATS PRINCIPAUX
      'Benga (Haricot)': {
        'name': 'Benga (Haricot)',
        'image': 'assets/benga.png',
        'cookingTime': '1h10',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Haricot local cru', 'quantity': '1 Kg', 'image': 'assets/haricot.webp'},
          {'name': 'Potasse', 'quantity': '1 petite portion', 'image': 'assets/potasse.webp'},
          {'name': 'Sel iodé', 'quantity': '1 c. à soupe', 'image': 'assets/sel.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '2', 'image': 'assets/tomate.webp'},
          {'name': 'Oignon cru', 'quantity': '3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Huile végétale', 'quantity': '0.25 litre', 'image': 'assets/huile.jpg'},
        ],
        'steps': [
          'Trier, laver et épierrer le haricot',
          'Le mettre dans une casserole au feu contenant 3 litres d’eau bouillante et laisser cuire 10 minutes',
          'Mettre la potasse et attendre 30 minutes de cuisson puis saler',
          'Mettre sur feu doux et attendre 10 minutes',
          'Laver et de couper la tomate et les oignons',
          'Mettre ¼ litre d’huile dans une casserole au feu doux et y faire revenir les oignons et tomates découpés',
          'Laisser mijoter 15 minutes',
          'Attendre 4 minutes de cuisson et servir'
        ]
      },

      'Baabenda': {
        'name': 'Baabenda',
        'image': 'assets/baabenda.jpg',
        'cookingTime': '1h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Riz blanc cru', 'quantity': '500 g', 'image': 'assets/riz.webp'},
          {'name': 'Feuilles de balambourou ', 'quantity': '6 assiettées', 'image': 'assets/balambourou.jpg'},
          {'name': 'Feuilles d\'oseilles', 'quantity': '3 assiettées', 'image': 'assets/oseille.jpeg'},
          {'name': 'Feuilles de Kienebdo ', 'quantity': '3 assiettées', 'image': 'assets/feuillekienebdo.png'},
          {'name': 'Graines d\'arachide crues', 'quantity': '1/2 bol', 'image': 'assets/arachide.jpg'},
          {'name': 'Huile végétale', 'quantity': '1/4 litre', 'image': 'assets/huile.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Laver les feuilles a  l’eau de javel et rincer 3 fois ',
          'Mettre les feuilles de balambourou dans une casserole contenant 4 litres d\'eau bouillante et attendre 8 minutes',
          'Mettre les feuilles de kienebdo et attendre 8 minutes',
          'Mettre les feuilles d’oseille',
          '13 minutes après, mettre le riz lavé et écrasé au mortier',
          '10 minutes après, mettre la farine d’arachide',
          'Attendre 22 minutes et servir en ajoutant l\'huile et le sel à votre convenance '
        ]
      },

      'Soum nè piigri': {
        'name': 'Soum nè piigri',
        'image': 'assets/soumpiga.jpg',
        'cookingTime': '3h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Pois de terre crus', 'quantity': '500 g', 'image': 'assets/poisterre.jpg'},
          {'name': 'Farine de petit mil', 'quantity': '250 g', 'image': 'assets/farinemil.png'},
          {'name': 'Farine d\'arachide', 'quantity': '100 g', 'image': 'assets/farinearachide.webp'},
          {'name': 'Oignon cru', 'quantity': '4 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '3', 'image': 'assets/tomate.webp'},
          {'name': 'Potasse concentrée', 'quantity': '1 c. à soupe', 'image': 'assets/potasse.webp'},
          {'name': 'Huile végétale', 'quantity': '1/4 litre', 'image': 'assets/huile.jpg'},
          {'name': 'Piment frais', 'quantity': '2 gousses', 'image': 'assets/piment.png'},
          {'name': 'Sel iodé', 'quantity': '1/2 c. à soupe', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Epierrer et laver proprement les pois de terre',
          'Mettre le pois de terre dans une marmite contenant l\'eau bouillante jusqu\'a cuisson',
          'Diluer la potasse dans un récipient contenant 1 litre d\'eau. Y ajouter les farines de petit mil et d\'arachide et mélanger jusqu\'a obtenir une pâte mole',
          'Faire des boulettes de la pâte obtenue',
          'Mettre les boulettes sur les pois de terre cuits et attendre leur cuisson complète',
          'Pour la suace, aver et de couper les tomates et oignons',
          'Les mettre dans une casserole au feu contenant l\'huile chaude',
          'Remuer et attendre un instant pour servir'
        ]
      },

      'Kanzaga': {
        'name': 'Kanzaga',
        'image': 'assets/kanzaga.png',
        'cookingTime': '1h30',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Feuilles fraîches de kanzaga', 'quantity': '8 poignées', 'image': 'assets/feuilles.jpg'},
          {'name': 'Feuilles fraîches de moringa', 'quantity': '2 poignées', 'image': 'assets/moringa.jpg'},
          {'name': 'Feuilles fraîches de courge', 'quantity': '4 poignées', 'image': 'assets/feuillescourge.jpg'},
          {'name': 'Fruit de courge frais', 'quantity': '2', 'image': 'assets/courge.jpg'},
          {'name': 'Poudre d’arachide cru', 'quantity': '1 bol', 'image': 'assets/farinearachide.webp'},
          {'name': 'Riz blanc concassé', 'quantity': '100 g', 'image': 'assets/riz.webp'},
          {'name': 'Beurre de karité', 'quantity': '100 g', 'image': 'assets/beurrekarite.jpg'},
        ],
        'steps': [
          'Bouillir ensemble les feuilles de courge et de moringa pendant au moins 1 heure de temps',
          'Bouillir les feuilles de kanzaga jusqu\'à cuisson, essorer et ajouter aux feuilles de courge et de moringa toujours au feu',
          'Mettre la poudre d’arachide et le riz mouillé concassé au-dessus : attendre 15 minutes et mélanger',
          'Laisser mijoter pendant 10 minutes à feu doux. Servir le kanzaga avec le beurre de karité',
        ]
      },
      'Tô à la sauce verte': {
        'name': 'Tô à la sauce verte',
        'image': 'assets/tovert.png',
        'cookingTime': '1h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Farine de maïs', 'quantity': '1 Kg', 'image': 'assets/farinemais.jpg'},
          {'name': 'Citron frais', 'quantity': '3', 'image': 'assets/citron.jpg'},
          {'name': 'Beurre de karité ', 'quantity': '20 g', 'image': 'assets/beurrekarite.jpg'},
          {'name': 'Viande de bœuf', 'quantity': '1 kg', 'image': 'assets/viande.png'},
          {'name': 'Gombo frais', 'quantity': '10', 'image': 'assets/gombo.jpg'},
          {'name': 'feuilles fraîches de boulvaka', 'quantity': '2 poignées', 'image': 'assets/boulvakan.jpg'},
          {'name': 'Oignon cru', 'quantity': '2 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomates fraîches', 'quantity': '3', 'image': 'assets/tomate.webp'},
          {'name': 'Huile', 'quantity': '15 cl', 'image': 'assets/huile.jpg'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Ail frais', 'quantity': '4 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Poudre de soumbala', 'quantity': '30 g', 'image': 'assets/soumbala.jpg'},
          {'name': 'Potasse', 'quantity': '', 'image': 'assets/potasse.webp'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Pour le tô Couper et presser le citron pour recueillir le jus et le filtrer ',
          'Dans une marmite au feu, faire bouillir 1,5 litre d\'eau',
          'Dans un récipient, ajouter ½ litre d\'eau au jus de citron, y délayer 300 g de farine et mettre le mélange dans la marmite en remuant pour obtenir une bouillie et laisser cuire pendant 5 minutes',
          'Mettre le reste de la farine dans la bouillie au feu et attendre 3 minutes de cuisson',
          'Bien mélanger à l\'aide d’une spatule le contenu de la marmite et bien battre jusqu\'à obtenir une pâte semi solide et homogène',
          'Servir le tô dans un plat en y mettant au fur et à mesure le beurre de karité',
          'Pour la sauce laver et couper les oignons, les tomates, la viande ; écraser l\'ail et hacher le persil ',
          'Faire revenir dans l\'huile la viande, ajouter l\'oignon, et la tomate',
          'Laisser mijoter et ajouter 1,5 litre d’eau',
          'Laisser bouillir et mettre la potasse puis renverser le gombo frais découpé',
          'Laisser bouillir pendant 10 minutes et ajouter les feuilles de boulvaka, attendre 10 minutes et mettre le soumbala, l\'ail et le persil',
          'Saler et garder 5 minutes à feu doux puis servir'
        ]
      },

      'Soupe de chenilles': {
        'name': 'Soupe de chenilles',
        'image': 'assets/chenillessoupe.jpg',
        'cookingTime': '45 min',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Chenilles de karité', 'quantity': '200 g', 'image': 'assets/chenille.jpg'},
          {'name': 'Oignon frais', 'quantity': '3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '4', 'image': 'assets/tomate.webp'},
          {'name': 'Poudre de soumbala', 'quantity': '10 g', 'image': 'assets/soumbala.jpg'},
          {'name': 'Poivre noir séchée', 'quantity': '', 'image': 'assets/epices.jpg'},
          {'name': 'Sel iodé', 'quantity': '1/2 c. à café', 'image': 'assets/sel.jpg'},
          {'name': 'Huile végétale', 'quantity': '1 c. à soupe', 'image': 'assets/huile.jpg'},
        ],
        'steps': [
          'Faire bouillir les chenilles pendant 20 mn et les essorer',
          'Laver et couper finement l\'oignon, râper la tomate et écraser l\'ail',
          'Dans une casserole au feu, faire revenir l\'oignon, ajouter la tomate rapée et laisser mijoter',
          'Ajouter les chenilles essorées, l\'ail et 1 L d\'eau et laisser bouillir 5mn',
          'Saler puis laisser mijoter pendant 10mn et servir'
        ]
      },

      'Gonré surprise': {
        'name': 'Gonré surprise',
        'image': 'assets/gonresur.png',
        'cookingTime': '1h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'haricot décortiqué', 'quantity': '500 g', 'image': 'assets/haricot.webp'},
          {'name': 'Feuilles de haricot', 'quantity': '2 poignées', 'image': 'assets/feuillesharicot.jpg'},
          {'name': 'Œuf bouilli', 'quantity': '4', 'image': 'assets/oeufbouilli.jpg'},
          {'name': 'Potasse', 'quantity': '', 'image': 'assets/potasse.webp'}
        ],
        'steps': [
          'Laver proprement le haricot décortiqué, ajouter les feuilles lavées et moudre finement le tout au moulin',
          'Potasser la pâte obtenue et bien mélanger',
          'La mettre dans de petits pots de yaourt et y insérer ¼ d’œuf bouilli par pot',
          'Cuire le contenu à la vapeur durant 30 minutes et servir',
          'NB : Ce met se consomme avec du sel et de l’huile ou peut s’accompagner d’une sauce tomate.'
        ]
      },

      'Gnoncon de riz': {
        'name': 'Gnoncon de riz',
        'image': 'assets/gnoncon.jpg',
        'cookingTime': '2h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Riz blanc', 'quantity': '1 Kg', 'image': 'assets/riz.webp'},
          {'name': 'Feuilles fraîches pilées de haricot', 'quantity': '0.75 Kg', 'image': 'assets/feuillesharicot.jpg'},
          {'name': 'Oignon cru', 'quantity': '2 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Poudre d\'arachide cru', 'quantity': '200 g', 'image': 'assets/farinearachide.webp'},
          {'name': 'Ail cru', 'quantity': '2 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Epices (fè fè, poivre noir)', 'quantity': '', 'image': 'assets/epices.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Râper les oignons, hacher l\'ail et le persil',
          'Laver et piler les feuilles de haricot',
          'Laver le riz et laisser reposer 25 à 30 minutes, puis le piler et tamiser',
          'Piler de nouveau les grains recueillis et tamiser une seconde fois',
          'Dans un récipient, mélanger les grains, la fine farine, les feuilles pilées et les légumes râpés/hachés pour avoir une pâte',
          'Saler, potasser la pâte et en faire des boules sans trop presser',
          'Cuire les boules pendant 40 à 45 minutes à la vapeur',
          'Servir accompagné d\'huile ou d\'une sauce tomate'
        ]
      },
      'Foutou igname': {
        'name': 'Foutou igname',
        'image': 'assets/foutou.jpg',
        'cookingTime': '1h30',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Igname cru', 'quantity': '1,5 Kg', 'image': 'assets/igname.jpeg'},
          {'name': 'Viande crue', 'quantity': '0,5 Kg', 'image': 'assets/viande.png'},
          {'name': 'Oignon cru', 'quantity': '1 bulbe', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '4', 'image': 'assets/tomate.webp'},
          {'name': 'Poivron frais', 'quantity': '1', 'image': 'assets/poivron.jpg'},
          {'name': 'Piment frais', 'quantity': '1', 'image': 'assets/piment.png'},
          {'name': 'Gombo frais', 'quantity': '6', 'image': 'assets/gombo.jpg'},
          {'name': 'Ail cru', 'quantity': '3 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Aubergine locale cru', 'quantity': '4', 'image': 'assets/koumba.jpeg'},
          {'name': 'Huile de palme', 'quantity': '20 cL', 'image': 'assets/huilepalme.png'},
          {'name': 'Épices (fè fè, poivre noir)', 'quantity': '', 'image': 'assets/epices.jpg'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'},
        ],
        'steps': [
          'Pour le foutou, Cuire à l\'eau simple l\'igname',
          'Dans un mortier, piler une petite quantité d\'igname cuit pour supprimer les probables odeurs d\'épices',
          'Remettre en quantité moyenne et piler en tournant de temps en temps la pâte',
          'Lorsque celle-ci devient collante, tremper par moment le bout du pilon dans de l\'eau pour faciliter l\'opération',
          'Poursuivre jusqu\'à obtenir une pate lisse, légère et bien collante',
          'En faire des boules et servir',
          'Pour la sauce, Cuire à l\'eau simple le gombo et l’aubergine locale et les écraser séparement',
          'Raper l\'oignon, la tomates, les poivrons et les faire revenir dans l\'huile de palme',
          'Ajouter 1 litre d\'eau et le gombo écrasé',
          'Mettre l\'aubergine écrasé dans un passoir fin, ajouter environ 1 litre d\'eau pour recueillir le jus et retenir les grains et la peau',
          'Ajouter le jus recueilli dans la casserole au feu, laisser mijoter puis saler, épicer et laisser cuire à feu doux pendant 10 minutes',
          'Servir accompagné du foutou'
        ]
      },

      'Poulet Bicyclette': {
        'name': 'Poulet Bicyclette',
        'image': 'assets/img.jpg',
        'cookingTime': '1h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Poulet entier', 'quantity': '1', 'image': 'assets/poulet.jpg'},
          {'name': 'Oignon cru', 'quantity': '1 bulbe', 'image': 'assets/oignon.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '1', 'image': 'assets/tomate.webp'},
          {'name': 'Poivron frais', 'quantity': '1', 'image': 'assets/poivron.jpg'},
          {'name': 'Concentré de tomate', 'quantity': '1 c. à soupe', 'image': 'assets/concentretomate.jpeg'},
          {'name': 'Sel iodé', 'quantity': '1 pincée', 'image': 'assets/sel.jpg'},
          {'name': 'Ail cru', 'quantity': '3 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Moutarde', 'quantity': '2 c. à café', 'image': 'assets/moutarde.webp'},
          {'name': 'Mayonaise', 'quantity': '2 c. à café', 'image': 'assets/mayonnaise.jpg'},
          {'name': 'Huile végétale', 'quantity': '1/8 litre', 'image': 'assets/huile.jpg'},
          {'name': 'Épices (fè fè, poivre noir)', 'quantity': '1 pincée', 'image': 'assets/epices.jpg'},
        ],
        'steps': [
          'Préparation de la vinaigrette : mélanger dans un récipient 1 c. à café de moutarde, 1 c. à café de mayonnaise, huile, concentrée de tomate, ail pilé, sel et épices',
          'Préparation de la salade : couper l\'oignon, le poivron, la tomate et les mélanger avec 1 c. à café de moutarde, 1 c. à café de mayonnaise et saler',
          'Laver le poulet, puis découper le long de la poitrine et l’étaler en un seul morceau. Le braiser en le badigeonnant avec la vinaigrette jusqu’à avoir la couleur dorée (40 a 45 mn)',
          'Le découper et servir en le barbouillant avec la salade'
        ]
      },

      'Sauce djodjo': {
        'name': 'Sauce djodjo',
        'image': 'assets/djodjo.webp',
        'cookingTime': '1h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'feuilles fraîches de courge', 'quantity': '600 g', 'image': 'assets/feuillescourge.jpg'},
          {'name': 'feuilles fraîches d\'oseille', 'quantity': '500 g', 'image': 'assets/oseille.jpeg'},
          {'name': 'Oignon cru', 'quantity': '3 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Eau', 'quantity': '750 ml', 'image': 'assets/eau.webp'},
          {'name': 'Beurre de karité', 'quantity': '350 g', 'image': 'assets/beurrekarite.jpg'},
          {'name': 'Aubergine locale fraîche', 'quantity': '850 g', 'image': 'assets/koumba.jpeg'},
          {'name': 'Poudre d\'arachide', 'quantity': '250 g', 'image': 'assets/farinearachide.webp'},
        ],
        'steps': [
          'Couper finement les feuilles de courge (après avoir pris soins d\'enlever les nervures) et d\'oseille, et couper en grands dés l\'aubergine locale',
          'Dans un litre d\'eau au feu, mettre successivement l\'aubergine, les feuilles de courge et les feuilles d\'oseille, sans mélanger et en observant 10 minutes d\'intervalle de temps entre les mises',
          'Laisser cuire 10 minutes les feuilles d\'oseilles et mélanger en ajoutant la poudre d\'arachide',
          'Laisser cuire encore 5 minutes puis ajouter l\'oignon finement coupé et le beurre de karité',
          'Mélanger et laisser mijoter 12 minutes à feu doux et servir',
          'NB : Cette sauce peut se consommer simplement ou accompagnée de tô'
        ]
      },

      'Riz au soumbala': {
        'name': 'Riz au soumbala',
        'image': 'assets/rizsoum.png',
        'cookingTime': '2h',
        'category': 'Plats principaux',
        'servings': 1,
        'ingredients': [
          {'name': 'Riz de Bagré', 'quantity': '900 g', 'image': 'assets/riz.webp'},
          {'name': 'Soumbala', 'quantity': '8 boules', 'image': 'assets/soumbala.jpg'},
          {'name': 'Poulet entier', 'quantity': '1', 'image': 'assets/poulet.jpg'},
          {'name': 'Oignon cru', 'quantity': '4 bulbes', 'image': 'assets/oignon.jpg'},
          {'name': 'Poivron cru', 'quantity': '4', 'image': 'assets/poivron.jpg'},
          {'name': 'Tomate fraîche', 'quantity': '4', 'image': 'assets/tomate.webp'},
          {'name': 'Ail cru', 'quantity': '1 bulbe', 'image': 'assets/ail.jpg'},
          {'name': 'Huile végétale', 'quantity': '1/2 litre', 'image': 'assets/huile.jpg'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Epices', 'quantity': '1 pincée', 'image': 'assets/epices.jpg'},
          {'name': 'Poisson séché', 'quantity': '40 g', 'image': 'assets/poissonsec.webp'},
          {'name': 'Pâte d\'arachide', 'quantity': '60 g', 'image': 'assets/patearachide.webp'},
          {'name': 'Eau', 'quantity': '1.8 litre', 'image': 'assets/eau.webp'},
          {'name': 'Sel iodé', 'quantity': '', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Laver le riz et le passer à la vapeur',
          'Couper l\'oignon, la tomate, le poivron et hacher l\'ail',
          'Laver et tremper le soumbala dans de l\'eau tiède',
          'Faire revenir l\'oignon, la tomate et le poivron dans ¼ de litre d\'huile, retirer le soumbala égrainé et ajouter un peu d\'eau de trempage et laisser mijoter',
          'Bouillir séparement le poulet et ajouter le bouillon à la cuisson et mettre le riz préalablement passé à la vapeur',
          'Retirer la chair du poulet, la hacher et malaxer avec la pâte d\'arachide. Faire des boulettes et les frire',
          'Laisser le riz cuire à feu doux puis servir'
        ]
      },

      // DESSERTS
      'Dèguè de pain de singe': {
        'name': 'Dèguè de pain de singe',
        'image': 'assets/degue.png',
        'cookingTime': '1h',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'Petit mil décortiqué', 'quantity': '500 g', 'image': 'assets/farinemil.jpg'},
          {'name': 'poudre de pain de singe', 'quantity': '200 g', 'image': 'assets/teedo.jpg'},
          {'name': 'Graines d\'arachide cru', 'quantity': '150 g', 'image': 'assets/arachide.jpg'},
          {'name': 'Sucre blond', 'quantity': '200 g', 'image': 'assets/sucreblond.jpg'}
        ],
        'steps': [
          'Piler le petit mil pour retirer le son : laver, décanter, essorer et de poser pendant 10 à 15 min',
          'Tamiser le mil pour éliminer les grains brisés (ces grains ne sont pas associés à la préparation)',
          'Porter à ébullition deux litres d\'eau dans une casserole et y renverser le mil. Fermer le couvert sur le côté pour éviter de faire de la bouillie. Laisser cuire 25 à 30 min',
          'Renverser dans un récipient, ajouter les tourteaux d\'arachide et bien mélanger à l\'aide d\'une spatule ou une louche tout en écrasant un peu',
          'Dans un autre récipient, mettre la poudre de pain de singe dans 2 à 3 litres d\'eau, mélanger pour obtenir un liquide homogène. Filtrer puis décanter',
          'Ajouter le liquide au mélange précédent (étape 4). Bien mélanger, mettre le sucre et égoutter'
        ]
      },
      'Gapal': {
        'name': 'Gapal',
        'image': 'assets/gapal.jpg',
        'cookingTime': '13h45',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'Grains de petit mil', 'quantity': '1 kg', 'image': 'assets/farinemil.jpg'},
          {'name': 'Lait en poudre', 'quantity': '500 g', 'image': 'assets/lait.jpg'},
          {'name': 'Sucre blond', 'quantity': '250 g', 'image': 'assets/sucreblond.jpg'},
          {'name': 'Sucre vanillé', 'quantity': '3 sachets', 'image': 'assets/sucrevanilé.jpg'},
          {'name': 'ferment (yaourt)', 'quantity': '1 petit pot', 'image': 'assets/yaourt.webp'}
        ],
        'steps': [
          'Mettre la poudre de lait dans 3 litres d’eau tiède et mélanger jusqu\'à obtenir un mélange homogène',
          'Ajouter le pot de yaourt, mélanger et attendre 13 heures',
          'Piller le petit mil et laver jusqu\'à  l\'élimination totale du son',
          'Mettre le petit mil dans l\'eau et attendre 30 minutes',
          'Piller le petit mil jusqu\'à obtenir une pâte',
          'Mettre la pâte de petit mil dans le yaourt bien fouetter ajouter le sucre et le sucre vanillé et fouetter le mélange, puis servir'
        ]
      },
      'Koura Koura': {
        'name': 'Koura Koura',
        'image': 'assets/koura.png',
        'cookingTime': '45 min',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'Arachide', 'quantity': '500 g', 'image': 'assets/arachide.jpg'},
          {'name': 'Sel iodé', 'quantity': '1 c. à café', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Griller les arachides pendant environ 10 minutes (à moitié cuit)',
          'Retirer la pellicule et les germes, et bien nettoyer',
          'Mélanger avec le lait caillé',
          'Ajouter 1 cuillerée à café de sel et moudre pour en faire de la pâte',
          'Dans une casserole portée sur feu doux, renverser la pâte obtenue',
          'Remuer régulièrement et extraire l\'huile au fur et à mesure',
          'Avec la pâte dégraissée, façonner de petites formes avec trois doigts et presser',
          'Dans une casserole au feu, préchauffer l\'huile recueillie et frire les formes jusqu\'à ce qu\'elles soient dorées et retirer',
          'Laisser refroidir avant de consommer'
        ]
      },
      'Sinsè (Samsa)': {
        'name': 'Sinsè (Samsa)',
        'image': 'assets/samsa.png',
        'cookingTime': '35 min',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'farine de Haricot', 'quantity': '1 Kg', 'image': 'assets/farineharicot.webp'},
          {'name': 'Beurre de karité ', 'quantity': '0.5 Kg', 'image': 'assets/beurrekarite.jpg'},
          {'name': 'Oignon cru', 'quantity': '1 bulbe', 'image': 'assets/oignon.jpg'},
          {'name': 'Ail cru', 'quantity': '6 gousses', 'image': 'assets/ail.jpg'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Eau', 'quantity': '1.5 litre', 'image': 'assets/eau.webp'},
        ],
        'steps': [
          'Dans un récipient, mélanger la farine avec 1 litre d\'eau. Battre avec une spatule pendant au moins 10 minutes',
          'Ajouter l\'oignon et l\'ail râpés et le persil haché',
          'Dans une poêle au feu, faire fondre le beurre de karité',
          'Diluer la pâte avec l\'eau restante pour avoir une consistance souhaitée',
          'A l\'aide d\'une louche, mettre la pâte en petites quantités dans la poêle pour frire',
          'Laisser cuire 2 minutes sur chaque face pour avoir une couleur dorée puis retirer et égoutter',
          'Servir simplement, avec une sauce tomate ou avec le Dounkoum'
        ]
      },
      'Croquettes d’igname': {
        'name': 'Croquettes d\'igname',
        'image': 'assets/sinse.png',
        'cookingTime': '1h',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'Tubercule d\'igname', 'quantity': '0.5 Kg', 'image': 'assets/igname.jpeg'},
          {'name': 'Poudre d\'igname cru', 'quantity': '250 g', 'image': 'assets/poudreigname.webp'},
          {'name': 'Œuf', 'quantity': '5', 'image': 'assets/oeuf.jpg'},
          {'name': 'Oignon cru', 'quantity': '1 bulbe', 'image': 'assets/oignon.jpg'},
          {'name': 'Persil frais', 'quantity': '1 touffe', 'image': 'assets/persil.jpg'},
          {'name': 'Huile', 'quantity': '0.5 litre', 'image': 'assets/huile.jpg'},
          {'name': 'Ail', 'quantity': '4 gousse', 'image': 'assets/ail.jpg'},
          {'name': 'Epices', 'quantity': '1 pincée', 'image': 'assets/epices.jpg'},
          {'name': 'Sel iodé', 'quantity': '30g', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Couper l\'igname, le laver et bouillir à l\'eau simple',
          'Hacher finement le persil, l\'oignon et l\'ail.',
          'Laisser tiédir l\'igname cuit et le raper',
          'Battre en neige les œufs avec le sel et les épices',
          'Malaxer ensemble œufs battus, igname râpé, poudre d\'igname, persil, oignon et ail hachés pour obtenir une pâte',
          'Frire cette pate en petites boules dans une poêle, laisser dorer et égoutter',
          'Servir simplement ou avec une sauce tomate'
        ]
      },
      'Gbel-gleb': {
        'name': 'Gbel-gleb',
        'image': 'assets/gbel.png',
        'cookingTime': '30 min',
        'category': 'Desserts',
        'servings': 1,
        'ingredients': [
          {'name': 'farine de haricot', 'quantity': '1 Kg', 'image': 'assets/farineharicot.webp'},
          {'name': 'Sel', 'quantity': '', 'image': 'assets/sel.jpg'}
        ],
        'steps': [
          'Dans un récipient, mélanger la farine de haricot avec un litre d\'eau, et battre avec une spatule pendant au moins 15 minutes',
          'Ajouter 0,5 litre d’eau pour avoir une pâte très légère',
          'Dans une poêle plate, fondre le beurre de karité et y frire la pâte en se servant d’une louche',
          'Laisser cuire une minute sur chaque face à feu doux. (On obtiendra de petites galettes plates et blanchâtres)',
          'NB: Ce plat se mange accompagné de salade dounkoum'
        ]
      },

      // BOISSONS
      'Dolo': {
        'name': 'Dolo',
        'image': 'assets/tchapalo.jpg',
        'cookingTime': '4-5 jours',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Sorgho rouge', 'quantity': '', 'image': 'assets/sorgho.png'},
          {'name': 'Eau', 'quantity': '', 'image': 'assets/eau.webp'}
        ],
        'steps': [
          'Tremper le sorgho rouge dans de l\'eau pendant une journée en prenant soin de séparer les grains de sable',
          'Etaler la céréale sur un sol recouvert de paille ou de plastique pendant 2 à 3 jours en prenant soin d\'humidifier les grains 2 fois par jour afin qu’ils germent',
          'La germination terminée, il faut maintenant sécher la céréale pendant une journée avant de la rendre en poudre',
          'Dans un canari, l’on verse la farine obtenue et on y ajoute de l’eau tout en prenant la peine de battre le tout à fin d’obtenir un mélange homogène',
          'On fait alors bouillir la solution durant 4 à 5 heures, la plupart du temps, cela se fait sur le foyer traditionnel de 3 pierres',
          'La première étape terminée, la farine déjà bouillie est filtrée à l’aide d’un panier traditionnel fait à base de liane. Le liquide obtenu après la filtration est encore mis au feu pendant 4 à 5 heures',
          'Enfin, on laisse le liquide tiédir durant une nuit afin qu’elle se fermente.La fermentation du tchapalo se fait tout seul au bout de quelques heures, mais si vous êtes impatient, vous pouvez y ajouter un peu de levure'
        ]
      },
      'Zoom koom': {
        'name': 'Zoom koom',
        'image': 'assets/zoomkoom.jpg',
        'cookingTime': '1h',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Petit mil', 'quantity': '1 Kg', 'image': 'assets/farinemil.jpg'},
          {'name': 'Riz local', 'quantity': '1/4 Kg', 'image': 'assets/riz.webp'},
          {'name': 'Tamarin', 'quantity': '250 g', 'image': 'assets/tamarins.jpg'},
          {'name': 'Gingembre', 'quantity': '50g', 'image': 'assets/gnamakou.jpg'},
          {'name': 'Menthe fraîche', 'quantity': '1 bouquet', 'image': 'assets/menthe.jpg'},
          {'name': 'Clou de girofle', 'quantity': '1 c. à soupe', 'image': 'assets/clougirofle.png'},
          {'name': 'Sucre blond', 'quantity': '0.5 Kg', 'image': 'assets/sucreblond.jpg'},
          {'name': 'Eau', 'quantity': '3 litres', 'image': 'assets/eau.webp'}
        ],
        'steps': [
          'Mouiller légèrement et piler et vanner le mil pour enlever un peu de son ( peau ).Laver le mil et le riz pour enlever tout le sable et les tremper dans de l’eau pendant 10minutes',
          'Pendant ce temps, enlever la peau du gingembre, laver la menthe. Égoutter les céréales y ajouter le gingembre + le clou de girofle + la menthe et mixer ou faire moudre au moulin',
          'Rincer le tamarin et le faire bouillir pendant 5minutes et le laisser refroidir',
          'Ajouter le tamarin et son jus + le reste de l’eau, bien mélanger et passer au chinois',
          'Ajouter le sucre bien mélanger et passer encore au chinois. Boire frais'
        ]
      },
      'Bissap': {
        'name': 'Bissap',
        'image': 'assets/bissap.jpg',
        'cookingTime': '45 min',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Fleurs d\'hibiscus', 'quantity': '100g', 'image': 'assets/dleurbissap.png'},
          {'name': 'Eau', 'quantity': '1.5L', 'image': 'assets/eau.webp'},
          {'name': 'Sucre', 'quantity': '150g', 'image': 'assets/sucreblanc.jpg'},
          {'name': 'Gingembre', 'quantity': '50g', 'image': 'assets/gnamakou.jpg'},
          {'name': 'Menthe fraîche', 'quantity': '15 feuilles', 'image': 'assets/menthe.jpg'},
        ],
        'steps': [
          'Dans une grande casserole, portez l’eau à ébullition',
          'Lavez bien et ajoutez les fleurs d’Hibiscus dans l’eau bouillante',
          'Réduisez le feu et laissez mijoter pendant 20 minutes',
          'Retirez du feu, laisser refroidir, puis filtrer',
          'Laissez frémir à feu doux pendant une dizaine de minutes',
          'Ajoutez le sucre, le gingembre, le jus de citron et la menthe',
          'Laissez le jus refroidir à température ambiante',
          'Placez-le au réfrigérateur pendant au moins 2 heures avant de servir pour qu’il soit bien frais',
          'Servir avec des glaçons'
        ]
      },
      'Gnamakou': {
        'name': 'Gnamakou',
        'image': 'assets/gnamakoudji.jpg',
        'cookingTime': '1h',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Gingembre frais', 'quantity': '500 g', 'image': 'assets/gnamakou.jpg'},
          {'name': 'Eau', 'quantity': '2 litres', 'image': 'assets/eau.webp'},
          {'name': 'Sucre', 'quantity': '500g', 'image': 'assets/sucreblanc.jpg'},
          {'name': 'Sucre vanillé', 'quantity': '1 sachet', 'image': 'assets/sucrevanilé.jpg'},
          {'name': 'Menthe fraîche', 'quantity': '10 feuilles', 'image': 'assets/menthe.jpg'},
          {'name': 'Citron', 'quantity': '1', 'image': 'assets/citron.jpg'},
        ],
        'steps': [
          'Épluchez le gingembre, coupez-le en morceaux grossiers et mettez-le au mixeur. Versez un filet d’eau et mixez l’ensemble jusqu’à obtenir une pâte de gingembre',
          'Mettez l’eau dans un récipient, un saladier par exemple. Ajoutez la pâte de gingembre et mélangez',
          'Coupez le citron en quartiers (avec la peau) et ajoutez-les au mélange eau et gingembre. Laissez macérer 30 min',
          'Filtrez le jus à l’aide d’un chinois. Ajoutez le sucre vanillé au jus de gingembre et versez le sucre progressivement, tout en goûtant, cela jusqu’à obtenir la saveur qui vous conviendra',
          'Ajoutez les feuilles de menthe et mettez à reposer au frais, c’est prêt ! Mélangez bien avant de servir, car le gingembre va reposer au fond de la boisson'
        ]
      },
      'Orchata': {
        'name': 'Orchata',
        'image': 'assets/jusorcha.jpg',
        'cookingTime': '3 jours',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'tchongon (souchet)', 'quantity': '0.5 Kg', 'image': 'assets/tchogo.jpg'},
          {'name': 'Eau', 'quantity': '1.5L', 'image': 'assets/eau.webp'},
          {'name': 'Coco', 'quantity': '1 gros', 'image': 'assets/coco.jpg'},
          {'name': 'Sucre vanillé', 'quantity': '2 sachets', 'image': 'assets/sucrevanilé.jpg'}
        ],
        'steps': [
          'Laver et tremper les graines de souchet sèches pendant 3jours en les lavant chaque jour avant de changer l’eau',
          'Le troisième jour bien les frotter les unes contres et les rincer',
          'Casser le coco et le découper',
          'Mettre le coco,souchet dans un blender,eau et bien mixer',
          'Ajouter le sucre vanillé et passer au chinois',
          'Se boit très frais et c’est doux avec le parfum du coco'
        ]
      },
      'Teedo au lait': {
        'name': 'Teedo au lait',
        'image': 'assets/teedolait.jpg',
        'cookingTime': '35 min',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Poudre de pain de singe', 'quantity': '1 verre', 'image': 'assets/teedo.jpg'},
          {'name': 'Poudre de lait de vache', 'quantity': '1/2 verre', 'image': 'assets/lait.jpg'},
          {'name': 'Eau', 'quantity': '1.5 litre', 'image': 'assets/eau.webp'},
          {'name': 'Sucre blanc', 'quantity': '100 g', 'image': 'assets/sucreblanc.jpg'}
        ],
        'steps': [
          'Dans un récipient, renverser la poudre de pain de singe (teedo) et le lait',
          'Ajouter l’eau et battre à l’aide d’un fouet (ne pas utiliser la main)',
          'Filtrer, sucrer à volonté et servir frais'
        ]
      },
      'Jus de tamarin': {
        'name': 'Jus de tamarin',
        'image': 'assets/justamarin.jpg',
        'cookingTime': '45 min',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'Tamarin', 'quantity': '200 g', 'image': 'assets/tamarins.jpg'},
          {'name': 'Eau tiède', 'quantity': '2 litres', 'image': 'assets/eau.webp'},
          {'name': 'Sucre', 'quantity': '', 'image': 'assets/sucreblanc.jpg'},
          {'name': 'Citron', 'quantity': '1', 'image': 'assets/citron.jpg'},
        ],
        'steps': [
          'Dans un saladier, verser l’eau tiède puis la pulpe de tamarin. Laisser tremper pendant 30 minutes environ',
          'Puis écraser la pulpe dans l’eau à l’aide des mains afin de bien extraire la pulpe',
          'Puis passer la préparation au tamis',
          'Ajouter le jus de citron vert et sucrer à convenance',
          'Réserver au frais jusqu’au moment de servir'
        ]
      },
      'Jus de sésame au miel': {
        'name': 'Jus de sésame au miel',
        'image': 'assets/jussesame.png',
        'cookingTime': '1h',
        'category': 'Boissons',
        'servings': 1,
        'ingredients': [
          {'name': 'grains de sésame', 'quantity': '0.5 Kg', 'image': 'assets/sésame.jpg'},
          {'name': 'Miel', 'quantity': '15 cl', 'image': 'assets/miel.jpg'},
          {'name': 'feuilles séchées de tamarin', 'quantity': '100 g', 'image': 'assets/feuillestamarin.webp'},
          {'name': 'Eau', 'quantity': '2 litres', 'image': 'assets/eau.webp'}
        ],
        'steps': [
          'Laver, épierrer, sécher et écraser finement le sésame',
          'Bouillir les feuilles de tamarin, essorer et garder 1 litre de jus',
          'Dans un récipient, malaxer la farine de sésame avec un peu d’eau jusqu’à obtenir une pâte collante',
          'Délayer la pâte avec un litre d’eau et ajouter le litre de l’effusion de tamarin',
          'Ajouter le miel, et passer le tout à travers un tissu fin. Servir frais'
        ]
      },
    };
  }
}

class ModernRecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const ModernRecipeCard({super.key, required this.recipe});

  @override
  State<ModernRecipeCard> createState() => _ModernRecipeCardState();
}

class _ModernRecipeCardState extends State<ModernRecipeCard> {
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

  String get _recipeId => widget.recipe['id']?.toString() ?? widget.recipe['name'];

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = _favoritesManager.isFavorite(_recipeId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _settings.primaryColor.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 1.1,
                      child: Image.asset(
                        widget.recipe['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Bouton Favoris
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        final wasAlreadyFavorite = _favoritesManager.isFavorite(_recipeId);

                        await _favoritesManager.toggleFavorite(_recipeId);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                wasAlreadyFavorite
                                    ? 'Retiré des favoris'
                                    : 'Ajouté aux favoris',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: isDark ? Colors.grey[700] : Colors.black87,
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[700] : Colors.white70,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? _settings.primaryColor : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: _settings.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.recipe['cookingTime'],
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;

  const CategoryDetailPage({super.key, required this.categoryName});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allRecipes = RecipeData.getRecipeDetails();

    List<Map<String, dynamic>> recipes = allRecipes.values
        .where((recipe) => recipe['category'] == widget.categoryName)
        .toList();

    return Scaffold(
      backgroundColor: _settings.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.categoryName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _settings.primaryColor,
            ),
          ),
        ),
        backgroundColor: _settings.getBackgroundColor(isDark),
        elevation: 0,
        iconTheme: IconThemeData(color: _settings.primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 9),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 0.76,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(
                      recipe: recipes[index],
                    ),
                  ),
                );
              },
              child: ModernRecipeCard(recipe: recipes[index]),
            );
          },
        ),
      ),
    );
  }
}

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  final AppSettings _settings = AppSettings();
  late int servings;
  int _currentTab = 0;

  final ScrollController _ingredientsScrollController = ScrollController();
  final ScrollController _stepsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    servings = widget.recipe['servings'] ?? 1;
    _favoritesManager.addListener(_onFavoritesChanged);
    _settings.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _settings.removeListener(_onSettingsChanged);
    _ingredientsScrollController.dispose();
    _stepsScrollController.dispose();
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

  String get _recipeId => widget.recipe['id']?.toString() ?? widget.recipe['name'];

  String _calculateQuantity(String originalQuantity, int originalServings, int newServings) {
    if (originalQuantity.contains(RegExp(r'\d'))) {
      final regex = RegExp(r'(\d+(?:\.\d+)?)');
      final match = regex.firstMatch(originalQuantity);
      if (match != null) {
        final number = double.parse(match.group(1)!);
        final newNumber = (number * newServings / originalServings);
        return originalQuantity.replaceFirst(match.group(1)!, newNumber.toStringAsFixed(newNumber % 1 == 0 ? 0 : 1));
      }
    }
    return originalQuantity;
  }

  @override
  Widget build(BuildContext context) {
    final originalServings = widget.recipe['servings'] ?? 1;
    final bool isFavorite = _favoritesManager.isFavorite(_recipeId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _settings.getBackgroundColor(isDark),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              widget.recipe['image'],
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: _settings.primaryColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: _settings.primaryColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () async {
                        final wasAlreadyFavorite = _favoritesManager.isFavorite(_recipeId);

                        await _favoritesManager.toggleFavorite(_recipeId);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                wasAlreadyFavorite
                                    ? 'Retiré des favoris'
                                    : 'Ajouté aux favoris',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: isDark ? Colors.grey[700] : Colors.black87,
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _settings.primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.recipe['category'] ?? 'Plat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: (MediaQuery.of(context).size.height * 0.4) - 24,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: _settings.getBackgroundColor(isDark),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.recipe['name'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _settings.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _settings.primaryColor.withOpacity(0.3), width: 2),
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: _settings.primaryColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.recipe['cookingTime'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: isDark ? Colors.grey[300] : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        'Quantité',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _settings.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (servings > 1) {
                            setState(() {
                              servings--;
                            });
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[600] : Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.remove, size: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '$servings',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            servings++;
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _settings.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _buildTabButton(0, 'Ingrédients'),
                      const SizedBox(width: 20),
                      _buildTabButton(1, 'Étapes'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: IndexedStack(
                      index: _currentTab,
                      children: [
                        _buildIngredientsTab(originalServings),
                        _buildStepsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    bool isActive = _currentTab == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? _settings.primaryColor : (isDark ? Colors.grey[600] : Colors.black54),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsTab(int originalServings) {
    final ingredients = widget.recipe['ingredients'] as List<Map<String, dynamic>>? ?? [];

    return Container(
      key: const ValueKey('ingredients_tab'),
      child: SingleChildScrollView(
        controller: _ingredientsScrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: ingredients.map((ingredient) {
            final adjustedQuantity = _calculateQuantity(
                ingredient['quantity'],
                originalServings,
                servings
            );

            return _buildIngredientItem(
              ingredient['image'] ?? 'assets/img2.png',
              ingredient['name'],
              adjustedQuantity,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStepsTab() {
    final steps = widget.recipe['steps'] as List<String>? ?? [];

    return Container(
      key: const ValueKey('steps_tab'),
      child: SingleChildScrollView(
        controller: _stepsScrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: steps.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _settings.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      step,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildIngredientItem(String image, String name, String quantity) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.restaurant,
                    color: _settings.primaryColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            quantity,
            style: TextStyle(
              color: _settings.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  static const String _favoritesKey = 'favorite_recipes';

  final Set<String> _favoriteRecipeIds = <String>{};
  bool _isInitialized = false;

  Set<String> get favoriteRecipeIds => Set.unmodifiable(_favoriteRecipeIds);
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_favoritesKey) ?? [];

    _favoriteRecipeIds.clear();
    _favoriteRecipeIds.addAll(favoritesList);

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteRecipeIds.toList());
  }

  bool isFavorite(String recipeId) {
    return _favoriteRecipeIds.contains(recipeId);
  }

  Future<void> toggleFavorite(String recipeId) async {
    if (_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.remove(recipeId);
    } else {
      _favoriteRecipeIds.add(recipeId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> addToFavorites(String recipeId) async {
    if (!_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.add(recipeId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String recipeId) async {
    if (_favoriteRecipeIds.contains(recipeId)) {
      _favoriteRecipeIds.remove(recipeId);
      await _saveFavorites();
      notifyListeners();
    }
  }

  int get favoritesCount => _favoriteRecipeIds.length;

  Future<void> clearFavorites() async {
    _favoriteRecipeIds.clear();
    await _saveFavorites();
    notifyListeners();
  }
}