import '../../chessgame/log.dart';
import 'package:flutter/material.dart';
import '../../chessgame/pieces/Piece.dart';
import '../../chessgame/Plateau.dart';

class AffichageEchec extends StatefulWidget {
  final Plateau plateau;
  final Log database;
  final TextEditingController namePlayer1;
  final TextEditingController namePlayer2;

  const AffichageEchec(
      {super.key,
      required this.plateau,
      required this.database,
      required this.namePlayer1,
      required this.namePlayer2});

  @override
  _AffichageEchecState createState() => _AffichageEchecState();
}

class _AffichageEchecState extends State<AffichageEchec> {
  late Plateau plateau;
  Piece? selectedPiece;
  late Log database;
  List<int> possibleMoves = [];
  late String namePlayer1;
  late String namePlayer2;

  @override
  void initState() {
    super.initState();
    plateau = widget.plateau;
    database = widget.database;
    namePlayer1 = widget.namePlayer1.text;
    namePlayer2 = widget.namePlayer2.text;
    didChangeDependencies();

    if (namePlayer1 == "") {
      namePlayer1 = "Joueur 1";
    }
    if (namePlayer2 == "") {
      namePlayer2 = "Joueur 2";
    }

    widget.namePlayer2.text = widget.namePlayer2.text;
    plateau.timerB.onTick = () => setState(() {});
    plateau.timerN.onTick = () => setState(() {});
  }

