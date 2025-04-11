import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ArquivoHelper {
  static Future<String> _getPath(String nomeArquivo) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$nomeArquivo';
  }

  static Future<String> lerArquivo(String nomeArquivo) async {
    try {
      final path = await _getPath(nomeArquivo);
      final arquivo = File(path);
      if (await arquivo.exists()) {
        return await arquivo.readAsString();
      }
    } catch (_) {}
    return '';
  }

  static Future<void> salvarArquivo(String nomeArquivo, String conteudo) async {
    final path = await _getPath(nomeArquivo);
    final arquivo = File(path);
    await arquivo.writeAsString(conteudo);
  }
}
