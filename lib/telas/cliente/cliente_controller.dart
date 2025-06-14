import 'package:sqflite/sqflite.dart';
import '../../modelos/cliente.dart';
import '../../db/db_helper.dart';

class ClienteController {
  List<Cliente> clientes = [];

  Future<Database> get database async {
    return await DatabaseHelper.getDatabase();
  }

  Future<void> carregarClientes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cliente');
    clientes = maps.map((map) => Cliente.fromMap(map)).toList();
  }

  Future<void> adicionar(Cliente cliente) async {
    final db = await database;
    await db.insert('cliente', cliente.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await carregarClientes();
  }

  Future<void> atualizar(Cliente clienteAtualizado) async {
    final db = await database;
    await db.update(
      'cliente',
      clienteAtualizado.toMap(),
      where: 'id = ?',
      whereArgs: [clienteAtualizado.id],
    );
    await carregarClientes();
  }

  Future<void> remover(int id) async {
    final db = await database;
    await db.delete('cliente', where: 'id = ?', whereArgs: [id]);
    await carregarClientes();
  }

  Future<List<Cliente>> listarTodos() async {
    await carregarClientes();
    return clientes;
  }
}
