import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';

class TelaAdicionarPagamento extends StatefulWidget {
  final double totalPedido;

  const TelaAdicionarPagamento({super.key, required this.totalPedido});

  @override
  State<TelaAdicionarPagamento> createState() =>
      _TelaAdicionarPagamentoState();
}

class _TelaAdicionarPagamentoState extends State<TelaAdicionarPagamento> {
  double valorPagamento = 0;

  @override
  void initState() {
    super.initState();
    valorPagamento = widget.totalPedido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Valor do Pagamento'),
              keyboardType: TextInputType.number,
              initialValue: valorPagamento.toString(),
              onChanged: (value) {
                valorPagamento = double.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (valorPagamento <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Informe um valor válido')));
                  return;
                }
                final pagamento = PedidoPagamento(
                  idPedido: 0, // Será atribuído depois
                  id: DateTime.now().millisecondsSinceEpoch,
                  valorPagamento: valorPagamento,
                );
                Navigator.pop(context, pagamento);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
