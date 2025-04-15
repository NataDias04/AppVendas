import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

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
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String _mensagemErro = '';

  bool _isCpfCnpjValido(String cpfCnpj) {
    // Adicione a lógica para validar o CPF ou CNPJ aqui
    // Exemplo básico de validação (simplesmente verifica se o tamanho é 11 ou 14 caracteres):
    return cpfCnpj.length == 11 || cpfCnpj.length == 14;
  }

  bool _isEmailValido(String email) {
    // Verificação simples para email
    return email.contains('@');
  }

  bool _isTelefoneValido(String telefone) {
    // Verificação simples para telefone (exemplo: tamanho 11)
    return telefone.length == 11;
  }

  void _cadastrarCliente() {
    final nome = _nomeController.text;
    final cpfCnpj = _cpfCnpjController.text;
    final email = _emailController.text;
    final telefone = _telefoneController.text;
    final endereco = _enderecoController.text;
    final bairro = _bairroController.text;
    final cidade = _cidadeController.text;
    final uf = _ufController.text;
    final senha = _senhaController.text;

    if (nome.isEmpty || cpfCnpj.isEmpty || email.isEmpty || telefone.isEmpty || senha.isEmpty) {
      setState(() {
        _mensagemErro = 'Todos os campos obrigatórios devem ser preenchidos.';
      });
      return;
    }

    if (!_isCpfCnpjValido(cpfCnpj)) {
      setState(() {
        _mensagemErro = 'CPF ou CNPJ inválido.';
      });
      return;
    }

    if (!_isEmailValido(email)) {
      setState(() {
        _mensagemErro = 'E-mail inválido.';
      });
      return;
    }

    if (!_isTelefoneValido(telefone)) {
      setState(() {
        _mensagemErro = 'Telefone inválido.';
      });
      return;
    }

    final novoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch,  // Gerando ID único
      nome: nome,
      perfil: 'comum', // Usuário comum por padrão
      senha: senha,
    );

    // Aqui você pode salvar o cliente no banco de dados ou em um arquivo, conforme necessário.
    // Exemplo de navegação após cadastro:
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cliente')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _nomeController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _cpfCnpjController, decoration: const InputDecoration(labelText: 'CPF/CNPJ')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-mail')),
            TextField(controller: _telefoneController, decoration: const InputDecoration(labelText: 'Telefone')),
            TextField(controller: _enderecoController, decoration: const InputDecoration(labelText: 'Endereço')),
            TextField(controller: _bairroController, decoration: const InputDecoration(labelText: 'Bairro')),
            TextField(controller: _cidadeController, decoration: const InputDecoration(labelText: 'Cidade')),
            TextField(controller: _ufController, decoration: const InputDecoration(labelText: 'UF')),
            TextField(controller: _senhaController, obscureText: true, decoration: const InputDecoration(labelText: 'Senha')),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrarCliente,
              child: const Text('Cadastrar'),
            ),
            if (_mensagemErro.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(_mensagemErro, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
