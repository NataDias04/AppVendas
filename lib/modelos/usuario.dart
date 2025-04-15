class Usuario {
  final int id;
  final String nome;
  final String senha;
  final String perfil;

  Usuario({
    required this.id,
    required this.nome,
    required this.senha,
    required this.perfil,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      senha: json['senha'],
      perfil: json['perfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
      'perfil': perfil,
    };
  }
}
