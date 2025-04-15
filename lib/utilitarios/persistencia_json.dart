import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ArquivoHelper {
  static Future<String> _getCaminhoArquivo(String nomeArquivo) async {
    final diretorio = await getApplicationDocumentsDirectory();
    return '${diretorio.path}/$nomeArquivo';
  }

  static Future<String> lerArquivo(String nomeArquivo) async {
    try {
      final caminho = await _getCaminhoArquivo(nomeArquivo);
      final arquivo = File(caminho);
      if (await arquivo.exists()) {
        return arquivo.readAsString();
      }
    } catch (e) {
      print('Erro ao ler arquivo: $e');
    }
    return '';
  }

  static Future<void> salvarArquivo(String nomeArquivo, String conteudo) async {
    try {
      final caminho = await _getCaminhoArquivo(nomeArquivo);
      final arquivo = File(caminho);
      await arquivo.writeAsString(conteudo);
    } catch (e) {
      print('Erro ao salvar arquivo: $e');
    }
  }
}
