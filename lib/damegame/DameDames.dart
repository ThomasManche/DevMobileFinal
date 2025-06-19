import 'Piece.dart';
import 'PlateauDames.dart';

class DameDames extends Piece {
  DameDames(String couleur, int positionY, int positionX)
      : super(couleur, 'Dame', positionY, positionX);

  @override
  List<int> checkDeplacement(PlateauDames plateau, bool captureObligatoire) {
    List<int> deplacements = [];

    // Directions possibles pour une dame (diagonales)
    List<List<int>> directions = [
      [-1, -1], // Avant gauche
      [-1, 1], // Avant droite
      [1, -1], // Arrière gauche
      [1, 1] // Arrière droite
    ];

    // Vérifier les déplacements multiples
    for (var direction in directions) {
      int deltaY = direction[0];
      int deltaX = direction[1];
      int newY = positionY + deltaY;
      int newX = positionX + deltaX;
      bool hasCaptured = false;

      // Vérifier si la nouvelle case est dans les limites et libre
      while (newY >= 0 && newY < 8 && newX >= 0 && newX < 8) {
        if (plateau.plateau[newY][newX] == null) {
          if (!captureObligatoire) {
            deplacements.add(newY * 8 + newX);
          }
        } else if (plateau.plateau[newY][newX]!.couleur != couleur &&
            !hasCaptured) {
          // Vérifier la possibilité de capture
          int captureY = newY + deltaY;
          int captureX = newX + deltaX;
          if (captureY >= 0 &&
              captureY < 8 &&
              captureX >= 0 &&
              captureX < 8 &&
              plateau.plateau[captureY][captureX] == null) {
            deplacements.add(captureY * 8 + captureX);
            hasCaptured = true;
            if (!captureObligatoire) {
              // Ajouter toutes les cases libres après la capture
              int tempY = captureY + deltaY;
              int tempX = captureX + deltaX;
              while (tempY >= 0 &&
                  tempY < 8 &&
                  tempX >= 0 &&
                  tempX < 8 &&
                  plateau.plateau[tempY][tempX] == null) {
                deplacements.add(tempY * 8 + tempX);
                tempY += deltaY;
                tempX += deltaX;
              }
            }
          }
          break;
        } else {
          break;
        }
        newY += deltaY;
        newX += deltaX;
      }
    }

    return deplacements;
  }

  @override
  Piece promotionPiece() {
    // La dame ne se promeut pas, elle reste une dame
    return this;
  }
}
