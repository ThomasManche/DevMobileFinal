import 'Piece.dart';
import '../Plateau.dart';

class Roi extends Piece {
  // Classe qui représente le roi
  Roi(String couleur, int positionY, int positionX, String path)
      : super(couleur, 'Roi', positionY, positionX, path);

  @override
  List<int> checkDeplacement(Plateau plateau, bool cond) {
    // Renvoie une liste de tout les déplacements possibles pour la pièce
    List<int> deplacements = [];

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;

        int newX = positionX + i;
        int newY = positionY + j;

        if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8) {
          if (plateau.plateau[newY][newX] == null ||
              plateau.plateau[newY][newX]!.couleur != couleur) {
            deplacements.add(newY * 8 + newX);
          }
        }
      }
    }
    List<int> Roque = plateau.Roque(couleur, cond);
    for (int i = 0; i < Roque.length; i++) {
      deplacements.add(Roque[i]);
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
