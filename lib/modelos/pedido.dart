class Pedido {
  int id;
  int idCliente;
  int idUsuario;
  double total;
  DateTime dataCriacao;
  List<PedidoItem> itens;
  List<PedidoPagamento> pagamentos;

  Pedido({
    required this.id,
    required this.idCliente,
    required this.idUsuario,
    required this.total,
    required this.dataCriacao,
    required this.itens,
    required this.pagamentos,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'idCliente': idCliente,
        'idUsuario': idUsuario,
        'total': total,
        'dataCriacao': dataCriacao.toIso8601String(),
        'itens': itens.map((e) => e.toJson()).toList(),
        'pagamentos': pagamentos.map((e) => e.toJson()).toList(),
      };

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json['id'],
        idCliente: json['idCliente'],
        idUsuario: json['idUsuario'],
        total: (json['total'] ?? 0).toDouble(),
        dataCriacao: DateTime.parse(json['dataCriacao']),
        itens: (json['itens'] as List)
            .map((e) => PedidoItem.fromJson(e))
            .toList(),
        pagamentos: (json['pagamentos'] as List)
            .map((e) => PedidoPagamento.fromJson(e))
            .toList(),
      );
}

class PedidoItem {
  int id;
  int idPedido;
  int idProduto;
  double quantidade;
  double totalItem;

  PedidoItem({
    required this.id,
    required this.idPedido,
    required this.idProduto,
    required this.quantidade,
    required this.totalItem,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'idPedido': idPedido,
        'idProduto': idProduto,
        'quantidade': quantidade,
        'totalItem': totalItem,
      };

  factory PedidoItem.fromJson(Map<String, dynamic> json) => PedidoItem(
        id: json['id'],
        idPedido: json['idPedido'],
        idProduto: json['idProduto'],
        quantidade: (json['quantidade'] ?? 0).toDouble(),
        totalItem: (json['totalItem'] ?? 0).toDouble(),
      );
}

class PedidoPagamento {
  int id;
  int idPedido;
  double valorPagamento;

  PedidoPagamento({
    required this.id,
    required this.idPedido,
    required this.valorPagamento,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'idPedido': idPedido,
        'valorPagamento': valorPagamento,
      };

  factory PedidoPagamento.fromJson(Map<String, dynamic> json) =>
      PedidoPagamento(
        id: json['id'],
        idPedido: json['idPedido'],
        valorPagamento: (json['valorPagamento'] ?? 0).toDouble(),
      );
}
