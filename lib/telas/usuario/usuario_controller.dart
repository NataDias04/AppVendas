import 'dart:convert';
import '../../modelos/usuario.dart';
import '../../utilitarios/persistencia_json.dart';

class UsuarioController {
  final String _nomeArquivo = 'usuarios.json';
  List<Usuario> usuarios = [];

  UsuarioController() {
    carregarUsuarios();
  }

  Future<void> carregarUsuarios() async {
    try {
      final conteudo = await ArquivoHelper.lerArquivo(_nomeArquivo);
      if (conteudo.isNotEmpty) {
        final List<dynamic> jsonData = jsonDecode(conteudo);
        usuarios = jsonData.map((item) => Usuario.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar usuários: $e');
    }
  }

  Future<void> salvarUsuarios() async {
    try {
      final jsonData = jsonEncode(usuarios.map((u) => u.toJson()).toList());
      await ArquivoHelper.salvarArquivo(_nomeArquivo, jsonData);
    } catch (e) {
      print('Erro ao salvar usuários: $e');
    }
  }

  Future<void> adicionar(Usuario usuario) async {
    usuarios.add(usuario);
    await salvarUsuarios();
  }

  Future<void> atualizar(Usuario usuarioAtualizado) async {
    final index = usuarios.indexWhere((usuario) => usuario.id == usuarioAtualizado.id);
    if (index != -1) {
      usuarios[index] = usuarioAtualizado;
      await salvarUsuarios();
    }
  }

  Future<void> remover(int id) async {
    usuarios.removeWhere((usuario) => usuario.id == id);
    await salvarUsuarios();
  }
}
