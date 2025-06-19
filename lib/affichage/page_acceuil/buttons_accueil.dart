import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../page_echecs/page_intermediaire_echecs.dart';
import '../page_dames/page_dame.dart';
import '../page_morpion/page_morpion.dart';

// ______________________________________________________________________________________________________________________________________________________
// Configs buttonGoToPage
// ______________________________________________________________________________________________________________________________________________________
class ButtonConfig {
  final String title;
  final String imageAsset;
  final Widget page;

  const ButtonConfig({
    required this.title,
    required this.imageAsset,
    required this.page,
  });
}

// Définition des configurations des boutons sous forme de liste ou Map global
final List<ButtonConfig> buttonConfigs = [
  ButtonConfig(
    title: 'Echecs',
    imageAsset: 'assets/affichage/acceuil_button_echecs.jpg',
    //page: PageIntermediaireEchecs(),
    page: PageIntermediaireEchecs(),
  ),
  ButtonConfig(
    title: 'Dames',
    imageAsset: 'assets/affichage/acceuil_button_dames.png',
    page: PageDames(),
  ),
  ButtonConfig(
    title: 'Morpion',
    imageAsset: 'assets/affichage/acceuil_button_morpion.jpg',
    page: PageMorpion(), // @TODO modifier la page
  ),
];

// ______________________________________________________________________________________________________________________________________________________
// buttonGoToPage
// ______________________________________________________________________________________________________________________________________________________
Widget buttonGoToPage(
    BuildContext context, double width, double height, int indiceConfig) {
  // On va chercher la config
  final config = buttonConfigs[indiceConfig];

  // Action
  return GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => config.page),
    ),

    // Image
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(config.imageAsset), // L'image de fond
          fit: BoxFit.cover, // Adapter l'image sans déformation
        ),
        borderRadius:
            BorderRadius.circular(12), // Coins arrondis pour le bouton
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: .5), // Couleur de l'ombre avec opacité
            blurRadius: 10, // Flou de l'ombre
            offset: Offset(4, 4), // Décalage de l'ombre
          ),
        ],
      ),

      // Text
      child: Center(
        child: Text(
          config.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0))
            ],
          ),
        ),
      ),
    ),
  );
}

// ______________________________________________________________________________________________________________________________________________________
// buttonQuit
// ______________________________________________________________________________________________________________________________________________________
Widget buttonQuit(BuildContext context, double width, double height) {
  return ElevatedButton(
    onPressed: () {
      // Quitter l'application en utilisant SystemNavigator.pop()
      SystemNavigator.pop(); // Ferme l'application
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(width, height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.red,
      elevation: 10,
    ),
    child: Text(
      "Quitter",
      style: TextStyle(
        color: Colors.white, // Texte en blanc
        fontSize: 16,
      ),
    ),
  );
}

// ______________________________________________________________________________________________________________________________________________________
// buttonCredits
// ______________________________________________________________________________________________________________________________________________________
void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Projet de Développement Mobile'),
        content: Text(
          'Dan DEPREDURAND : Frontend, Morpion\nAlphonse KERBELLEC : Dames\nThomas MANCHE : Echecs principal\nGauvain LEPITRE : Echecs compléments',
        ),
      );
    },
  );
}

Widget customButton(BuildContext context, double width, double height) {
  return ElevatedButton(
    onPressed: () {
      showCustomDialog(context); // Affiche la popup quand le bouton est pressé
    },
    style: ElevatedButton.styleFrom(
      minimumSize: Size(width, height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.green,
      elevation: 10,
    ),
    child: Text(
      "Crédits",
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
