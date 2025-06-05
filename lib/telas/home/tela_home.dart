import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';
import 'package:seu_app/telas/pedido/tela_lista_pedidos.dart';
import 'package:seu_app/telas/pedido/tela_pedido.dart';

class TelaHome extends StatelessWidget {
  final Usuario usuarioLogado;

  const TelaHome({super.key, required this.usuarioLogado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo, ${usuarioLogado.nome}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          children: [
            if (usuarioLogado.perfil.toLowerCase() == 'admin')
              _iconeMenu(
                icon: Icons.person_add,
                label: 'Usuários',
                onTap: () {
                  Navigator.pushNamed(context, '/usuarios');
                },
              ),
            if (usuarioLogado.perfil.toLowerCase() == 'admin')
              _iconeMenu(
                icon: Icons.add_business,
                label: 'Cadastrar Cliente',
                onTap: () {
                  Navigator.pushNamed(context, '/cadastroCliente');
                },
              ),
            _iconeMenu(
              icon: Icons.people,
              label: 'Clientes',
              onTap: () {
                Navigator.pushNamed(context, '/visualizarcliente');
              },
            ),
            _iconeMenu(
              icon: Icons.inventory,
              label: 'Produtos',
              onTap: () {
                Navigator.pushNamed(context, '/cadastroProduto');
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Cadastrar Pedido'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaCadastroPedido(),
                  ),
                );
              },
            ),

            // ✅ Botão Listar Pedidos
            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text('Pedidos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaListaPedidos(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _iconeMenu({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
