//import 'package:dev_mobile_projet/affichage/page_acceuil/buttons_accueil.dart';
import '../../damegame/PlateauDames.dart';
import 'package:flutter/material.dart';
import 'AffichageDame.dart';
import '../page_acceuil/page_acceuil.dart';

class PageDames extends StatefulWidget {
  const PageDames({super.key});

  @override
  _PageDamesState createState() => _PageDamesState();
}

// ______________________________________________________________________________________________________________________________________________________
// Configs buttonGoToPage
// ______________________________________________________________________________________________________________________________________________________
class ThemeColor {
  final Color couleurTitre;
  final Color couleurDegradeGauche;
  final Color couleurDegradeDroite;
  final Color couleurMenuBarre;
  final Color couleurMenuFond;

  const ThemeColor({
    required this.couleurTitre,
    required this.couleurDegradeGauche,
    required this.couleurDegradeDroite,
    required this.couleurMenuBarre,
    required this.couleurMenuFond,
  });
}

// Les différents thèmes possibles identifiés par leur indice dans la liste
final List<ThemeColor> differentsThemes = [
  // Thème par défaut
  ThemeColor(
    couleurTitre: Colors.white,
    couleurDegradeGauche: Colors.blue,
    couleurDegradeDroite: Colors.purple,
    couleurMenuBarre: Colors.purple,
    couleurMenuFond: const Color.fromARGB(255, 245, 245, 221),
  ),
  // Thème Pastel
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color(0xFFFFC0CB),
    couleurDegradeDroite: Color(0xFFB0E0E6),
    couleurMenuBarre: Color(0xFF9370DB),
    couleurMenuFond: const Color.fromARGB(255, 255, 239, 226),
  ),
  // Thème Couché de soleil
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color(0xFFFF4081),
    couleurDegradeDroite: Color(0xFFFFC107),
    couleurMenuBarre: Color.fromARGB(255, 255, 152, 7),
    couleurMenuFond: const Color.fromARGB(255, 255, 240, 245),
  ),
  // Thème Lime
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color(0xFFCDDC39),
    couleurDegradeDroite: Color(0xFF8BC34A),
    couleurMenuBarre: Color(0xFF7CB342),
    couleurMenuFond: const Color.fromARGB(255, 230, 240, 230),
  ),
  // Thème Mer Calme
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color(0xFF0288D1),
    couleurDegradeDroite: Color(0xFF4CAF50),
    couleurMenuBarre: Color(0xFF1E88E5),
    couleurMenuFond: const Color.fromARGB(255, 240, 250, 255),
  ),
  // Thème Crépuscule
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color.fromARGB(255, 217, 0, 255),
    couleurDegradeDroite: Color.fromARGB(255, 83, 58, 126),
    couleurMenuBarre: Color(0xFF512DA8),
    couleurMenuFond: const Color.fromARGB(255, 240, 230, 255),
  ),
  // Thème Rouge et Orange
  ThemeColor(
    couleurTitre: const Color.fromARGB(255, 255, 255, 255),
    couleurDegradeGauche: Color.fromARGB(255, 255, 136, 0), // Rouge vif
    couleurDegradeDroite: Color.fromARGB(255, 255, 0, 0), // Orange vif
    couleurMenuBarre: Color.fromARGB(255, 255, 0, 0),
    couleurMenuFond: const Color.fromARGB(255, 255, 240, 230),
  ),
];

class _PageDamesState extends State<PageDames> {
  // Dans la classe car interactif
  ThemeColor currentTheme = differentsThemes[0];
  late PlateauDames plateau;

  @override
  void initState() {
    super.initState();
    plateau = PlateauDames();
  }

  void changeColors(List<Color> color) {
    setState(() {
      plateau.colCase[0] = color[0];
      plateau.colCase[1] = color[1];
    });
  }

