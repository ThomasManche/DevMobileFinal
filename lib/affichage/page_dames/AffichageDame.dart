import '../../damegame/DameDames.dart';
import '../../damegame/PlateauDames.dart';

import 'package:flutter/material.dart';

class AffichageDame extends StatefulWidget {
  final PlateauDames plateau;
  const AffichageDame({super.key, required this.plateau});

  @override
  _AffichageDameWidgetState createState() => _AffichageDameWidgetState();
}

class _AffichageDameWidgetState extends State<AffichageDame> {
  late PlateauDames plateau;
  String gameStatus = '';
  bool isCaptureMove = false;
  @override
  void initState() {
    super.initState();
    plateau = widget.plateau;
  }

  void deplacerPiece(int newX, int newY) {
    setState(() {
      if (plateau.selectedPiece != null &&
          plateau.selectedPiece!.couleur == plateau.tourActuel) {
        try {
          List<int> nouvellesCaptures =
              plateau.selectedPiece!.deplacement(newX, newY, plateau);
          if (nouvellesCaptures.isEmpty) {
            // Alterner le tour si aucune autre capture n'est possible
            plateau.alternerTour();
            plateau.selectedPiece = null;
            isCaptureMove = false;
            plateau.possibleMoves =
                []; // Réinitialiser les déplacements possibles
          } else {
            // Mettre à jour les déplacements possibles pour permettre une autre capture
            plateau.possibleMoves = nouvellesCaptures;
            isCaptureMove = true;
          }

          // Vérifier si la partie est terminée
          if (plateau.estFini()) {
            showGameOverDialog(context);
          }
        } catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    });
  }

  void showGameOverDialog(BuildContext context) {
    String winner = plateau.tourActuel == "Blanc" ? "Noir" : "Blanc";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Partie terminée !'),
          content: Text('Le joueur $winner a gagné !'),
          actions: <Widget>[
            TextButton(
              child: Text('Recommencer'),
              onPressed: () {
                setState(() {
                  plateau = PlateauDames(); // Réinitialiser le plateau
                  plateau.selectedPiece = null;
                  plateau.possibleMoves = [];
                  isCaptureMove = false;
                  gameStatus = '';
                });
                Navigator.of(context).pop(); // Fermer le pop-up
              },
            ),
          ],
        );
      },
    );
  }

  void selectionnerPiece(int x, int y) {
    setState(() {
      if (!isCaptureMove) {
        plateau.selectedPiece = plateau.plateau[y][x];
        if (plateau.selectedPiece != null &&
            plateau.selectedPiece!.couleur == plateau.tourActuel) {
          plateau.possibleMoves =
              plateau.selectedPiece!.checkDeplacement(plateau, false);
        } else {
          plateau.selectedPiece = null;
          plateau.possibleMoves = [];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Tour du joueur : ${plateau.tourActuel}',
            style: TextStyle(fontSize: 20)),
        Text('Pièces mortes (Blanc) : ${plateau.compteurBlanc}',
            style: TextStyle(fontSize: 18)),
        Text('Pièces mortes (Noir) : ${plateau.compteurNoir}',
            style: TextStyle(fontSize: 18)),
        Text(gameStatus,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    gameStatus.contains('Échec') ? Colors.red : Colors.green)),
        Expanded(
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemCount: 64,
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;
              Color color = (row + col) % 2 == 0
                  ? plateau.colCase[0]
                  : plateau.colCase[1];

              // Vérifie si la case est celle de la pièce sélectionnée
              if (plateau.selectedPiece != null &&
                  plateau.selectedPiece!.positionY == row &&
                  plateau.selectedPiece!.positionX == col) {
                color = Colors.blue;
              }
              // Vérifie si la case fait partie des déplacements possibles
              else if (plateau.showMoves &&
                  plateau.possibleMoves!.contains(row * 8 + col)) {
                if (plateau.plateau[row][col] == null) {
                  color = Colors.green;
                } else if (plateau.plateau[row][col]!.couleur !=
                    plateau.selectedPiece!.couleur) {
                  color = Colors.red;
                }
              }

              Widget pieceWidget = Container();
              var piece = plateau.plateau[row][col];

              if (piece != null) {
                pieceWidget = Center(
                  child: Image.asset(
                    piece is DameDames
                        ? (piece.couleur == "Blanc"
                            ? "assets/dame/white_piece_queen_v2.png"
                            : "assets/dame/black_piece_queen_v2.png")
                        : (piece.couleur == "Blanc"
                            ? "assets/dame/white_piece_v2.png"
                            : "assets/dame/black_piece_v2.png"),
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Erreur',
                          style: TextStyle(color: Colors.red));
                    },
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  if (isCaptureMove) {
                    // Si une capture est en cours, seule la pièce capturante peut être déplacée
                    if (plateau.selectedPiece != null &&
                        plateau.possibleMoves!.contains(row * 8 + col)) {
                      deplacerPiece(col, row);
                    }
                  } else {
                    if (plateau.selectedPiece == null) {
                      selectionnerPiece(col, row);
                    } else if (plateau.selectedPiece!.positionX == col &&
                        plateau.selectedPiece!.positionY == row) {
                      // Désélectionner la pièce si elle est cliquée à nouveau
                      setState(() {
                        plateau.selectedPiece = null;
                        plateau.possibleMoves = [];
                      });
                    } else if (plateau.possibleMoves!.contains(row * 8 + col)) {
                      deplacerPiece(col, row);
                    } else {
                      // Désélectionner la pièce si une case non valide est cliquée
                      setState(() {
                        plateau.selectedPiece = null;
                        plateau.possibleMoves = [];
                      });
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  color: color,
                  child: pieceWidget,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
