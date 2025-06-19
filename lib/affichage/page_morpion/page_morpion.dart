import 'package:flutter/material.dart';

class PageMorpion extends StatefulWidget {
  const PageMorpion({super.key});

  @override
  _PageMorpionState createState() => _PageMorpionState();
}

// ______________________________________________________________________________________________________________________________________________________
// Définition des thèmes
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

class _PageMorpionState extends State<PageMorpion> {
  ThemeColor currentTheme = differentsThemes[0];
  List<String> t = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
  int tour = 0;

  // ______________________________________________________________________________________________________________________________________________________
  // Pop ups
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

  void lancePopUp(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche de fermer la pop-up en cliquant à côté
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pop-up'),
          content: Text(message), // Affiche le texte passé en paramètre
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
                    initialisationVariables(); // Réinitialise le jeu
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // ______________________________________________________________________________________________________________________________________________________
  // Fonctions du Morpion
  // ______________________________________________________________________________________________________________________________________________________
  void initialisationVariables() {
    setState(() {
      t = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
      tour = 0;
    });
  }

  void onButtonPressed(int i) {
    setState(() {
      if (t[i] == ' ') {
        if (tour % 2 == 0) {
          t[i] = 'X';
        } else {
          t[i] = 'O';
        }
        tour++;
      }

      // Vérifier la victoire
      if (((t[0] != ' ') && (t[0] == t[1]) && (t[1] == t[2])) ||
          ((t[3] != ' ') && (t[3] == t[4]) && (t[4] == t[5])) ||
          ((t[6] != ' ') && (t[6] == t[7]) && (t[7] == t[8])) ||
          ((t[0] != ' ') && (t[0] == t[3]) && (t[3] == t[6])) ||
          ((t[1] != ' ') && (t[1] == t[4]) && (t[4] == t[7])) ||
          ((t[2] != ' ') && (t[2] == t[5]) && (t[5] == t[8])) ||
          ((t[0] != ' ') && (t[0] == t[4]) && (t[4] == t[8])) ||
          ((t[2] != ' ') && (t[2] == t[4]) && (t[4] == t[6]))) {
        if (tour % 2 == 0) {
          lancePopUp(context, "Partie gagnée par O");
        } else {
          lancePopUp(context, "Partie gagnée par X");
        }
      }

      // Vérifier la partie nulle
      if (tour == 9) {
        lancePopUp(context, "Partie nulle");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialisationVariables();
  }

  // ______________________________________________________________________________________________________________________________________________________
  // Organisation de la Page
  // ______________________________________________________________________________________________________________________________________________________
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Morpion',
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
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showColorDialog();
              },
            ),
          ],
        ),
      ),

      // ______________________________________________________________________________________________________________________________________________________
      // Grille de Morpion
      // ______________________________________________________________________________________________________________________________________________________
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              Color buttonColor;
              Color textColor;

              // Définir les couleurs en fonction de l'état de la case
              if (t[index] == ' ') {
                buttonColor = currentTheme.couleurMenuFond;
                textColor = currentTheme.couleurMenuFond;
              } else if (t[index] == 'X') {
                buttonColor = currentTheme.couleurDegradeDroite;
                textColor = currentTheme.couleurDegradeGauche;
              } else {
                // t[index] == 'O'
                buttonColor = currentTheme.couleurDegradeGauche;
                textColor = currentTheme.couleurDegradeDroite;
              }

              return ElevatedButton(
                onPressed: () {
                  onButtonPressed(index);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: Text(
                  t[index],
                  style: TextStyle(fontSize: 32, color: textColor),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