  // ______________________________________________________________________________________________________________________________________________________
  // Pop up, dans le widget car interractive - GESTION DE LA COULEUR DU THEME
  // ______________________________________________________________________________________________________________________________________________________
  Widget optionCouleur(String nom, int index) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() {
          currentTheme = differentsThemes[index];
        });
      },
      child: Container(
        // Appliquer le fond avec un dégradé
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              differentsThemes[index].couleurDegradeGauche,
              differentsThemes[index].couleurDegradeDroite,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Text(
          nom,
          style: TextStyle(
            fontSize: 18,
            color: differentsThemes[index].couleurTitre,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 4.0,
                  color: Colors.black,
                  offset: Offset(1.0, 1.0))
            ],
          ),
        ),
      ),
    );
  }

  void showColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Choisissez un thème'),
          children: <Widget>[
            optionCouleur("Thème par défaut", 0),
            optionCouleur("Thème 1", 1),
            optionCouleur("Thème 2", 2),
            optionCouleur("Thème 3", 3),
            optionCouleur("Thème 4", 4),
            optionCouleur("Thème 5", 5),
            optionCouleur("Thème 6", 6),
          ],
        );
      },
    );
  }

  // ______________________________________________________________________________________________________________________________________________________
  // Organisation de la page
  // ______________________________________________________________________________________________________________________________________________________
  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Barre du haut
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            screenHeight * 0.1), // Taille personnalisée de l'AppBar
        child: AppBar(
          backgroundColor: Colors
              .transparent, // Rendre le fond transparent pour appliquer un dégradé
          // Titre
          title: Text(
            'Damn',
            style: TextStyle(
              color: currentTheme.couleurTitre,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    blurRadius: 5.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0))
              ],
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  currentTheme.couleurDegradeGauche,
                  currentTheme.couleurDegradeDroite
                ], // Dégradé de bleu à violet
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),

      // Body
      body: AffichageDame(plateau: plateau),

      // Barre latérale (Drawer) à droite
      endDrawer: Drawer(
        width: screenWidth * .5, // Largeur
        child: ListView(
          padding: EdgeInsets.zero, // Retirer le padding par défaut
          children: <Widget>[
            // Header du Drawer
            Container(
              height: (screenHeight * 0.1),
              color: currentTheme.couleurMenuBarre,
              child: Center(
                child: Text(
                  'Options',
                  style: TextStyle(
                    color: currentTheme.couleurTitre,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ______________________________________________________________________________________________________________________________________________________
            // Liste des options dans la barre latérale
            // ______________________________________________________________________________________________________________________________________________________
            ListTile(
              title: const Text('Réinitialiser'),
              onTap: () {
                setState(() {
                  plateau.Reinitialisation();
                });
              },
            ),
            ListTile(
              title: const Text('🔥Hardcore💣'),
              onTap: () {
                setState(() {
                  plateau.showMoves = !plateau.showMoves;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ListTile(
              title: const Text('Accueil'),
              onTap: () {
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PageAcceuil()),
                  );
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            ListTile(
              title: const Text('Changer de skin'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Valider'),
                        ),
                      ],
                      title: Text('Choisissez un skin'),
                      content: SizedBox(
                        width: screenWidth *
                            0.5, // Largeur de la boîte de dialogue
                        height: screenHeight *
                            0.3, // Hauteur de la boîte de dialogue
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Skin de plateau'),
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.colCase[0] = Colors.white;
                                        plateau.colCase[1] = Colors.lightBlue;
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/color_plat/White_Blue.png",
                                        width: 150),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.colCase[0] =
                                            Colors.brown.shade400;
                                        plateau.colCase[1] =
                                            Colors.brown.shade700;
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/color_plat/Brow_shade.png",
                                        width: 150),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.colCase[0] =
                                            Colors.grey.shade200;
                                        plateau.colCase[1] =
                                            Colors.grey.shade500;
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/color_plat/Grey_shade.png",
                                        width: 150),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.colCase[0] =
                                            Colors.deepPurple.shade500;
                                        plateau.colCase[1] =
                                            Colors.purple.shade200;
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/color_plat/Purple_shade.png",
                                        width: 150),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Changer les couleurs'),
              onTap: () {
                showColorDialog();
                //Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
