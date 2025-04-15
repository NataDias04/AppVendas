import '../../repositorios/usuario_rep.dart';
import '../../modelos/usuario.dart';

class LoginController {
  final UsuarioRepositorio _repositorio = UsuarioRepositorio();

  Future<Usuario?> autenticar(String nome, String senha) async {
    try {
      final usuarios = await _repositorio.listarUsuarios();

      // Verifica se não há usuários cadastrados
      if (usuarios.isEmpty) {
        if (nome.trim() == 'admin' && senha.trim() == 'admin') {
          return Usuario(
            id: 0,
            nome: 'admin',
            senha: 'admin',
            perfil: 'admin',
          );
        } else {
          return null;
        }
      }

      // Verifica nos usuários cadastrados
      for (var usuario in usuarios) {
        if (usuario.nome == nome && usuario.senha == senha) {
          return usuario;
        }
      }

      return null;
    } catch (e) {
      print('Erro na autenticação: $e');
      return null;
    }
  }
}
