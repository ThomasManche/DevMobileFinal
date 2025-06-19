//import 'package:dev_mobile_projet/affichage/page_acceuil/buttons_accueil.dart';
import '../../chessgame/Plateau.dart';
import '../../chessgame/log.dart';
import 'package:flutter/material.dart';
import 'AffichageEchec.dart';
import '../page_acceuil/page_acceuil.dart';
import '../../timer.dart';

class PageEchecs extends StatefulWidget {
  // Variables
  final int minutes;
  final TextEditingController namePlayer1;
  final TextEditingController namePlayer2;
  const PageEchecs(
      {super.key,
      required this.minutes,
      required this.namePlayer1,
      required this.namePlayer2});

  @override
  _PageEchecsState createState() => _PageEchecsState();
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

class _PageEchecsState extends State<PageEchecs> {
  // Dans la classe car interactif
  ThemeColor currentTheme = differentsThemes[0];
  late Plateau plateau;
  late Log database;
  late TimerManager timerB;
  late TimerManager timerN;
  late int minutes;

  @override
  void initState() {
    super.initState();
    database = Log(
        piece: 'null',
        x: 0,
        y: 0,
        newX: 0,
        newY: 0,
        pieceCapturee: 0,
        pieceCaptureePiece: 'null',
        couleur: 'null',
        timerB: 0,
        timerN: 0,
        turn: 'null');
    database.resetDatabase();
    database.main();
    timerB = TimerManager(widget.minutes, 0, "blanc");
    timerN = TimerManager(widget.minutes, 0, "noir");
    minutes = widget.minutes;
    plateau = Plateau(timerB, timerN, minutes);
  }

  void changeColors(List<Color> color) {
    setState(() {
      plateau.colCase[0] = color[0];
      plateau.colCase[1] = color[1];
    });
  }

  void popUp1Abandon(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer la pop-up en cliquant à côté
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pop-up'),
          content: Text(
              "${plateau.tourActuel}, êtes-vous sur de vouloir abandonner ?"), // Affiche le texte passé en paramètre
          actions: <Widget>[
            // Row pour aligner les boutons à gauche et à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: const Text('Oui'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le pop-up
                    popUp2Abandon(context);
                  },
                ),
                // Bouton "Rejouer" : ferme le pop-up et réinitialise le jeu
                TextButton(
                  child: const Text('Non'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le pop-up
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void popUp2Abandon(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer la pop-up en cliquant à côté
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Victoire par abandon'),
          content: Text(
              "Bravo ${plateau.tourActuel == "Blanc" ? "Noir" : "Blanc"}, vous avez gagné la partie car le joueur ${plateau.tourActuel} a abandonné !"), // Affiche le texte passé en paramètre
          actions: <Widget>[
            // Row pour aligner les boutons à gauche et à droite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Bouton "Quitter" : retour à la page précédente
                TextButton(
                  child: const Text('Quitter'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le pop-up
                    Navigator.of(context)
                        .pop(); // Retourne à la page précédente
                  },
                ),
                // Bouton "Rejouer" : ferme le pop-up et réinitialise le jeu
                TextButton(
                  child: const Text('Rejouer'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le pop-up
                    setState(() {
                      plateau.Reinitialisation(); // Réinitialise le jeu
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void chargerPartie() async{
    await plateau.chargerPartie(database);
    setState(() {
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
    ).then((_) {
      // Redémarre le timer du joueur courant si le showDialog est fermé
      if (plateau.tourActuel == "Blanc") {
        timerB.start();
      } else {
        timerN.start();
      }
    });
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
            'Echecs',
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
      body: AffichageEchec(
        plateau: plateau,
        database: database,
        namePlayer1: widget.namePlayer1,
        namePlayer2: widget.namePlayer2, // Passer le thème actuel
      ),

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
              title: const Text('Abandon du joueur actuel'),
              onTap: () {
                setState(() {
                  popUp1Abandon(context);
                });
              },
            ),

            ListTile(
              title: const Text('Charger'),
              onTap: () {
                chargerPartie();
              },
            ),
            ListTile(
              title: const Text('Sauvegarder'),
              onTap: () {
                setState(() {
                  plateau.sauvergarderPartie(database);
                });
              },
            ),
            ListTile(
              title: const Text('Réinitialiser'),
              onTap: () {
                setState(() {
                  plateau.Reinitialisation();
                  database.resetDatabase();
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            ListTile(
              title: const Text('Accueil'),
              onTap: () {
                if (plateau.tourActuel == "Blanc") {
                  timerB.stop();
                } else {
                  timerN.stop();
                }
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PageAcceuil()),
                  );
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            ListTile(
              title: const Text('Changer de skin'),
              onTap: () {
                if (plateau.tourActuel == "Blanc") {
                  timerB.stop();
                } else {
                  timerN.stop();
                }
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
                            Text('Skin de pions'),
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.setPieceSkin(
                                            "assets/normal_chess/");
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/normal_chess/white-pawn.png",
                                        width: 100),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.setPieceSkin(
                                            "assets/pixel_chess/");
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/pixel_chess/white-pawn.png",
                                        width: 100),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.setPieceSkin(
                                            "assets/color_chess/");
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/color_chess/white-pawn.png",
                                        width: 100),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        plateau.setPieceSkin(
                                            "assets/troll_chess/");
                                      });
                                    },
                                    child: Image.asset(
                                        "assets/troll_chess/white-pawn.png",
                                        width: 100),
                                  ),
                                ],
                              ),
                            ),
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
                ).then((_) {
                  // Redémarre le timer du joueur courant si le showDialog est fermé autrement que par "Valider"
                  if (plateau.tourActuel == "Blanc") {
                    timerB.start();
                  } else {
                    timerN.start();
                  }
                });
              },
            ),
            ListTile(
              title: const Text('Changer les couleurs'),
              onTap: () {
                if (plateau.tourActuel == "Blanc") {
                  timerB.stop();
                } else {
                  timerN.stop();
                }
                showColorDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}
