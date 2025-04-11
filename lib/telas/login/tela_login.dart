import 'package:flutter/material.dart';
import '../login/login_controller.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final LoginController _loginController = LoginController();

  String _mensagemErro = '';

  void _tentarLogin() async {
    final nome = _nomeController.text;
    final senha = _senhaController.text;

    final sucesso = await _loginController.autenticar(nome, senha);
    if (sucesso) {
      // Navegar para a tela principal (exemplo)
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _mensagemErro = 'Usuário ou senha inválidos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome de usuário'),
            ),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _tentarLogin, child: Text('Entrar')),
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
