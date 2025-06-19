import 'package:flutter/material.dart';
import 'buttons_accueil.dart'; // Importez la fonction pour créer le bouton

class PageAcceuil extends StatelessWidget {
  const PageAcceuil({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Organisation de l'écran
    return Scaffold(
      // Barre du haut
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            screenHeight * 0.1), // Taille personnalisée de l'AppBar
        child: AppBar(
          backgroundColor: Colors
              .transparent, // Rendre le fond transparent pour appliquer un dégradé
          // Titre
          title: const Text(
            'Sélectionnez un Jeu',
            style: TextStyle(
              color: Colors.white,
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
                  Colors.blue,
                  Colors.purple
                ], // Dégradé de bleu à violet
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),

      // Centre
      body: Container(
        color: const Color.fromARGB(255, 245, 245, 221),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buttonGoToPage(
                  context, screenWidth * 0.8, screenHeight * 0.19, 0),
              SizedBox(
                  height: screenHeight * 0.04), // Espacement entre les boutons
              buttonGoToPage(
                  context, screenWidth * 0.8, screenHeight * 0.19, 1),
              SizedBox(
                  height: screenHeight * 0.04), // Espacement entre les boutons
              buttonGoToPage(context, screenWidth * 0.8, screenHeight * 0.19, 2)
            ],
          ),
        ),
      ),

      // Barre du bas
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 50, 71, 208),
        child: SizedBox(
          height: screenHeight * 0.15, // Hauteur de la BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              customButton(context, screenWidth * 0.4, screenHeight * 0.1),
              buttonQuit(context, screenWidth * 0.4, screenHeight * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
