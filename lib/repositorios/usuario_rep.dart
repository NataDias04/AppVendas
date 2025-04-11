import 'dart:convert';
import 'dart:io';
import '../modelos/usuario.dart';
import '../utilitarios/persistencia_json.dart';

class UsuarioRepositorio {
  final String _nomeArquivo = 'usuarios.json';

  Future<List<Usuario>> listarUsuarios() async {
    final dados = await ArquivoHelper.lerArquivo(_nomeArquivo);
    if (dados.isEmpty) return [];

    final List lista = json.decode(dados);
    return lista.map((e) => Usuario.fromJson(e)).toList();
  }

  Future<void> salvarUsuarios(List<Usuario> usuarios) async {
    final jsonString = json.encode(usuarios.map((e) => e.toJson()).toList());
    await ArquivoHelper.salvarArquivo(_nomeArquivo, jsonString);
  }
}
