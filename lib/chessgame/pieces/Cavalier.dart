import 'Piece.dart';
import '../Plateau.dart';

class Cavalier extends Piece {
  // Classe qui représente un cavalier
  Cavalier(String couleur, int positionY, int positionX, String path)
      : super(couleur, 'Cavalier', positionY, positionX, path);

  @override
  List<int> checkDeplacement(Plateau plateau, bool cond) {
    // Renvoie une liste de tout les déplacements possibles pour la pièce
    List<int> deplacements = [];
    List<List<int>> directions = [
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2]
    ];

    for (var direction in directions) {
      int newX = positionX + direction[0];
      int newY = positionY + direction[1];

      if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8) {
        if (plateau.plateau[newY][newX] == null ||
            plateau.plateau[newY][newX]!.couleur != couleur) {
          deplacements.add(newY * 8 + newX);
        }
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
}
