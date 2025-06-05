import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';
import '../../modelos/produto.dart';

class TelaAdicionarItem extends StatefulWidget {
  final List<Produto> produtos;

  const TelaAdicionarItem({super.key, required this.produtos});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  int? idProduto;
  double quantidade = 1;
  double preco = 0;
  double totalItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Item')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Produto'),
              items: widget.produtos
                  .map((p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.nome),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  idProduto = value;
                  final produto = widget.produtos
                      .firstWhere((element) => element.id == value);
                  preco = produto.precoVenda;
                  calcularTotal();
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
              initialValue: quantidade.toString(),
              onChanged: (value) {
                quantidade = double.tryParse(value) ?? 1;
                calcularTotal();
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Total do Item: R\$ ${totalItem.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (idProduto == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecione um produto')));
                  return;
                }
                final item = PedidoItem(
                  idPedido: 0, // Será atribuído depois
                  id: DateTime.now().millisecondsSinceEpoch,
                  idProduto: idProduto!,
                  quantidade: quantidade,
                  totalItem: totalItem,
                );
                Navigator.pop(context, item);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  void calcularTotal() {
    setState(() {
      totalItem = quantidade * preco;
    });
  }
}
