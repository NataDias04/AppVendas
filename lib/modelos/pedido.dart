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

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      idCliente: json['idCliente'],
      idUsuario: json['idUsuario'],
      totalPedido: json['totalPedido'],
      dataCriacao: DateTime.parse(json['dataCriacao']),
      itens: (json['itens'] as List).map((e) => PedidoItem.fromJson(e)).toList(),
      pagamento: (json['pagamento'] as List).map((e) => PedidoPagamento.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCliente': idCliente,
      'idUsuario': idUsuario,
      'totalPedido': totalPedido,
      'dataCriacao': dataCriacao.toIso8601String(),
      'itens': itens.map((i) => i.toJson()).toList(),
      'pagamento': pagamento.map((p) => p.toJson()).toList(),
    };
  }
}
