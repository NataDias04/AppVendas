import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'telas/login/tela_login.dart';
import 'telas/home/tela_home.dart';
import 'telas/produto/tela_produto.dart';
import 'telas/usuario/tela_usuario.dart';
import 'telas/cliente/tela_cliente.dart';
import 'modelos/usuario.dart';
import 'telas/cliente/tela_visualizar_cliente.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await verConteudoJSON();
  runApp(const MyApp());
}

Future<void> verConteudoJSON() async {
  final diretorio = await getApplicationDocumentsDirectory();
  final caminho = '${diretorio.path}/usuarios.json';
  final file = File(caminho);

  if (await file.exists()) {
    final conteudo = await file.readAsString();
    print('📄 Conteúdo do JSON:');
    print(conteudo);
  } else {
    print('❌ Arquivo não encontrado em: $caminho');
  }
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
        '/cadastroCliente': (context) => const TelaCadastroCliente(),
        '/visualizarcliente': (context) => const VisualizarCliente(),
      },
    );
  }
}
