import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';
import '../../modelos/pedido_item.dart';
import '../../modelos/pedido_pagamento.dart';
import '../../modelos/produto.dart';
import '../../telas/produto/produto_controller.dart';
import 'pedido_controller.dart';

class TelaCadastroPedido extends StatefulWidget {
  const TelaCadastroPedido({super.key});

  @override
  State<TelaCadastroPedido> createState() => _TelaCadastroPedidoState();
}

class _TelaCadastroPedidoState extends State<TelaCadastroPedido> {
  final PedidoController _pedidoController = PedidoController();
  final ProdutoController _produtoController = ProdutoController();

  final List<PedidoItem> _itens = [];
  final List<PedidoPagamento> _pagamentos = [];

  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _valorPagamentoController = TextEditingController();

  Produto? _produtoSelecionado;

  int _idPedido = DateTime.now().millisecondsSinceEpoch;
  int _idCliente = 0;
  int _idUsuario = 1;
  String _mensagemErro = '';

  double get totalItens =>
      _itens.fold(0.0, (total, item) => total + item.totalItem);

  double get totalPagamentos =>
      _pagamentos.fold(0.0, (total, pag) => total + pag.valorPagamento);

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    await _produtoController.carregarProdutos();
    setState(() {}); // Atualiza UI após o carregamento
  }

  void _adicionarItem() {
    if (_produtoSelecionado == null) {
      setState(() {
        _mensagemErro = 'Selecione um produto.';
      });
      return;
    }

    final quantidade = double.tryParse(_quantidadeController.text);
    if (quantidade == null || quantidade <= 0) {
      setState(() {
        _mensagemErro = 'Informe uma quantidade válida.';
      });
      return;
    }

    final totalItem = quantidade * _produtoSelecionado!.precoVenda;

    setState(() {
      _mensagemErro = '';
      _itens.add(PedidoItem(
        idPedido: _idPedido,
        id: DateTime.now().millisecondsSinceEpoch,
        idProduto: _produtoSelecionado!.id,
        quantidade: quantidade,
        totalItem: totalItem,
      ));
      _quantidadeController.clear();
      _produtoSelecionado = null;
    });
  }

  void _removerItem(int idItem) {
    setState(() {
      _itens.removeWhere((item) => item.id == idItem);
    });
  }

  void _adicionarPagamento() {
    final valor = double.tryParse(_valorPagamentoController.text);

    if (valor == null || valor <= 0) {
      setState(() {
        _mensagemErro = 'Informe um valor de pagamento válido.';
      });
      return;
    }

    setState(() {
      _mensagemErro = '';
      _pagamentos.add(PedidoPagamento(
        idPedido: _idPedido,
        id: DateTime.now().millisecondsSinceEpoch,
        valorPagamento: valor,
      ));
      _valorPagamentoController.clear();
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = _produtoController.produtos;

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
                  ..._itens.map((item) {
                    final produto = produtos.firstWhere(
                      (p) => p.id == item.idProduto,
                      orElse: () => Produto(id: 0, nome: 'Desconhecido', precoVenda: 0, unidade: 'Kg', qtdEstoque: 0, status: 0),
                    );
                    return ListTile(
                      title: Text('Produto: ${produto.nome}'),
                      subtitle: Text('Qtd: ${item.quantidade}, Total: R\$ ${item.totalItem.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removerItem(item.id),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Produto>(
                    value: _produtoSelecionado,
                    items: produtos.map((produto) {
                      return DropdownMenuItem(
                        value: produto,
                        child: Text('${produto.nome} (R\$ ${produto.precoVenda.toStringAsFixed(2)})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _produtoSelecionado = value;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Produto'),
                  ),
                  TextField(
                    controller: _quantidadeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantidade'),
                  ),
                  ElevatedButton(
                    onPressed: _adicionarItem,
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
                  TextField(
                    controller: _valorPagamentoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Valor do Pagamento'),
                  ),
                  ElevatedButton(
                    onPressed: _adicionarPagamento,
                    child: const Text('Adicionar Pagamento'),
                  ),
                ],
              ),
            ),
            if (_mensagemErro.isNotEmpty)
              Text(_mensagemErro, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            Text('Total dos Itens: R\$ ${totalItens.toStringAsFixed(2)}'),
            Text('Total dos Pagamentos: R\$ ${totalPagamentos.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
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
