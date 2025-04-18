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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }


  Future<void> _carregarClientes() async {
    try {
      await _controller.carregarClientes();
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

  @override
  Widget build(BuildContext context) {
    Color azul = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Visualizar Clientes'),
          ],
        ),
        backgroundColor: azul,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Exibe o indicador de carregamento durante o carregamento
          : _controller.clientes.isEmpty
              ? const Center(child: Text('Nenhum cliente cadastrado.')) // Mensagem caso a lista de clientes esteja vazia
              : ListView.builder(
                  itemCount: _controller.clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = _controller.clientes[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(cliente.nome),
                        subtitle: Text(
                          'Tipo: ${cliente.tipo == "PF" ? "Pessoa Física" : "Pessoa Jurídica"} - CPF/CNPJ: ${cliente.cpfCnpj}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit, color: azul),
                                onPressed: () {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TelaEdicaoCliente(cliente: cliente), // Passando o cliente selecionado
                                    ),
                                    );
                                },
                                ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                // A lógica para remover o cliente
                                await _controller.remover(cliente.id);
                                _carregarClientes(); // Recarregar a lista após remoção
                              },
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
