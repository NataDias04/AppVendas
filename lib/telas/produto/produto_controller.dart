import 'dart:convert';
import 'dart:io';
import '../../modelos/produto.dart';
import '../../utilitarios/persistencia_json.dart';

class ProdutoController {
  final String _nomeArquivo = 'produto.json';
  List<Produto> produtos = [];

  ProdutoController() {
    carregarProdutos();
  }

  Future<void> carregarProdutos() async {
    try {
      final conteudo = await ArquivoHelper.lerArquivo(_nomeArquivo);
      if (conteudo.isNotEmpty) {
        final List<dynamic> jsonData = jsonDecode(conteudo);
        produtos = jsonData.map((item) => Produto.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  Future<void> salvarProdutos() async {
    try {
      final jsonData = jsonEncode(produtos.map((p) => p.toJson()).toList());
      await ArquivoHelper.salvarArquivo(_nomeArquivo, jsonData);
    } catch (e) {
      print('Erro ao salvar produtos: $e');
    }
  }

  Future<void> adicionar(Produto produto) async {
    produtos.add(produto);
    await salvarProdutos();
    final jsonSalvo = await ArquivoHelper.lerArquivo('produto.json');
    print('JSON salvo:\n$jsonSalvo');
  }

  Future<void> atualizar(Produto produtoAtualizado) async {
    final index = produtos.indexWhere((produto) => produto.id == produtoAtualizado.id);
    if (index != -1) {
      produtos[index] = produtoAtualizado;
      await salvarProdutos();
    }
  }

  Future<void> remover(int id) async {
    produtos.removeWhere((produto) => produto.id == id);
    await salvarProdutos();
  }
}
