class Usuario {
  int id;
  String nome;
  String email;
  String senha;
  String telefone;
  String perfil;  // Usando String

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.perfil,  // Usando String para perfil
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      telefone: json['telefone'],
      perfil: json['perfil'],  // Deve ser String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'perfil': perfil,  // Deve ser String
    };
  }
}
