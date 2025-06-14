import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> initBanco() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String caminho = join(dir.path, 'meubanco.db');

  Database db = await openDatabase(
    caminho,
    version: 1,
    onCreate: (db, versao) {
      db.execute('''
        CREATE TABLE produto (
          id INTEGER PRIMARY KEY,
          nome TEXT,
          preco REAL
        )
      ''');
    },
  );

  print('Banco criado em: $caminho');
}
