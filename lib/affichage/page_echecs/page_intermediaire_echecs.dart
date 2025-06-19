import 'package:flutter/material.dart';
import 'widgets_page_intermediaire_echecs.dart';

class PageIntermediaireEchecs extends StatefulWidget {
  @override
  State<PageIntermediaireEchecs> createState() =>
      _PageIntermediaireEchecsState();
}

class _PageIntermediaireEchecsState extends State<PageIntermediaireEchecs> {
  final TextEditingController _namePlayer1 = TextEditingController();
  final TextEditingController _namePlayer2 = TextEditingController();
  int _minutes = 10; // Valeur par défaut pour le timer
  @override
  Widget build(BuildContext context) {
    // Récupérer les dimensions de l'écran
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        // Image
        flexibleSpace: Image.asset(
          'assets/affichage/LelouchChess.png',
          fit: BoxFit.cover,
        ),
        // Titre
        title: const Text(
          "Options",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 5,
                color: Colors.black,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Passer la largeur de l'écran (80% de la largeur)
            ChampJoueur(
                controller: _namePlayer1,
                label: 'Joueur 1',
                width: screenWidth * 0.9,
                height: screenHeight * 0.1),
            const SizedBox(height: 16),
            ChampJoueur(
                controller: _namePlayer2,
                label: 'Joueur 2',
                width: screenWidth * 0.9,
                height: screenHeight * 0.1),
            const SizedBox(height: 16),
            TimerWidget(onMinutesChanged: (value) {
              setState(() {
                _minutes = value; // Mettre à jour la valeur des minutes
              }); // Mettre à jour la valeur des minutes
            }),
            const SizedBox(height: 16),
            ButtonValider(context, _namePlayer1, _namePlayer2, _minutes),
          ],
        ),
      ),
    );
  }
}
