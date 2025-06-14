import 'pedido_item.dart';
import 'pedido_pagamento.dart';

class Pedido {
  int id;
  int idCliente;
  int idUsuario;
  double totalPedido;
  DateTime dataCriacao;
  List<PedidoItem> itens;
  List<PedidoPagamento> pagamento;

  Pedido({
    required this.id,
    required this.idCliente,
    required this.idUsuario,
    required this.totalPedido,
    required this.dataCriacao,
    required this.itens,
    required this.pagamento,
  });

  /// Para salvar no banco (somente os dados da tabela 'pedido')
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCliente': idCliente,
      'idUsuario': idUsuario,
      'totalPedido': totalPedido,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  /// Para ler do banco (somente os dados da tabela 'pedido')
  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      idCliente: map['idCliente'],
      idUsuario: map['idUsuario'],
      totalPedido: map['totalPedido'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      itens: [], // Será preenchido depois com consulta separada
      pagamento: [], // Será preenchido depois com consulta separada
    );
  }
}