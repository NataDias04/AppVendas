import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_vendas.db'); // Banco único

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE produto (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            unidade TEXT,
            qtdEstoque INTEGER,
            precoVenda REAL NOT NULL,
            status INTEGER,
            custo REAL NOT NULL,
            codigoBarras TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE cliente (
            id INTEGER PRIMARY KEY,
            nome TEXT NOT NULL,
            tipo TEXT,
            cpfCnpj TEXT,
            email TEXT,
            telefone TEXT,
            cep TEXT,
            endereco TEXT,
            bairro TEXT,
            cidade TEXT,
            uf TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pedido (
            id INTEGER PRIMARY KEY,
            idCliente INTEGER,
            idUsuario INTEGER,
            totalPedido REAL,
            dataCriacao TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pedido_item (
            id INTEGER PRIMARY KEY,
            idPedido INTEGER,
            idProduto INTEGER,
            quantidade REAL,
            totalItem REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE pedido_pagamento (
            id INTEGER PRIMARY KEY,
            idPedido INTEGER,
            valorPagamento REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE usuario (
            id INTEGER PRIMARY KEY,
            nome TEXT,
            senha TEXT
          )
        ''');
      },
    );

    return _database!;
  }
}
