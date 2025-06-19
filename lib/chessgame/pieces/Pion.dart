import 'Cavalier.dart';
import 'Dame.dart';
import 'Fou.dart';
import 'Piece.dart';
import '../Plateau.dart';
import 'Tour.dart';

class Pion extends Piece {
  // Classe qui représente un pion
  Pion(String couleur, int positionY, int positionX, String path)
      : super(couleur, 'Pion', positionY, positionX, path);

  @override
  List<int> checkDeplacement(Plateau plateau, bool cond) {
    // Renvoie une liste de tout les déplacements possibles pour la pièce
    List<int> deplacements = [];
    int direction = (couleur == "Blanc") ? -1 : 1;

    // On check si on peut avancer d'une case
    if (positionY + direction >= 0 &&
        positionY + direction < 8 &&
        plateau.plateau[positionY + direction][positionX] == null) {
      deplacements.add((positionY + direction) * 8 + positionX);

      // Si on peut avancer d'une case, on check si on peut avancer de deux cases
      if ((couleur == "Blanc" && positionY == 6) ||
          (couleur == "Noir" && positionY == 1)) {
        if (plateau.plateau[positionY + 2 * direction][positionX] == null) {
          deplacements.add((positionY + 2 * direction) * 8 + positionX);
        }
      }
    }

    // On check si on peut manger un pion en diagonale gauche
    if (positionX > 0 &&
        positionY + direction >= 0 &&
        positionY + direction < 8) {
      if (plateau.plateau[positionY + direction][positionX - 1]?.couleur !=
              couleur &&
          plateau.plateau[positionY + direction][positionX - 1] != null) {
        deplacements.add((positionY + direction) * 8 + (positionX - 1));
      }
    }

    // On check si on peut manger un pion en diagonale droite
    if (positionX < 7 &&
        positionY + direction >= 0 &&
        positionY + direction < 8) {
      if (plateau.plateau[positionY + direction][positionX + 1]?.couleur !=
              couleur &&
          plateau.plateau[positionY + direction][positionX + 1] != null) {
        deplacements.add((positionY + direction) * 8 + (positionX + 1));
      }
    }

    // Si l'on demande à simuler les coups pour vérifier s'ils nous mettent en échec
    if (cond) {
      List<int> deplacementsValide = [];
      for (int e in deplacements) {
        int newX = e % 8;
        int newY = e ~/ 8;
        if (!plateau.simuleDeplacementEtVerifieEchec(this, newX, newY, true)) {
          deplacementsValide.add(e);
        }
      }
      return deplacementsValide;
    }
    return deplacements;
  }

  // Gère la promotion du pion
  Piece promotionPiece(String typePromotion, Plateau plateau) {
    if ((couleur == "Blanc" && positionY == 0) ||
        (couleur == "Noir" && positionY == 7)) {
      switch (typePromotion) {
        case "Dame":
          return Dame(couleur, positionY, positionX,
              '${plateau.path}${couleur == "Blanc" ? "white" : "black"}-queen.png');

        case "Tour":
          return Tour(couleur, positionY, positionX,
              '${plateau.path}${couleur == "Blanc" ? "white" : "black"}-rook.png');
        case "Fou":
          return Fou(couleur, positionY, positionX,
              '${plateau.path}${couleur == "Blanc" ? "white" : "black"}-bishop.png');
        case "Cavalier":
          return Cavalier(couleur, positionY, positionX,
              '${plateau.path}${couleur == "Blanc" ? "white" : "black"}-knight.png');
        default:
          throw ArgumentError("Type de promotion invalide : $typePromotion");
      }
    }
    return this; // Pas de promotion si le pion n'a pas atteint la dernière ligne
  }
}
