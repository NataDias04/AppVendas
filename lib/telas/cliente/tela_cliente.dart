import 'package:flutter/material.dart';
import '../../modelos/cliente.dart';
import 'cliente_controller.dart';
import 'cep_service.dart';

class TelaCadastroCliente extends StatefulWidget {
  const TelaCadastroCliente({super.key});

  @override
  State<TelaCadastroCliente> createState() => _TelaCadastroClienteState();
}

class _TelaCadastroClienteState extends State<TelaCadastroCliente> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();

  String _mensagemErro = '';
  String _mensagemAcerto = '';

  final ClienteController _clienteController = ClienteController();

  bool _isCpfCnpjValido(String cpfCnpj) {
    return cpfCnpj.length == 11 || cpfCnpj.length == 14;
  }

  bool _isEmailValido(String email) {
    return email.contains('@');
  }

  bool _isTelefoneValido(String telefone) {
    return telefone.length == 11;
  }

  void _cadastrarCliente() async {
    final nome = _nomeController.text;
    final cpfCnpj = _cpfCnpjController.text;
    final email = _emailController.text;
    final telefone = _telefoneController.text;
    final cep = _cepController.text;
    final endereco = _enderecoController.text;
    final bairro = _bairroController.text;
    final cidade = _cidadeController.text;
    final uf = _ufController.text;

    if (nome.isEmpty || cpfCnpj.isEmpty) {
      setState(() {
        _mensagemErro = 'Preencha os campos obrigatórios.';
        _mensagemAcerto = '';
      });
      return;
    }

    if (!_isCpfCnpjValido(cpfCnpj)) {
      setState(() {
        _mensagemErro = 'CPF ou CNPJ inválido.';
        _mensagemAcerto = '';
      });
      return;
      
    }
    if (email.isNotEmpty && !_isEmailValido(email)) {
      setState(() {
        _mensagemErro = 'E-mail inválido.';
        _mensagemAcerto = '';
      });
      return;
    }

    if (!_isTelefoneValido(telefone)) {
      setState(() {
        _mensagemErro = 'Telefone inválido.';
        _mensagemAcerto = '';
      });
      return;
    }

    final novoCliente = Cliente(
      id: DateTime.now().millisecondsSinceEpoch,
      nome: nome,
      tipo: 'comum',
      cpfCnpj: cpfCnpj,
      email: email,
      telefone: telefone,
      cep: cep,
      endereco: endereco,
      bairro: bairro,
      cidade: cidade,
      uf: uf,
    );

    await _clienteController.adicionar(novoCliente);

    setState(() {
      _mensagemAcerto = 'Cliente cadastrado com sucesso!';
      _mensagemErro = '';
    });

    _nomeController.clear();
    _cpfCnpjController.clear();
    _emailController.clear();
    _telefoneController.clear();
    _cepController.clear();
    _enderecoController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _ufController.clear();
  }

  Future<void> _buscarCEP() async {
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP inválido.')));
      return;
    }

    final endereco = await buscarEnderecoPorCEP(cep);
    if (endereco != null) {
      setState(() {
        _enderecoController.text = endereco['logradouro'] ?? '';
        _bairroController.text = endereco['bairro'] ?? '';
        _cidadeController.text = endereco['localidade'] ?? '';
        _ufController.text = endereco['uf'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('CEP não encontrado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cliente'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _campoTexto(_nomeController, 'Nome', obrigatorio: true),
            _campoTexto(_cpfCnpjController, 'CPF/CNPJ', obrigatorio: true),
            _campoTexto(_emailController, 'E-mail', obrigatorio: true),
            _campoTexto(_telefoneController, 'Telefone', obrigatorio: true),
            Row(
              children: [
                Expanded(
                  child: _campoTexto(_cepController, 'CEP', obrigatorio: true),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buscarCEP,
                  child: const Text('Buscar CEP'),
                ),
              ],
            ),
            _campoTexto(_enderecoController, 'Endereço', obrigatorio: true),
            _campoTexto(_bairroController, 'Bairro', obrigatorio: true),
            _campoTexto(_cidadeController, 'Cidade', obrigatorio: true),
            _campoTexto(_ufController, 'UF', obrigatorio: true),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrarCliente,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
              ),
              child: const Text(
                'Cadastrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (_mensagemAcerto.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _mensagemAcerto,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_mensagemErro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _mensagemErro,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(
    TextEditingController controller,
    String label, {
    bool obrigatorio = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${obrigatorio ? " *" : ""}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
