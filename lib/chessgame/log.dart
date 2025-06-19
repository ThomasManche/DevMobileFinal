import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Log {
  final String piece;
  final int x;
  final int y;
  final int newX;
  final int newY;
  final int pieceCapturee;
  final String pieceCaptureePiece;
  final String couleur;
  final int timerB;
  final int timerN;
  final String turn;

  var database;

  Future<Database> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'chess_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE log (piece TEXT, x INTEGER, y INTEGER, newX INTEGER, newY INTEGER, pieceCapturee INTEGER, pieceCaptureePiece TEXT, couleur TEXT, timerB INT, timerN INT, turn TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> resetDatabase() async {
    final db =
        await database; // Assurez-vous que la variable `database` est initialisée
    await db.execute("DROP TABLE IF EXISTS log");
    // Recréation de la table après la suppression
    await db.execute(
      "CREATE TABLE log (piece TEXT, x INTEGER, y INTEGER, newX INTEGER, newY INTEGER, pieceCapturee INTEGER, pieceCaptureePiece TEXT, couleur TEXT, timerB INT, timerN INT, turn TEXT)",
    );
  }

  @override
  String toString() {
    return 'Log{piece: $piece, x: $x, y: $y, newX: $newX, newY: $newY, pieceCapturee: $pieceCapturee, pieceCaptureePiece: $pieceCaptureePiece, couleur: $couleur, timerB: $timerB, timerN: $timerN, turn: $turn}';
  }

  Future<void> insertLog(Log log) async {
    final db = await database;
    await db.insert(
      'log',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> createSave() async{
    final db = await database;
    db.execute("DROP TABLE IF EXISTS save");
    db.execute(
    "CREATE TABLE IF NOT EXISTS save (piece TEXT, x INTEGER, y INTEGER, newX INTEGER, newY INTEGER, pieceCapturee INTEGER, pieceCaptureePiece TEXT, couleur TEXT, timerB INT, timerN INT, turn TEXT)");

  }
  Future<void> insertSave(Log log) async {
    final db = await database;
    await db.insert(
      'save',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Log>> getLogs() async {
    final db = await database;
    final List<Map<String, Object?>> logsMaps = await db.query('log');
    return [
      for (final {
            'piece': piece as String,
            'x': x as int,
            'y': y as int,
            'newX': newX as int,
            'newY': newY as int,
            'pieceCapturee': pieceCapturee as int,
            'pieceCaptureePiece': pieceCaptureePiece as String,
            'couleur': couleur as String,
            'timerB': timerB as int,
            'timerN': timerN as int,
            'turn': turn as String
          } in logsMaps)
        Log(
            piece: piece,
            x: x,
            y: y,
            newX: newX,
            newY: newY,
            pieceCapturee: pieceCapturee,
            pieceCaptureePiece: pieceCaptureePiece,
            couleur: couleur,
            timerB: timerB,
            timerN: timerN,
            turn: turn),
    ];
  }

  Future<List<Log>> getSaves() async {
    final db = await database;
    final List<Map<String, Object?>> logsMaps = await db.query('save');
    return [
      for (final {
            'piece': piece as String,
            'x': x as int,
            'y': y as int,
            'newX': newX as int,
            'newY': newY as int,
            'pieceCapturee': pieceCapturee as int,
            'pieceCaptureePiece': pieceCaptureePiece as String,
            'couleur': couleur as String,
            'timerB': timerB as int,
            'timerN': timerN as int,
            'turn': turn as String
          } in logsMaps)
        Log(
            piece: piece,
            x: x,
            y: y,
            newX: newX,
            newY: newY,
            pieceCapturee: pieceCapturee,
            pieceCaptureePiece: pieceCaptureePiece,
            couleur: couleur,
            timerB: timerB,
            timerN: timerN,
            turn: turn),
    ];
  }

  Log(
      {required this.piece,
      required this.x,
      required this.y,
      required this.newX,
      required this.newY,
      required this.pieceCapturee,
      required this.pieceCaptureePiece,
      required this.couleur,
      required this.timerB,
      required this.timerN,
      required this.turn}) {
    database = main();
  }

  Map<String, Object?> toMap() {
    return {
      'piece': piece,
      'x': x,
      'y': y,
      'newX': newX,
      'newY': newY,
      'pieceCapturee': pieceCapturee,
      'pieceCaptureePiece': pieceCaptureePiece,
      'couleur': couleur,
      'timerB': timerB,
      'timerN': timerN,
      'turn': turn,
    };
  }

  // Fonction de suppression basée sur les critères spécifiques (ex: pièce, coordonnées, etc.)
  Future<void> deleteLogEntry(
      String piece, int x, int y, int newX, int newY) async {
    final db = await database;
    await db.delete(
      'log',
      where:
          'piece = ? AND x = ? AND y = ? AND newX = ? AND newY = ?', // Condition pour identifier la ligne
      whereArgs: [piece, x, y, newX, newY], // Arguments pour la condition
    );
  }

  Future<Log> getLog(int i) async {
    final logs = await getLogs();
    final log =
        logs[i - 1]; // Récupère le log à la position i (en partant de 1)
    return log;
  }
}
