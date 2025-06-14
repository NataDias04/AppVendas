import 'package:flutter/material.dart';
import 'cliente_controller.dart';
import '../../modelos/cliente.dart';
import 'tela_edicao_cliente.dart';

class VisualizarCliente extends StatefulWidget {
  const VisualizarCliente({super.key});

  @override
  State<VisualizarCliente> createState() => _VisualizarClienteState();
}

class _VisualizarClienteState extends State<VisualizarCliente> {
  final ClienteController _controller = ClienteController();
  List<Cliente> _clientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await _controller.listarTodos();
      setState(() {
        _clientes = clientes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar clientes: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removerCliente(int id) async {
    await _controller.remover(id);
    await _carregarClientes(); // Recarrega a lista após exclusão
  }

  @override
  Widget build(BuildContext context) {
    Color azul = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Visualizar Clientes')),
        backgroundColor: azul,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
              ? const Center(child: Text('Nenhum cliente cadastrado.'))
              : ListView.builder(
                  itemCount: _clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = _clientes[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(cliente.nome),
                        subtitle: Text(
                          'Tipo: ${cliente.tipo == "PF" ? "Pessoa Física" : "Pessoa Jurídica"}\nCPF/CNPJ: ${cliente.cpfCnpj}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: azul),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TelaEdicaoCliente(cliente: cliente),
                                  ),
                                );
                                await _carregarClientes(); // Recarrega após voltar da tela de edição
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async => _removerCliente(cliente.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
