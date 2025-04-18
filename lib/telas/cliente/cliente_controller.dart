import 'dart:convert';
import '../../modelos/cliente.dart';
import '../../utilitarios/persistencia_json.dart';

class ClienteController {
  final String _nomeArquivo = 'clientes.json';
  List<Cliente> clientes = [];

  ClienteController();

  Future<void> carregarClientes() async {
    try {
      final conteudo = await ArquivoHelper.lerArquivo(_nomeArquivo);
      if (conteudo.isNotEmpty) {
        final List<dynamic> jsonData = jsonDecode(conteudo);
        clientes = jsonData.map((e) => Cliente.fromJson(e)).toList();
      }
    } catch (e) {
      print('Erro ao carregar clientes: $e');
    }
  }

  Future<void> salvarClientes() async {
    try {
      final jsonData = jsonEncode(clientes.map((c) => c.toJson()).toList());
      print('Salvando JSON: $jsonData');
      await ArquivoHelper.salvarArquivo(_nomeArquivo, jsonData);
    } catch (e) {
      print('Erro ao salvar clientes: $e');
    }
  }

  Future<void> adicionar(Cliente cliente) async {
    await carregarClientes();
    clientes.add(cliente);
    await salvarClientes();
  }

  Future<void> atualizar(Cliente clienteAtualizado) async {
    final index = clientes.indexWhere((c) => c.id == clienteAtualizado.id);
    if (index != -1) {
      clientes[index] = clienteAtualizado;
      await salvarClientes();
    }
  }

  Future<void> remover(int id) async {
    clientes.removeWhere((c) => c.id == id);
    await salvarClientes();
  }
}
