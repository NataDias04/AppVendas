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
      dataCriacao: json['dataCriacao'],
      itens: json['itens'],
      pagamento: json['pagamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCliente': idCliente,
      'idUsuario': idUsuario,
      'totalPedido': totalPedido,
      'dataCriacao': dataCriacao,
      'itens': itens,
      'pagamento': pagamento,
    };
  }
}
