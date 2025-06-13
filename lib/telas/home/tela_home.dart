import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

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
            _iconeMenu(
              icon: Icons.inventory,
              label: 'Pedidos',
              onTap: () {
                Navigator.pushNamed(context, '/pedido');
              },
            ),
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
