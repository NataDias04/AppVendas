import '../../repositorios/usuario_rep.dart';
import '../../modelos/usuario.dart';

class LoginController {
  final UsuarioRepositorio _repositorio = UsuarioRepositorio();

  Future<Usuario?> autenticar(String nome, String senha) async {
    final usuarios = await _repositorio.listarUsuarios();

    if (usuarios.isEmpty) {
      if (nome == 'admin' && senha == 'admin') {
        return Usuario(
          id: 1,
          nome: 'admin',
          senha: 'admin',
          perfil: 'admin',
          telefone: '00000000000',
          email: 'admin@admin.com',
        );
      }
    }

    for (var usuario in usuarios) {
      if (usuario.nome == nome && usuario.senha == senha) {
        return usuario;
      }
    }

    return null;
  }
}