  Widget _buildBoutonNoir(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: () async {
            if (plateau.conditionUndo[1] && plateau.ConditionJeu) {
              Log log = await database.getLog(plateau.Nombrecoups);
              setState(() {
                plateau.Undo(log);
                database.deleteLogEntry(
                    log.piece, log.x, log.y, log.newX, log.newY);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            shape: CircleBorder(),
          ),
          child: Transform.rotate(
            angle: 3.1416,
            child: Text("Undo",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03)),
          ),
        ),
      ),
    );
  }

  Widget _buildBoutonBlanc(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: () async {
            if (plateau.conditionUndo[0] && plateau.ConditionJeu) {
              Log log = await database.getLog(plateau.Nombrecoups);
              setState(() {
                plateau.Undo(log);
                database.deleteLogEntry(
                    log.piece, log.x, log.y, log.newX, log.newY);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
            shape: CircleBorder(),
          ),
          child: Text("Undo",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _buildInterfaceNoir(context),
            _buildEchiquier(),
            _buildInterfaceBlanche(context),
          ],
        ),
        _buildBoutonBlanc(context),
        _buildBoutonNoir(context),
      ],
    );
  }

  Widget _buildInterfaceNoir(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.035,
          left: 12.0,
          right: 12.0,
          bottom: 12.0),
      child: Transform.rotate(
        angle: 3.1416,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildPiecesMangees(
                          plateau.PieceMorteListeCouleur("Blanc")),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(namePlayer2,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontFamily: 'Roboto',
                          fontStyle: FontStyle.italic,
                        )),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    children: [
                      Text('Tour : ',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                      Text(plateau.tourActuel == "Noir" ? "🔵" : "⚫",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Text('|',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      Text('Échec: ',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                      Text(plateau.echec("Noir") ? "🔴" : "⚫",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                  vertical: MediaQuery.of(context).size.height * 0.01),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                  "${plateau.timerN.getMinutes()} : ${plateau.timerN.getSeconds()}",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterfaceBlanche(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPiecesMangees(plateau.PieceMorteListeCouleur("Noir")),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    namePlayer1,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontFamily: 'PlayfairDisplay',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  children: [
                    Text('Tour : ',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                    Text(plateau.tourActuel == "Blanc" ? "🔵" : "⚫",
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Text('|',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                    Text('Échec: ',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                    Text(plateau.echec("Blanc") ? "🔴" : "⚫",
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.05)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: MediaQuery.of(context).size.height * 0.01),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
                '${plateau.timerB.getMinutes()} : ${plateau.timerB.getSeconds()}',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPiecesMangees(List<Piece> pieces) {
    if (pieces.isEmpty) {
      return Text('✖',
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.grey));
    }
    return Wrap(
      spacing: 0.0,
      children: pieces
          .map((piece) => Transform.rotate(
                angle: piece.couleur == "Noir" ? 3.1416 : 0,
                child: Image.asset(piece.path,
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.width * 0.06),
              ))
          .toList(),
    );
  }

  Widget _buildEchiquier() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: () => deselectionnerPiece(),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemCount: 64,
          itemBuilder: (context, index) {
            int row = index ~/ 8;
            int col = index % 8;
            Color color =
                (row + col) % 2 == 0 ? plateau.colCase[0] : plateau.colCase[1];
            if (selectedPiece != null &&
                selectedPiece!.positionX == col &&
                selectedPiece!.positionY == row) {
              color = Colors.blue;
            } else if (possibleMoves.contains(index)) {
              color =
                  plateau.plateau[row][col] == null ? Colors.green : Colors.red;
            }

            Widget pieceWidget = Container();
            for (var piece in plateau.plateau.expand((e) => e)) {
              if (piece != null &&
                  piece.positionY == row &&
                  piece.positionX == col) {
                pieceWidget = Center(
                  child: Image.asset(piece.path,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1),
                );
                break;
              }
            }
            return GestureDetector(
              onTap: () {
                if (selectedPiece == null) {
                  selectionnerPiece(col, row);
                } else {
                  if (possibleMoves.contains(index)) {
                    deplacerPiece(col, row);
                  } else {
                    selectionnerPiece(col, row);
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.all(2),
                color: color,
                child: pieceWidget,
              ),
            );
          },
        ),
      ),
    );
  }

  void selectionnerPiece(int x, int y) {
    if (plateau.ConditionJeu) {
      setState(() {
        selectedPiece = plateau.plateau[y][x];
        if (selectedPiece != null &&
            selectedPiece!.couleur == plateau.tourActuel) {
          possibleMoves = selectedPiece!.checkDeplacement(plateau, true);
        } else {
          deselectionnerPiece();
        }
      });
    }
  }

  void deselectionnerPiece() {
    setState(() {
      selectedPiece = null;
      possibleMoves = [];
    });
  }

  void afficherPopupCheckmate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fin de partie"),
          content: Text(
              "Échec et Mat : Le joueur ${plateau.tourActuel} a perdu. Dommage !"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void afficherPopupPat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Egalité"),
          content: Text("Egalité : un pat a eu lieu !"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void afficherPopupNul() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Egalité"),
          content: Text("Egalité : un match nul a eu lieu !"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void afficherPopupTimer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fin de partie"),
          content: Text(
              "Fin du temps : Le joueur ${plateau.tourActuel} a perdu. Dommage !"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showPromotionDialog(
      BuildContext context, Piece? selectedPiece, int newX, int newY) {
    int dame = -1, tour = -1, fou = -1, cavalier = -1;

    for (int i = 0; i < plateau.piecesMortes.length; i++) {
      if (plateau.piecesMortes[i].nom == "Dame" &&
          plateau.piecesMortes[i].couleur == plateau.tourActuel) {
        dame = i;
      }
      if (plateau.piecesMortes[i].nom == "Tour" &&
          plateau.piecesMortes[i].couleur == plateau.tourActuel) {
        tour = i;
      }
      if (plateau.piecesMortes[i].nom == "Fou" &&
          plateau.piecesMortes[i].couleur == plateau.tourActuel) {
        fou = i;
      }
      if (plateau.piecesMortes[i].nom == "Cavalier" &&
          plateau.piecesMortes[i].couleur == plateau.tourActuel) {
        cavalier = i;
      }
    }

    if (dame == -1 && tour == -1 && fou == -1 && cavalier == -1) {
      return;
    }
    plateau.piecesMortes.add(selectedPiece!);
    String couleur = plateau.tourActuel == "Blanc" ? "white" : "black";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Promotion de pièce"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Choisissez parmi :"),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  if (dame != -1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "Dame");
                        setState(() {
                          plateau.piecesMortes
                              .remove(plateau.piecesMortes.elementAt(dame));
                          plateau.plateau[newY][newX] =
                              selectedPiece.promotionPiece("Dame", plateau);
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset("${plateau.path}$couleur-queen.png",
                              width: 40, height: 40),
                          Text("Dame"),
                        ],
                      ),
                    ),
                  if (tour != -1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "Tour");
                        setState(() {
                          plateau.piecesMortes
                              .remove(plateau.piecesMortes.elementAt(tour));
                          plateau.plateau[newY][newX] =
                              selectedPiece.promotionPiece("Tour", plateau);
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset("${plateau.path}$couleur-rook.png",
                              width: 40, height: 40),
                          Text("Tour"),
                        ],
                      ),
                    ),
                  if (fou != -1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "Fou");
                        setState(() {
                          plateau.piecesMortes
                              .remove(plateau.piecesMortes.elementAt(fou));
                          plateau.plateau[newY][newX] =
                              selectedPiece.promotionPiece("Fou", plateau);
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset("${plateau.path}$couleur-bishop.png",
                              width: 40, height: 40),
                          Text("Fou"),
                        ],
                      ),
                    ),
                  if (cavalier != -1)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, "Cavalier");
                        setState(() {
                          plateau.piecesMortes
                              .remove(plateau.piecesMortes.elementAt(cavalier));
                          plateau.plateau[newY][newX] = selectedPiece
                              .promotionPiece("Cavalier", plateau);
                        });
                      },
                      child: Column(
                        children: [
                          Image.asset("${plateau.path}$couleur-knight.png",
                              width: 40, height: 40),
                          Text("Cavalier"),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void deplacerPiece(int newX, int newY) async {
    if (selectedPiece != null && selectedPiece!.couleur == plateau.tourActuel) {
      await selectedPiece!.deplacement(newX, newY, plateau, database);
      bool condNul = await plateau.nul(database);
      int PionValue = plateau.tourActuel == "Blanc" ? 0 : 7;

      if (selectedPiece!.nom == "Pion" && newY == PionValue) {
        showPromotionDialog(context, selectedPiece, newX, newY);
      }
      setState(() {
        plateau.alternerTour();
        deselectionnerPiece();
        if (plateau.echec(plateau.tourActuel)) {
          if (plateau.echecEtMat(plateau.tourActuel)) {
            plateau.ConditionJeu = false;
            plateau.timerB.stop();
            plateau.timerN.stop();
            afficherPopupCheckmate();
          }
        } else if (plateau.pat(plateau.tourActuel)) {
          afficherPopupPat();
          plateau.ConditionJeu = false;
          plateau.timerB.stop();
          plateau.timerN.stop();
        }
        if (condNul) {
          afficherPopupNul();
          plateau.ConditionJeu = false;
          plateau.timerB.stop();
          plateau.timerN.stop();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Démarre un thread qui vérifie les timers toutes les secondes
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return false;
      if (plateau.timerB.getMinutes() == 0 &&
          plateau.timerB.getSeconds() == 0) {
        endTimer("blanc");
        return false;
      }
      if (plateau.timerN.getMinutes() == 0 &&
          plateau.timerN.getSeconds() == 0) {
        endTimer("noir");
        return false;
      }
      return true;
    });
  }

  void endTimer(String color) {
    if (color == "blanc") {
      plateau.timerB.stop();
      plateau.tourActuel = "Blanc";
      afficherPopupTimer();
      plateau.ConditionJeu = false;
    } else {
      plateau.timerN.stop();
      plateau.tourActuel = "Noir";
      afficherPopupTimer();
      plateau.ConditionJeu = false;
    }
  }
}
