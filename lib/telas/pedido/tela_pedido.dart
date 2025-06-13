import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';
import '../../modelos/pedido_item.dart';
import '../../modelos/pedido_pagamento.dart';
import '../../modelos/produto.dart';
import 'pedido_controller.dart';

class TelaCadastroPedido extends StatefulWidget {
  const TelaCadastroPedido({super.key});

  @override
  State<TelaCadastroPedido> createState() => _TelaCadastroPedidoState();
}

class _TelaCadastroPedidoState extends State<TelaCadastroPedido> {
  final PedidoController _pedidoController = PedidoController();
  final List<PedidoItem> _itens = [];
  final List<PedidoPagamento> _pagamentos = [];

  int _idPedido = DateTime.now().millisecondsSinceEpoch;
  int _idCliente = 0; // Você pode adicionar dropdown de clientes se desejar
  int _idUsuario = 1; // Suponha que o usuário logado tenha ID 1
  String _mensagemErro = '';

  double get totalItens =>
      _itens.fold(0.0, (total, item) => total + item.totalItem);

  double get totalPagamentos =>
      _pagamentos.fold(0.0, (total, pag) => total + pag.valorPagamento);

  void _adicionarItem(PedidoItem item) {
    setState(() {
      _itens.add(item);
    });
  }

  void _removerItem(int idItem) {
    setState(() {
      _itens.removeWhere((item) => item.id == idItem);
    });
  }

  void _adicionarPagamento(PedidoPagamento pagamento) {
    setState(() {
      _pagamentos.add(pagamento);
    });
  }

  void _removerPagamento(int idPagamento) {
    setState(() {
      _pagamentos.removeWhere((pag) => pag.id == idPagamento);
    });
  }

  void _salvarPedido() async {
    if (_itens.isEmpty || _pagamentos.isEmpty) {
      setState(() {
        _mensagemErro = 'Adicione ao menos 1 item e 1 pagamento.';
      });
      return;
    }

    if (totalItens != totalPagamentos) {
      setState(() {
        _mensagemErro =
            'Total dos itens (${totalItens.toStringAsFixed(2)}) é diferente do total dos pagamentos (${totalPagamentos.toStringAsFixed(2)}).';
      });
      return;
    }

    final pedido = Pedido(
      id: _idPedido,
      idCliente: _idCliente,
      idUsuario: _idUsuario,
      totalPedido: totalItens,
      dataCriacao: DateTime.now(),
      itens: _itens,
      pagamento: _pagamentos,
    );

    await _pedidoController.adicionar(pedido);
    if (context.mounted) {
      Navigator.pop(context); // Volta para a home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pedido'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const Text('Itens do Pedido', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._itens.map((item) => ListTile(
                        title: Text('Produto ID: ${item.idProduto}'),
                        subtitle: Text('Qtd: ${item.quantidade}, Total: R\$ ${item.totalItem.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerItem(item.id),
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      _adicionarItem(
                        PedidoItem(
                          idPedido: _idPedido,
                          id: DateTime.now().millisecondsSinceEpoch,
                          idProduto: 1,
                          quantidade: 2,
                          totalItem: 20.0, // Exemplo fixo
                        ),
                      );
                    },
                    child: const Text('Adicionar Item'),
                  ),
                  const SizedBox(height: 20),
                  const Text('Pagamentos', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._pagamentos.map((pagamento) => ListTile(
                        title: Text('Pagamento R\$ ${pagamento.valorPagamento.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerPagamento(pagamento.id),
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      _adicionarPagamento(
                        PedidoPagamento(
                          idPedido: _idPedido,
                          id: DateTime.now().millisecondsSinceEpoch,
                          valorPagamento: 20.0, // Exemplo fixo
                        ),
                      );
                    },
                    child: const Text('Adicionar Pagamento'),
                  ),
                ],
              ),
            ),
            if (_mensagemErro.isNotEmpty)
              Text(_mensagemErro, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _salvarPedido,
              child: const Text('Salvar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}
