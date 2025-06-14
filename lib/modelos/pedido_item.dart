class PedidoItem {
  int idPedido;
  int id;
  int idProduto;
  double quantidade;
  double totalItem;

  PedidoItem({
    required this.idPedido,
    required this.id,
    required this.idProduto,
    required this.quantidade,
    required this.totalItem,
  });

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      idPedido: json['idPedido'],
      id: json['id'],
      idProduto: json['idProduto'],
      quantidade: (json['quantidade'] as num).toDouble(),
      totalItem: (json['totalItem'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPedido': idPedido,
      'id': id,
      'idProduto': idProduto,
      'quantidade': quantidade,
      'totalItem': totalItem,
    };
  }
}
