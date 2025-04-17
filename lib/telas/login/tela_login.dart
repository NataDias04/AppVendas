import 'package:flutter/material.dart';
import '../login/login_controller.dart';
import '../../modelos/usuario.dart';

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

    final usuarioLogado = await _loginController.autenticar(nome, senha);

    if (usuarioLogado != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: usuarioLogado,
      );
    } else {
      setState(() {
        _mensagemErro = 'Usuário ou senha inválidos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final azulPrincipal = Colors.blue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: azulPrincipal,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome de usuário',
                  labelStyle: const TextStyle(color: Colors.black),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: azulPrincipal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: const TextStyle(color: Colors.black),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: azulPrincipal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _tentarLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulPrincipal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_mensagemErro.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
