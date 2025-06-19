import '../Plateau.dart';
import '../log.dart';

abstract class Piece {
  // Classe qui représente une pièce
  //Paramètres
  final String couleur;
  final String nom;
  int positionX;
  int positionY;
  String path;

  Piece(this.couleur, this.nom, this.positionY, this.positionX, this.path);

  // Renvoie une liste de tout les déplacements possibles pour la pièce
  List<int> checkDeplacement(Plateau plateau, bool cond);

  // Déplace la pièce à une nouvelle position si le déplacement est autorisé
  Future<void> deplacement(
      int newX, int newY, Plateau plateau, Log database) async {
    List<int> deplacements = checkDeplacement(plateau, true);
    plateau.Nombrecoups += 1;
    if (deplacements.contains(newY * 8 + newX)) {
      // Vérifier s'il y a une prise
      Piece? pieceCapturee = plateau.plateau[newY][newX];
      if (pieceCapturee != null &&
          pieceCapturee.couleur != plateau.tourActuel) {
        // Ajouter la pièce capturée à la liste des pièces mortes
        plateau.ajouterPieceMorte(pieceCapturee);
        plateau.avantDernierMange = plateau.dernierMange;
        plateau.dernierMange = plateau.Nombrecoups;
      }
      // on check le cas du Roque ( Important pour le roi )
      if (nom == "Roi" &&
          plateau.plateau[newY][newX]?.nom == "Tour" &&
          plateau.plateau[newY][newX]?.couleur == couleur) {
        // On est dans le cas du roque, donc on s'occupe de ce cas particulièrement
        if (couleur == "Blanc") {
          plateau.conditionRoque[0] = false;
        } else {
          plateau.conditionRoque[3] = false;
        }
        if (newX == 0) {
          Log logs = Log(
              piece: nom,
              x: positionX,
              y: positionY,
              newX: newX,
              newY: newY,
              pieceCapturee: pieceCapturee != null ? 1 : 0,
              pieceCaptureePiece:
                  pieceCapturee != null ? pieceCapturee.nom : "",
              couleur: couleur,
              timerB: plateau.timerB.getSeconds() +
                  plateau.timerB.getMinutes() * 60,
              timerN: plateau.timerN.getSeconds() +
                  plateau.timerN.getMinutes() * 60,
              turn: plateau.tourActuel);
          await database.insertLog(logs);
          plateau.plateau[positionY][positionX] = null;
          positionX = newX + 2;
          positionY = newY;
          plateau.plateau[newY][newX + 1] = this;
          plateau.plateau[newY][newX + 3] = plateau.plateau[newY][newX];
          plateau.plateau[newY][newX + 3]?.positionX = newX + 3;
          plateau.plateau[newY][newX] = null;
          return;
        }
        if (newX == 7) {
          Log logs = Log(
              piece: nom,
              x: positionX,
              y: positionY,
              newX: newX,
              newY: newY,
              pieceCapturee: pieceCapturee != null ? 1 : 0,
              pieceCaptureePiece:
                  pieceCapturee != null ? pieceCapturee.nom : "",
              couleur: couleur,
              timerB: plateau.timerB.getSeconds() +
                  plateau.timerB.getMinutes() * 60,
              timerN: plateau.timerN.getSeconds() +
                  plateau.timerN.getMinutes() * 60,
              turn: plateau.tourActuel);
          await database.insertLog(logs);
          plateau.plateau[positionY][positionX] = null;
          positionX = newX - 1;
          positionY = newY;
          plateau.plateau[newY][newX - 1] = this;
          plateau.plateau[newY][newX - 2] = plateau.plateau[newY][newX];
          plateau.plateau[newY][newX - 2]?.positionX = newX - 2;
          plateau.plateau[newY][newX] = null;
          return;
        }
      }
      // On check si la pièce à bouger est une tour ( Condition pour le roque qui nécessite que les tours ne bougent pas)
      if (this.nom == "Tour") {
        if (this.positionX == 0 && this.positionY == 0) {
          plateau.conditionRoque[4] = false;
        }
        if (this.positionX == 7 && this.positionY == 0) {
          plateau.conditionRoque[5] = false;
        }
        if (this.positionX == 0 && this.positionY == 7) {
          plateau.conditionRoque[1] = false;
        }
        if (this.positionX == 7 && this.positionY == 7) {
          plateau.conditionRoque[2] = false;
        }
      }
      // On check si la pièce à bouger est un roi ( Condition pour le roque qui nécessite que les rois ne bougent pas)
      if (this.nom == "Roi") {
        if (this.positionX == 4 && this.positionY == 0) {
          plateau.conditionRoque[3] = false;
        }
        if (this.positionX == 4 && this.positionY == 7) {
          plateau.conditionRoque[0] = false;
        }
      }

      // Simuler le déplacement pour vérifier l'échec
      if (!plateau.simuleDeplacementEtVerifieEchec(this, newX, newY, true)) {
        // Effectuer le déplacement
        Log logs = Log(
            piece: nom,
            x: positionX,
            y: positionY,
            newX: newX,
            newY: newY,
            pieceCapturee: pieceCapturee != null ? 1 : 0,
            pieceCaptureePiece: pieceCapturee != null ? pieceCapturee.nom : "",
            couleur: couleur,
            timerB:
                plateau.timerB.getSeconds() + plateau.timerB.getMinutes() * 60,
            timerN:
                plateau.timerN.getSeconds() + plateau.timerN.getMinutes() * 60,
            turn: plateau.tourActuel);
        await database.insertLog(logs);
        plateau.plateau[positionY][positionX] = null;
        positionX = newX;
        positionY = newY;
        plateau.plateau[newY][newX] = this;
      } else {
        throw Exception("Déplacement provoque un échec !");
      }
    }
  }

  Piece promotionPiece(String typePromotion, Plateau plateau) {
    return this;
  }
}
