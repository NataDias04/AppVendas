import '../../repositorios/usuario_rep.dart';

class LoginController {
  final UsuarioRepositorio _repositorio = UsuarioRepositorio();

  Future<bool> autenticar(String nome, String senha) async {
    final usuarios = await _repositorio.listarUsuarios();

    // Caso especial: primeiro acesso
    if (usuarios.isEmpty) {
      return nome == 'admin' && senha == 'admin';
    }

    for (var usuario in usuarios) {
      if (usuario.nome == nome && usuario.senha == senha) {
        return true;
      }
    }

    return false;
  }
}
