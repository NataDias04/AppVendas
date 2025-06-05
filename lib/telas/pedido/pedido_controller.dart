import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../modelos/pedido.dart';

class PedidoController {
  List<Pedido> listaPedidos = [];

  Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/pedidos.json";
  }

  Future<void> carregarPedidos() async {
    final file = File(await _getFilePath());
    if (await file.exists()) {
      final data = await file.readAsString();
      final decoded = json.decode(data) as List;
      listaPedidos = decoded.map((e) => Pedido.fromJson(e)).toList();
    }
  }

  Future<void> salvarPedidos() async {
    final file = File(await _getFilePath());
    final data = json.encode(listaPedidos.map((e) => e.toJson()).toList());
    await file.writeAsString(data);
  }

  void adicionar(Pedido pedido) {
    listaPedidos.add(pedido);
    salvarPedidos();
  }

  void atualizar(Pedido pedido) {
    final index = listaPedidos.indexWhere((e) => e.id == pedido.id);
    if (index != -1) {
      listaPedidos[index] = pedido;
      salvarPedidos();
    }
  }

  void excluir(int id) {
    listaPedidos.removeWhere((e) => e.id == id);
    salvarPedidos();
  }
}
