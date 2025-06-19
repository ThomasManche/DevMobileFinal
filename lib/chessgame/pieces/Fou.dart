import 'Piece.dart';
import '../Plateau.dart';

class Fou extends Piece {
  // Classe qui représente le fou
  Fou(String couleur, int positionY, int positionX, String path)
      : super(couleur, 'Fou', positionY, positionX, path);

  void checkDirection(int dx, int dy, Plateau plateau, List<int> deplacements) {
    // Check à partir d'une direction (dx, dy) les déplacements possibles pour la pièce
    int x = positionX + dx;
    int y = positionY + dy;
    while (x >= 0 && x < 8 && y >= 0 && y < 8) {
      if (plateau.plateau[y][x] == null) {
        deplacements.add(y * 8 + x);
      } else {
        if (plateau.plateau[y][x]!.couleur != couleur) {
          deplacements.add(y * 8 + x);
        }
        // S'arrête dès qu'une pièce est rencontrée
        break;
      }
      x += dx;
      y += dy;
    }
  }

  @override
  List<int> checkDeplacement(Plateau plateau, bool cond) {
    // Renvoie une liste de tout les déplacements possibles pour la pièce
    List<int> deplacements = [];
    // Diagonale bas-droite
    checkDirection(1, 1, plateau, deplacements);
    // Diagonale bas-gauche
    checkDirection(-1, 1, plateau, deplacements);
    // Diagonale haut-droite
    checkDirection(1, -1, plateau, deplacements);
    // Diagonale haut-gauche
    checkDirection(-1, -1, plateau, deplacements);

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
