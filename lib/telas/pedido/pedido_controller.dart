import 'package:sqflite/sqflite.dart';
import '../../modelos/pedido.dart';
import '../../db/db_helper.dart';

class PedidoController {
  List<Pedido> pedidos = [];

  Future<Database> get database async {
    return await DatabaseHelper.getDatabase();
  }

  Future<void> carregarPedidos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pedido');
    pedidos = maps.map((map) => Pedido.fromMap(map)).toList();
  }

  Future<void> adicionar(Pedido pedido) async {
    final db = await database;
    await db.insert('pedido', pedido.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await carregarPedidos();
  }

  Future<void> atualizar(Pedido pedidoAtualizado) async {
    final db = await database;
    await db.update(
      'pedido',
      pedidoAtualizado.toMap(),
      where: 'id = ?',
      whereArgs: [pedidoAtualizado.id],
    );
    await carregarPedidos();
  }

  Future<void> remover(int id) async {
    final db = await database;
    await db.delete('pedido', where: 'id = ?', whereArgs: [id]);
    await carregarPedidos();
  }

  Future<List<Pedido>> listarTodos() async {
    await carregarPedidos();
    return pedidos;
  }
}
