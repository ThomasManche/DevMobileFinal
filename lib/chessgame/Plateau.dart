import 'pieces/Cavalier.dart';
import 'pieces/Dame.dart';
import 'pieces/Fou.dart';
import 'pieces/Piece.dart';
import 'pieces/Tour.dart';
import 'pieces/Roi.dart';
import 'pieces/Pion.dart';
import 'log.dart';
import 'package:flutter/material.dart';
import '../timer.dart';

class Plateau {
  //Classe qui gère le plateau et le déroulement du jeuone
  // Paramètres
  // Plateau de jeu
  List<List<Piece?>> plateau = List.generate(8, (_) => List.filled(8, null));
  // Liste des pièces tombés au combat
  List<Piece> piecesMortes = [];
  // String représentant le tour
  String tourActuel = "Blanc";
  // Pièce du roi blanc et noir
  late Piece roiBlanc;
  late Piece roiNoir;
  // Pour le roque : Un tableau pour savoir si le roi et les tours ont bougé
  List<bool> conditionRoque = [];
  // Dossier des pièces
  String path = "assets/normal_chess/";
  // Tableau pour les undos ( 0 pour les blancs, 1 pour les noirs )
  List<bool> conditionUndo = [];
  // Utilisé pour gérer les draw
  int Nombrecoups = 0;
  // On stocke 2 fois la variable, 1 à k et 1 à k-1, pour gérer le undo
  int dernierMange = 0;
  int avantDernierMange = 0;
  bool ConditionJeu = true;

  bool firstMove = true;
  bool wasFirstMove = true;
  bool undoMove = false;

  int timerBUndo = 0;
  int timerNUndo = 0;

  List<Color> colCase = [Colors.brown.shade400, Colors.brown.shade700];

  late TimerManager timerB;
  late TimerManager timerN;
  late int minutes;

  // Constructeur
  Plateau(this.timerB, this.timerN, this.minutes) {
    // Lors de la création du plateau, on initialise le tableau
    roiBlanc = Roi("Blanc", 7, 4, '${path}white-king.png');
    roiNoir = Roi("Noir", 0, 4, '${path}black-king.png');
    initialisation();
  }

