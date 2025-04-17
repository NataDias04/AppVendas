import 'package:flutter/material.dart';
import 'telas/login/tela_login.dart';
import 'telas/home/tela_home.dart';
import 'telas/produto/tela_produto.dart';
import 'telas/usuario/tela_usuario.dart';
import 'telas/cliente/tela_cliente.dart';  // Importando a nova tela de cadastro de cliente
import 'modelos/usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const TelaLogin(),
        '/home': (context) {
          final usuarioLogado = ModalRoute.of(context)?.settings.arguments as Usuario;
          return TelaHome(usuarioLogado: usuarioLogado);
        },
        '/cadastroProduto': (context) => const TelaProduto(),
        '/usuarios': (context) => const TelaUsuario(),
        '/cadastroCliente': (context) => const TelaCadastroCliente(), // Adicionando a rota para cadastro de cliente
      },
    );
  }
}
