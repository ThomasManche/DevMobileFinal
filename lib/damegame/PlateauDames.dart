import 'package:flutter/material.dart';
import 'PionDames.dart';
import 'Piece.dart';

class PlateauDames {
  List<List<Piece?>> plateau = List.generate(8, (_) => List.filled(8, null));
  List<Piece?> piecesMortes = [];
  String tourActuel = "Blanc";
  List<Color> colCase = [Colors.brown.shade400, Colors.brown.shade700];
  // Nombre de pièces mangés
  int compteurBlanc = 0;
  int compteurNoir = 0;
// Gérer l'affichage des déplacements ou non
  bool showMoves = true;
  List<int>? possibleMoves = [];
  Piece? selectedPiece;

  PlateauDames() {
    initialisation();
  }

  void Reinitialisation() {
    showMoves = true;
    possibleMoves = [];
    Piece? vars;
    selectedPiece = vars;
    plateau = List.generate(8, (_) => List.filled(8, null));
    initialisation();
  }

  void initialisation() {
    compteurBlanc = 0;
    compteurNoir = 0;
    piecesMortes = [];
    // Placement des pièces blanches
    for (int i = 0; i < 3; i++) {
      for (int j = (i + 1) % 2; j < 8; j += 2) {
        placerPiece(PionDames("Blanc", i, j));
      }
    }

    // Placement des pièces noires
    for (int i = 5; i < 8; i++) {
      for (int j = (i + 1) % 2; j < 8; j += 2) {
        placerPiece(PionDames("Noir", i, j));
      }
    }
  }

  void placerPiece(Piece piece) {
    plateau[piece.positionY][piece.positionX] = piece;
  }

  bool simuleDeplacementPiece(Piece piece, int newX, int newY) {
    // Vérifier si la nouvelle position est dans les limites du plateau
    if (newX < 0 || newX >= 8 || newY < 0 || newY >= 8) {
      return false;
    }

    // Vérifier si la nouvelle position est vide ou contient une pièce adverse
    Piece? targetPiece = plateau[newY][newX];
    if (targetPiece != null && targetPiece.couleur == piece.couleur) {
      return false;
    }

    // Simuler le déplacement
    plateau[piece.positionY][piece.positionX] = null;
    plateau[newY][newX] = piece;

    bool isValid = true;

    // Vérifier si le déplacement est une capture
    if (targetPiece != null) {
      int deltaX = (newX - piece.positionX).abs();
      int deltaY = (newY - piece.positionY).abs();
      if (deltaX == 2 && deltaY == 2 && targetPiece.couleur != piece.couleur) {
        int midX = (newX + piece.positionX) ~/ 2;
        int midY = (newY + piece.positionY) ~/ 2;
        if (plateau[midY][midX] == targetPiece) {
          isValid = true;
        } else {
          isValid = false;
        }
      } else {
        isValid = false;
      }
    }

    // Annuler le déplacement
    plateau[piece.positionY][piece.positionX] = piece;
    plateau[newY][newX] = targetPiece;

    return isValid;
  }

  void alternerTour() {
    tourActuel = (tourActuel == "Blanc") ? "Noir" : "Blanc";
  }

  void ajouterPieceMorte(Piece piece) {
    piecesMortes.add(piece);
    piece.estVivante = false;
    if (piece.couleur == "Noir") {
      compteurNoir += 1;
    } else {
      compteurBlanc += 1;
    }
  }

  bool estFini() {
    // Vérifier si un joueur n'a plus de pions
    bool blancSansPions = true;
    bool noirSansPions = true;
    bool blancPeutJouer = false;
    bool noirPeutJouer = false;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = plateau[i][j];
        if (piece != null) {
          if (piece.couleur == "Blanc") {
            blancSansPions = false;
            if (piece.checkDeplacement(this, false).isNotEmpty) {
              blancPeutJouer = true;
            }
          } else {
            noirSansPions = false;
            if (piece.checkDeplacement(this, false).isNotEmpty) {
              noirPeutJouer = true;
            }
          }
        }
      }
    }

    // Vérifier si un joueur ne peut plus jouer
    if (blancSansPions || !blancPeutJouer) {
      return true;
    }
    if (noirSansPions || !noirPeutJouer) {
      return true;
    }

    return false;
  }
}
