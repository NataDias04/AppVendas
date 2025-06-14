class Cliente {
  int id;
  String nome;
  String tipo;
  String cpfCnpj;
  String? email;
  String? telefone;
  String? cep;
  String? endereco;
  String? bairro;
  String? cidade;
  String? uf;

  Cliente({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.cpfCnpj,
    this.email,
    this.telefone,
    this.cep,
    this.endereco,
    this.bairro,
    this.cidade,
    this.uf,
  });

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'cpfCnpj': cpfCnpj,
      'email': email,
      'telefone': telefone,
      'cep': cep,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
    };
  }

  /// Ler do SQLite
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      tipo: map['tipo'],
      cpfCnpj: map['cpfCnpj'],
      email: map['email'],
      telefone: map['telefone'],
      cep: map['cep'],
      endereco: map['endereco'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      uf: map['uf'],
    );
  }
}
