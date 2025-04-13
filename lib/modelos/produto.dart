class Produto {
  int id;
  String nome;
  String unidade;
  int qtdEstoque;
  double precoVenda;
  int status;
  double custo;
  String codigoBarras;

  Produto({
    required this.id,
    required this.nome,
    required this.unidade,
    required this.qtdEstoque,
    required this.precoVenda,
    required this.status,
    required this.custo,
    required this.codigoBarras,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      unidade: json['unidade'],
      qtdEstoque: json['qtdEstoque'],
      precoVenda: json['precoVenda'],
      status: json['status'],
      custo: json['custo'],
      codigoBarras: json['codigoBarras'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'unidade': unidade,
      'qtdEstoque': qtdEstoque,
      'precoVenda': precoVenda,
      'status': status,
      'custo': custo,
      'codigoBarras': codigoBarras,
    };
  }
}
