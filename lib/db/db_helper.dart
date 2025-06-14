import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _dbName = 'app_vendas.db';
  static const _dbVersion = 1;

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
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
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Aqui você pode rodar alterações de versão futura
    // Exemplo:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE produto ADD COLUMN nova_coluna TEXT');
    // }
  }
}
