class PedidoPagamento {
  int idPedido;
  int id;
  double valorPagamento;

  PedidoPagamento({
    required this.idPedido,
    required this.id,
    required this.valorPagamento,
  });

  factory PedidoPagamento.fromJson(Map<String, dynamic> json) {
    return PedidoPagamento(
      idPedido: json['idPedido'],
      id: json['id'],
      valorPagamento: (json['valorPagamento'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPedido': idPedido,
      'id': id,
      'valorPagamento': valorPagamento,
    };
  }
}
