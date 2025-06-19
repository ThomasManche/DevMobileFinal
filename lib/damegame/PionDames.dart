import 'Piece.dart';
import 'PlateauDames.dart';
import 'DameDames.dart';

class PionDames extends Piece {
  PionDames(String couleur, int positionY, int positionX)
      : super(couleur, 'Pion', positionY, positionX);

  @override
  List<int> checkDeplacement(PlateauDames plateau, bool captureObligatoire) {
    List<int> deplacements = [];
    int direction = couleur == "Blanc" ? 1 : -1;

    // Déplacement simple
    if (!captureObligatoire) {
      if (positionY + direction >= 0 &&
          positionY + direction < 8 &&
          positionX - 1 >= 0 &&
          plateau.plateau[positionY + direction][positionX - 1] == null) {
        deplacements.add((positionY + direction) * 8 + (positionX - 1));
      }
      if (positionY + direction >= 0 &&
          positionY + direction < 8 &&
          positionX + 1 < 8 &&
          plateau.plateau[positionY + direction][positionX + 1] == null) {
        deplacements.add((positionY + direction) * 8 + (positionX + 1));
      }
    }

    // Capture
    for (int dirX in [-1, 1]) {
      for (int dirY in [-1, 1]) {
        int x = positionX + dirX;
        int y = positionY + dirY;
        if (x >= 0 &&
            x < 8 &&
            y >= 0 &&
            y < 8 &&
            plateau.plateau[y][x] != null &&
            plateau.plateau[y][x]!.couleur != couleur) {
          int newX = x + dirX;
          int newY = y + dirY;
          if (newX >= 0 &&
              newX < 8 &&
              newY >= 0 &&
              newY < 8 &&
              plateau.plateau[newY][newX] == null) {
            deplacements.add(newY * 8 + newX);
          }
        }
      }
    }

    return deplacements;
  }

  // Gère la promotion du pion
  @override
  Piece promotionPiece() {
    if ((couleur == "Blanc" && positionY == 7) ||
        (couleur == "Noir" && positionY == 0)) {
      return DameDames(couleur, positionY, positionX);
    }
    return this; // Pas de promotion si le pion n'a pas atteint la dernière ligne
  }
}
