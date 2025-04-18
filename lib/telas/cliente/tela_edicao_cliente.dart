import 'package:flutter/material.dart';
import '../../modelos/cliente.dart';
import 'cliente_controller.dart';

class TelaEdicaoCliente extends StatefulWidget {
  final Cliente cliente;

  const TelaEdicaoCliente({super.key, required this.cliente});

  @override
  _TelaEdicaoClienteState createState() => _TelaEdicaoClienteState();
}

class _TelaEdicaoClienteState extends State<TelaEdicaoCliente> {
  late TextEditingController _nomeController;
  late TextEditingController _cpfCnpjController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _cepController;
  late TextEditingController _enderecoController;
  late TextEditingController _bairroController;
  late TextEditingController _cidadeController;
  late TextEditingController _ufController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.cliente.nome);
    _cpfCnpjController = TextEditingController(text: widget.cliente.cpfCnpj);
    _emailController = TextEditingController(text: widget.cliente.email);
    _telefoneController = TextEditingController(text: widget.cliente.telefone);
    _cepController = TextEditingController(text: widget.cliente.cep);
    _enderecoController = TextEditingController(text: widget.cliente.endereco);
    _bairroController = TextEditingController(text: widget.cliente.bairro);
    _cidadeController = TextEditingController(text: widget.cliente.cidade);
    _ufController = TextEditingController(text: widget.cliente.uf);
  }

  void _salvarEdicao() async {
    final clienteEditado = Cliente(
      id: widget.cliente.id,
      nome: _nomeController.text,
      tipo: widget.cliente.tipo,
      cpfCnpj: _cpfCnpjController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      cep: _cepController.text,
      endereco: _enderecoController.text,
      bairro: _bairroController.text,
      cidade: _cidadeController.text,
      uf: _ufController.text,
    );

    try {
      await ClienteController().atualizar(clienteEditado);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar cliente: $e')),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cliente'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _cpfCnpjController, decoration: const InputDecoration(labelText: 'CPF/CNPJ')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail')),
            TextField(controller: _telefoneController, decoration: const InputDecoration(labelText: 'Telefone')),
            TextField(controller: _cepController, decoration: const InputDecoration(labelText: 'CEP')),
            TextField(controller: _enderecoController, decoration: const InputDecoration(labelText: 'Endereço')),
            TextField(controller: _bairroController, decoration: const InputDecoration(labelText: 'Bairro')),
            TextField(controller: _cidadeController, decoration: const InputDecoration(labelText: 'Cidade')),
            TextField(controller: _ufController, decoration: const InputDecoration(labelText: 'UF')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarEdicao,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
