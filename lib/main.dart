import 'package:flutter/material.dart';
import 'telas/login/tela_login.dart';
import 'telas/home/tela_home.dart';
import 'telas/produto/tela_produto.dart';

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
        '/home': (context) => const TelaHome(),
        '/cadastroProduto': (context) => const TelaProduto(),
      },
    );
  }
}