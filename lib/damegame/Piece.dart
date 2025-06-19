import 'PlateauDames.dart';
import 'DameDames.dart';
import 'PionDames.dart';

abstract class Piece {
  final String couleur;
  final String nom;
  bool estVivante;
  int positionX; // Coordonnée X (colonne)
  int positionY; // Coordonnée Y (ligne)

  Piece(this.couleur, this.nom, this.positionY, this.positionX)
      : estVivante = true;

  // Méthode abstraite pour vérifier les déplacements possibles d'une pièce
  List<int> checkDeplacement(PlateauDames plateau, bool captureObligatoire);

  Piece promotionPiece();

  (bool, int, int) checkPieceMangeeDame(
      PlateauDames plateau, int newX, int newY, int positionX, int positionY) {
    int dx = (newX - positionX).sign;
    int dy = (newY - positionY).sign;

    int x = positionX + dx;
    int y = positionY + dy;
    Piece? pieceCapturee;

    while (x != newX && y != newY) {
      if (plateau.plateau[y][x] != null) {
        if (plateau.plateau[y][x]!.couleur != couleur) {
          if (pieceCapturee == null) {
            pieceCapturee =
                plateau.plateau[y][x]; // Première pièce adverse détectée
          } else {
            return (false, 0, 0); // Deux pièces détectées => capture invalide
          }
        } else {
          return (false, 0, 0); // Une pièce alliée bloque le passage
        }
      }
      x += dx;
      y += dy;
    }

    if (pieceCapturee != null) {
      return (true, pieceCapturee.positionY, pieceCapturee.positionX);
    }
    return (false, 0, 0);
  }

  // Déplace la pièce à une nouvelle position si le déplacement est autorisé
  List<int> deplacement(int newX, int newY, PlateauDames plateau) {
    List<int> deplacements = checkDeplacement(plateau, false);

    if (deplacements.contains(newY * 8 + newX)) {
      bool captureEffectuee = false;
      int deltaX = (newX - positionX).abs();
      int deltaY = (newY - positionY).abs();

      if (this is PionDames && deltaX >= 2 && deltaY >= 2) {
        // Capture détectée pour un pion
        int midX = (newX + positionX) ~/ 2;
        int midY = (newY + positionY) ~/ 2;
        Piece? pieceCapturee = plateau.plateau[midY][midX];

        if (pieceCapturee != null && pieceCapturee.couleur != couleur) {
          // Ajouter la pièce capturée à la liste des pièces mortes
          plateau.ajouterPieceMorte(pieceCapturee);
          // Retirer la pièce capturée du plateau
          plateau.plateau[midY][midX] = null;
          captureEffectuee = true;
        }
      } else if (this is DameDames) {
        var (estMange, yMange, xMange) =
            checkPieceMangeeDame(plateau, newX, newY, positionX, positionY);
        if (estMange) {
          // Capture détectée pour la dame
          Piece? pieceCapturee = plateau.plateau[yMange][xMange];

          if (pieceCapturee != null && pieceCapturee.couleur != couleur) {
            // Ajouter la pièce capturée à la liste des pièces mortes
            plateau.ajouterPieceMorte(pieceCapturee);
            // Retirer la pièce capturée du plateau
            plateau.plateau[yMange][xMange] = null;
            captureEffectuee = true;
          }
        }
      }

      // Mettre à jour le plateau
      plateau.plateau[positionY][positionX] = null;
      plateau.plateau[newY][newX] = this;

      // Mettre à jour les coordonnées de la pièce
      positionX = newX;
      positionY = newY;

      // Vérifier la promotion du pion
      Piece promotedPiece = promotionPiece();
      if (promotedPiece != this) {
        plateau.plateau[newY][newX] = promotedPiece;
      }

      // Vérifier si une autre capture est possible dans n'importe quelle direction
      if (captureEffectuee) {
        List<int> nouvellesCaptures = checkDeplacement(plateau, true);
        if (nouvellesCaptures.isNotEmpty) {
          // Permettre au joueur de continuer à capturer dans n'importe quelle direction valide
          return nouvellesCaptures; // Retourner les nouvelles captures possibles
        }
      }
    } else {
      throw Exception("Déplacement non valide !");
    }
    return []; // Retourner une liste vide si aucune capture n'est possible
  }
}
