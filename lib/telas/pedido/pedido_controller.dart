import 'dart:convert';
import '../../modelos/pedido.dart';
import '../../utilitarios/persistencia_json.dart';

class PedidoController {
  final String _nomeArquivo = 'pedido.json';
  List<Pedido> pedidos = [];

  PedidoController() {
    carregarPedidos();
  }

  Future<void> carregarPedidos() async {
    try {
      final conteudo = await ArquivoHelper.lerArquivo(_nomeArquivo);
      if (conteudo.isNotEmpty) {
        final List<dynamic> jsonData = jsonDecode(conteudo);
        pedidos = jsonData.map((item) => Pedido.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar pedidos: $e');
    }
  }

  Future<void> salvarPedidos() async {
    try {
      final jsonData = jsonEncode(pedidos.map((p) => p.toJson()).toList());
      await ArquivoHelper.salvarArquivo(_nomeArquivo, jsonData);
    } catch (e) {
      print('Erro ao salvar pedidos: $e');
    }
  }

  Future<void> adicionar(Pedido pedido) async {
    pedidos.add(pedido);
    await salvarPedidos();
    final jsonSalvo = await ArquivoHelper.lerArquivo(_nomeArquivo);
    print('JSON salvo:\n$jsonSalvo');
  }

  Future<void> atualizar(Pedido pedidoAtualizado) async {
    final index = pedidos.indexWhere((pedido) => pedido.id == pedidoAtualizado.id);
    if (index != -1) {
      pedidos[index] = pedidoAtualizado;
      await salvarPedidos();
    }
  }

  Future<void> remover(int id) async {
    pedidos.removeWhere((pedido) => pedido.id == id);
    await salvarPedidos();
  }
}
