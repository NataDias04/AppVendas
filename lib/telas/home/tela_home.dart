import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';

class TelaHome extends StatelessWidget {
  final Usuario usuarioLogado;

  TelaHome({super.key, required this.usuarioLogado});

  @override
  Widget build(BuildContext context) {
    print('Perfil do usuário logado: ${usuarioLogado.perfil}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Menu Principal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          children: [
            if (usuarioLogado.perfil.toLowerCase() == 'admin') _iconeMenu(
              context,
              icon: Icons.person_add,
              label: 'Usuários',
              onTap: () {
                Navigator.pushNamed(context, '/usuarios');
              },
            ),
            _iconeMenu(
              context,
              icon: Icons.people,
              label: 'Clientes',
              onTap: () {
                // Adicionar lógica para clientes
              },
            ),
            _iconeMenu(
              context,
              icon: Icons.inventory,
              label: 'Produtos',
              onTap: () {
                Navigator.pushNamed(context, '/cadastroProduto');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconeMenu(
    BuildContext context, {
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
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