  void setPieceSkin(String newPath) {
    path = newPath;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (plateau[i][j] != null) {
          switch (plateau[i][j]!.nom) {
            case "Pion":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-pawn.png';
              break;
            case "Dame":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-queen.png';
              break;
            case "Cavalier":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-knight.png';
              break;
            case "Fou":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-bishop.png';
              break;
            case "Roi":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-king.png';
              break;
            case "Tour":
              plateau[i][j]?.path =
                  '$newPath${plateau[i][j]!.couleur == "Blanc" ? "white" : "black"}-rook.png';
              break;

            default:
          }
        }
      }
    }
  }

  void initialisation() {
    //Fonction qui permet d'initialiser la partie de jeu aux bonnes conditions
    // Placement des pièces blanches sur le plateau, et création du roi blanc
    plateau[7][0] = Tour("Blanc", 7, 0, '${path}white-rook.png');
    plateau[7][1] = Cavalier("Blanc", 7, 1, '${path}white-knight.png');
    plateau[7][2] = Fou("Blanc", 7, 2, '${path}white-bishop.png');
    plateau[7][3] = Dame("Blanc", 7, 3, '${path}white-queen.png');
    plateau[7][4] = roiBlanc;
    plateau[7][5] = Fou("Blanc", 7, 5, '${path}white-bishop.png');
    plateau[7][6] = Cavalier("Blanc", 7, 6, '${path}white-knight.png');
    plateau[7][7] = Tour("Blanc", 7, 7, '${path}white-rook.png');
    for (int i = 0; i < 8; i++) {
      plateau[6][i] = Pion("Blanc", 6, i, '${path}white-pawn.png');
    }
    // Placement des pièces noires sur le plateau, et création du roi noir
    plateau[0][0] = Tour("Noir", 0, 0, '${path}black-rook.png');
    plateau[0][1] = Cavalier("Noir", 0, 1, '${path}black-knight.png');
    plateau[0][2] = Fou("Noir", 0, 2, '${path}black-bishop.png');
    plateau[0][3] = Dame("Noir", 0, 3, '${path}black-queen.png');

    plateau[0][4] = roiNoir;
    plateau[0][5] = Fou("Noir", 0, 5, '${path}black-bishop.png');
    plateau[0][6] = Cavalier("Noir", 0, 6, '${path}black-knight.png');
    plateau[0][7] = Tour("Noir", 0, 7, '${path}black-rook.png');
    for (int i = 0; i < 8; i++) {
      plateau[1][i] = Pion("Noir", 1, i, '${path}black-pawn.png');
    }
    // On initialise les conditions de roque
    conditionRoque = [];
    for (int i = 0; i < 6; i++) {
      conditionRoque.add(true);
    }
    conditionUndo = [];
    for (int i = 0; i < 2; i++) {
      conditionUndo.add(false);
    }
    piecesMortes = [];
    ConditionJeu = true;
    Nombrecoups = 0;
    dernierMange = 0;
    avantDernierMange = 0;
  }

  void Reinitialisation() {
    timerB.stop();
    timerN.stop();
    plateau = List.generate(8, (_) => List.filled(8, null));
    piecesMortes = [];
    tourActuel = "Blanc";
    roiBlanc = Roi("Blanc", 7, 4, '${path}white-king.png');
    roiNoir = Roi("Noir", 0, 4, '${path}black-king.png');
    firstMove = true;
    undoMove = false;
    timerB.setMinutes(minutes);
    timerB.setSeconds(0);
    timerN.setMinutes(minutes);
    timerN.setSeconds(0);
    initialisation();
  }

  void placerPiece(Piece piece) {
    // Fonction qui permet de placer une pièce sur le plateau (Utilisé pour les tests)
    plateau[piece.positionY][piece.positionX] = piece;
  }

  List<int> Roque(String couleur, bool cond) {
    List<int> result = [];
    if (!cond) {
      return result;
    }
    if (couleur == "Blanc") {
      // On vérifie si le roi peut roquer ( Roi qui n'a pas bougé & Roi pas en échec )
      if (conditionRoque[0] && !echec(couleur)) {
        // On vérifie si la tour G peut roquer
        if (conditionRoque[1]) {
          // On check maintenant si toute les cases sont vide
          if (plateau[7][1] == null &&
              plateau[7][2] == null &&
              plateau[7][3] == null) {
            //Enfin, on regarde si chacune des cases permet le déplacement
            if (!simuleDeplacementEtVerifieEchec(roiBlanc, 7, 1, false) &&
                !simuleDeplacementEtVerifieEchec(roiBlanc, 7, 2, false) &&
                !simuleDeplacementEtVerifieEchec(roiBlanc, 7, 3, false)) {
              result.add(8 * 7 + 0);
            }
          }
        }
        if (conditionRoque[2]) {
          // On check maintenant si toute les cases sont vide
          if (plateau[7][5] == null && plateau[7][6] == null) {
            //Enfin, on regarde si chacune des cases permet le déplacement
            if (!simuleDeplacementEtVerifieEchec(roiBlanc, 7, 5, false) &&
                !simuleDeplacementEtVerifieEchec(roiBlanc, 7, 6, false)) {
              result.add(8 * 7 + 7);
            }
          }
        }
      }
    }
    if (couleur == "Noir") {
      // On vérifie si le roi peut roquer ( Roi qui n'a pas bougé & Roi pas en échec )
      if (conditionRoque[3] && !echec(couleur)) {
        // On vérifie si la tour G peut roquer
        if (conditionRoque[4]) {
          // On check maintenant si toute les cases sont vide
          if (plateau[0][1] == null &&
              plateau[0][2] == null &&
              plateau[0][3] == null) {
            //Enfin, on regarde si chacune des cases permet le déplacement

            if (!simuleDeplacementEtVerifieEchec(roiNoir, 0, 1, false) &&
                !simuleDeplacementEtVerifieEchec(roiNoir, 0, 2, false) &&
                !simuleDeplacementEtVerifieEchec(roiNoir, 0, 3, false)) {
              result.add(0);
            }
          }
        }
        if (conditionRoque[5]) {
          // On check maintenant si toute les cases sont vide
          if (plateau[0][5] == null && plateau[0][6] == null) {
            //Enfin, on regarde si chacune des cases permet le déplacement
            if (!simuleDeplacementEtVerifieEchec(roiNoir, 0, 5, false) &&
                !simuleDeplacementEtVerifieEchec(roiNoir, 0, 6, false)) {
              result.add(7);
            }
          }
        }
      }
    }
    return result;
  }

  bool echec(String couleur) {
    // Fonction qui vérifie l'échec : On va chercher la position du roi et regarder si le déplacement d'une pièce adverse peut l'atteindre.
    // Si oui, alors il y a échec.
    // Acquisition du roi
    Piece? roi = couleur == "Blanc" ? roiBlanc : roiNoir;
    // Check le déplacement de chaque pièce de l'autre couleur pour voir s'il y a échec
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = plateau[i][j];
        if (piece != null && piece.couleur != couleur) {
          List<int> deplacements = piece.checkDeplacement(this, false);
          if (deplacements.contains(roi.positionY * 8 + roi.positionX)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool simuleDeplacementEtVerifieEchec(
      Piece piece, int newX, int newY, bool test) {
    // Simule le déplacement et regarde si'l y a échec de la couleur après le déplacement. Si oui, alors le déplacement n'est pas autorisé.
    if (newX < 0 || newX >= 8 || newY < 0 || newY >= 8) return true;
    if (test) {
      Piece? pieceCapturee = plateau[newY][newX];

      int oldX = piece.positionX;
      int oldY = piece.positionY;

      plateau[oldY][oldX] = null;
      piece.positionX = newX;
      piece.positionY = newY;
      plateau[newY][newX] = piece;
      bool enEchec = echec(piece.couleur);

      plateau[newY][newX] = pieceCapturee;
      plateau[oldY][oldX] = piece;
      piece.positionX = oldX;
      piece.positionY = oldY;

      return enEchec;
    }
    return false;
  }

  bool echecEtMat(String couleur) {
    // Vérifie la présence d'un échec et mat, en regardant s'il y a un mouvement valide de la couleur possible
    if (!echec(couleur)) return false;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = plateau[i][j];
        if (piece != null && piece.couleur == couleur) {
          List<int> deplacements = piece.checkDeplacement(this, true);
          for (int i = 0; i < deplacements.length; i++) {}
          if (deplacements.isNotEmpty) {
            return false;
          }
        }
      }
    }

    return true;
  }

  bool pat(String couleur) {
    // Vérifie la présence d'un pat (Aucun déplacement alors que pas d'échec), en regardant s'il y a un mouvement valide de la couleur possible
    if (echec(couleur)) return false;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = plateau[i][j];
        if (piece != null && piece.couleur == couleur) {
          List<int> deplacements = piece.checkDeplacement(this, true);
          for (int i = 0; i < deplacements.length; i++) {}
          if (deplacements.isNotEmpty) {
            return false;
          }
        }
      }
    }

    return true;
  }

  Future<bool> sameMove(Log database, int k1, int k2, int k3) async {
    Log d1 = (await database.getLog(k1));
    Log d2 = (await database.getLog(k2));
    Log d3 = (await database.getLog(k3));
    if (d1.piece == d2.piece && d2.piece == d1.piece) {
      if (d1.x == d2.x && d2.x == d3.x && d1.y == d2.y && d2.y == d3.y) {
        if (d1.newX == d2.newX &&
            d2.newX == d3.newX &&
            d1.newY == d2.newY &&
            d2.newY == d3.newY) {
          if (d1.pieceCapturee == d1.pieceCapturee &&
              d2.pieceCapturee == d3.pieceCapturee) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool pieceInsu() {
    List<Piece> pieceRestantes = [];
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (plateau[i][j] != null) {
          if (plateau[i][j]!.nom == "Pion" ||
              plateau[i][j]!.nom == "Dame" && plateau[i][j]!.nom == "Tour") {
            return false;
          }
          pieceRestantes.add(plateau[i][j]!);
        }
      }
    }
    if (pieceRestantes.length > 3) {
      return false;
    }
    return true;
  }

  Future<bool> nul(Log database) async {
    if (Nombrecoups> 11) {
      // On check si le mouvement 1,5,9 && 2,6,10
      if (await sameMove(database, Nombrecoups - 1, Nombrecoups - 5, Nombrecoups - 9) &&
          await sameMove(database, Nombrecoups - 2, Nombrecoups - 6, Nombrecoups - 10)) {
        return true;
      }
      if (Nombrecoups > 101) {
        if (Nombrecoups - dernierMange == 100) {
          return true;
        }
      }
      if (pieceInsu()) {
        return true;
      }
    }
    return false;
  }

  void ajouterPieceMorte(Piece? piece) {
    // Fonction qui permet d'ajouter une pièce à la liste des pièces mortes
    if (piece != null) {
      piecesMortes.add(piece);
    }
  }

  List<Piece> PieceMorteListeCouleur(String couleur) {
    List<Piece> k = [];
    for (int i = 0; i < piecesMortes.length; i++) {
      if (piecesMortes[i].couleur == couleur) {
        k.add(piecesMortes[i]);
      }
    }
    return k;
  }

  void Undo(Log l) {
    if (ConditionJeu) {
      // Vérifiez que les indices sont valides
      Nombrecoups -= 1;
      undoMove = true;
      if (tourActuel == "Noir") {
        int minutes = 0;
        int seconds = timerNUndo;
        while (seconds >= 60) {
          minutes += 1;
          seconds = seconds - 60;
        }
        timerN.setSeconds(seconds);
        timerN.setMinutes(minutes);
        if (!wasFirstMove) {
          timerB.addSeconds(-10);
        }
      } else {
        int minutes = 0;
        int seconds = timerBUndo;
        while (seconds >= 60) {
          minutes += 1;
          seconds = seconds - 60;
        }
        timerB.setSeconds(seconds);
        timerB.setMinutes(minutes);
        timerN.addSeconds(-10);
      }
      if (dernierMange == Nombrecoups + 1) {
        dernierMange = avantDernierMange;
      }
      if (l.x >= 0 &&
          l.y >= 0 &&
          l.newX >= 0 &&
          l.newY >= 0 &&
          l.x < 8 &&
          l.y < 8 &&
          l.newX < 8 &&
          l.newY < 8) {
        // Vérifiez que la pièce à la nouvelle position n'est pas nulle
        if (plateau[l.newY][l.newX] != null) {
          Piece k = plateau[l.newY][l.newX]!;
          if (k.nom != l.piece && l.piece == "Pion") {
            // On est dans le cas d'une promotion de pièce
            piecesMortes
                .remove(piecesMortes.elementAt(piecesMortes.length - 1));
            piecesMortes.add(k);
            k = Pion(tourActuel == "Blanc" ? "Noir" : "Blanc", l.newY, l.newX,
                "$path${tourActuel == "Blanc" ? "black" : "white"}-pawn.png");
          }
          k.positionX = l.x;
          k.positionY = l.y;
          plateau[l.y][l.x] = k;
          plateau[l.newY][l.newX] = null;
          alternerTour();
          conditionUndo[0] = false;
          conditionUndo[1] = false;
        } else {
          if (l.piece == "Roi") {
            if (l.pieceCapturee == 1) {
              if (l.pieceCaptureePiece == "Tour") {
                if (l.couleur == "Blanc") {
                  if (l.newX == 7 && l.newY == 7) {
                    if (plateau[7][5]?.nom == "Tour" &&
                        plateau[7][5]?.couleur == l.couleur) {
                      Piece k = plateau[7][5]!;
                      k.positionX = 7;
                      k.positionY = 7;
                      plateau[7][7] = k;
                      plateau[7][5] = null;
                      plateau[7][4] = roiBlanc;
                      roiBlanc.positionX = 4;
                      plateau[7][6] = null;
                      alternerTour();
                      conditionRoque[0] = true;
                      conditionRoque[2] = true;
                      conditionUndo[0] = false;
                      conditionUndo[1] = false;
                      return;
                    }
                  }
                  if (l.newX == 0 && l.newY == 7) {
                    if (plateau[7][3]?.nom == "Tour" &&
                        plateau[7][3]?.couleur == l.couleur) {
                      Piece k = plateau[7][3]!;
                      k.positionX = 0;
                      k.positionY = 7;
                      plateau[7][0] = k;
                      plateau[7][3] = null;
                      plateau[7][4] = roiBlanc;
                      roiBlanc.positionX = 4;
                      plateau[7][2] = null;
                      plateau[7][1] = null;
                      alternerTour();
                      conditionRoque[0] = true;
                      conditionRoque[1] = true;
                      conditionUndo[0] = false;
                      conditionUndo[1] = false;
                      return;
                    }
                  }
                } else if (l.couleur == "Noir") {
                  if (l.newX == 7 && l.newY == 0) {
                    if (plateau[0][5]?.nom == "Tour" &&
                        plateau[0][5]?.couleur == l.couleur) {
                      Piece k = plateau[0][5]!;
                      k.positionX = 7;
                      k.positionY = 0;
                      plateau[0][7] = k;
                      plateau[0][5] = null;
                      plateau[0][4] = roiNoir;
                      roiNoir.positionX = 4;
                      plateau[0][6] = null;
                      alternerTour();
                      conditionRoque[3] = true;
                      conditionRoque[5] = true;
                      conditionUndo[0] = false;
                      conditionUndo[1] = false;
                      return;
                    }
                  }
                  if (l.newX == 0 && l.newY == 0) {
                    if (plateau[0][3]?.nom == "Tour" &&
                        plateau[0][3]?.couleur == l.couleur) {
                      Piece k = plateau[0][3]!;
                      k.positionX = 0;
                      k.positionY = 0;
                      plateau[0][0] = k;
                      plateau[0][3] = null;
                      plateau[0][4] = roiNoir;
                      roiNoir.positionX = 4;
                      plateau[0][2] = null;
                      plateau[0][1] = null;
                      alternerTour();
                      conditionRoque[3] = true;
                      conditionRoque[4] = true;
                      conditionUndo[0] = false;
                      conditionUndo[1] = false;
                      return;
                    }
                  }
                }
              }
            }
          }
        }
        if (l.pieceCapturee == 1) {
          piecesMortes.remove(piecesMortes.elementAt(piecesMortes.length - 1));
          String couleurP = l.couleur == "Blanc" ? "Noir" : "Blanc";
          if (l.couleur == "Noir") {
            switch (l.pieceCaptureePiece) {
              case "Dame":
                plateau[l.newY][l.newX] =
                    Dame(couleurP, l.newY, l.newX, "${path}white-queen.png");
                break;
              case "Pion":
                plateau[l.newY][l.newX] =
                    Pion(couleurP, l.newY, l.newX, "${path}white-pawn.png");
                break;
              case "Cavalier":
                plateau[l.newY][l.newX] = Cavalier(
                    couleurP, l.newY, l.newX, "${path}white-knight.png");
                break;
              case "Fou":
                plateau[l.newY][l.newX] =
                    Fou(couleurP, l.newY, l.newX, "${path}white-bishop.png");
                break;
              case "Tour":
                plateau[l.newY][l.newX] =
                    Tour(couleurP, l.newY, l.newX, "${path}white-rook.png");
                break;
              default:
            }
          } else {
            switch (l.pieceCaptureePiece) {
              case "Dame":
                plateau[l.newY][l.newX] =
                    Dame(couleurP, l.newY, l.newX, "${path}black-queen.png");
                break;
              case "Pion":
                plateau[l.newY][l.newX] =
                    Pion(couleurP, l.newY, l.newX, "${path}black-pawn.png");
                break;
              case "Cavalier":
                plateau[l.newY][l.newX] = Cavalier(
                    couleurP, l.newY, l.newX, "${path}black-knight.png");
                break;
              case "Fou":
                plateau[l.newY][l.newX] =
                    Fou(couleurP, l.newY, l.newX, "${path}black-bishop.png");
                break;
              case "Tour":
                plateau[l.newY][l.newX] =
                    Tour(couleurP, l.newY, l.newX, "${path}black-rook.png");
                break;
              default:
            }
          }
        }
      }
    }
    return;
  }

  void alternerTour() {
    // Fonction qui permet de changer le tour
    tourActuel = (tourActuel == "Blanc") ? "Noir" : "Blanc";
    if (tourActuel == "Blanc") {
      conditionUndo[0] = false;
      conditionUndo[1] = true;
      timerN.stop();
      timerBUndo = timerB.getSeconds() + timerB.getMinutes() * 60;
      if (undoMove) {
        undoMove = false;
      } else {
        timerN.addSeconds(10);
      }
      timerB.start();
    } else {
      conditionUndo[1] = false;
      conditionUndo[0] = true;
      timerB.stop();
      timerNUndo = timerN.getSeconds() + timerN.getMinutes() * 60;
      if (firstMove) {
        firstMove = false;
      } else {
        wasFirstMove = false;
        if (undoMove) {
          undoMove = false;
        } else {
          timerB.addSeconds(10);
        }
      }
      timerN.start();
    }
  }

  void sauvergarderPartie(Log database) {
    database.createSave();
    database.getLogs().then((logsMaps) {
      if (logsMaps.isNotEmpty) {
        for (var log in logsMaps) {
          database.insertSave(log);
        }
      }
    });
    database.getSaves().then((value) {});
  }

  Future<void> chargerPartie(Log database) async {
    Reinitialisation();
    database.resetDatabase();
    int lastTimerN = 600, lastTimerB = 600;
    await database.getSaves().then((saves) async {
      if (saves.isNotEmpty) {
        for (var save in saves) {
          tourActuel = save.turn;
          lastTimerB = save.timerB;
          lastTimerN = save.timerN;
          await plateau[save.y][save.x]
              ?.deplacement(save.newX, save.newY, this, database);
        }
      }
    });
    timerB.setMinutes(0);
    timerB.setSeconds(0);
    timerB.addSeconds(lastTimerB);
    timerN.setMinutes(0);
    timerN.setSeconds(0);
    timerN.addSeconds(lastTimerN);
    if (Nombrecoups > 0){tourActuel = tourActuel=="Blanc"? "Noir":"Blanc";}
    conditionUndo[0]=false;
    conditionUndo[1]=false;
  }
}
