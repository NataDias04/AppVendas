import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';
import '../../modelos/produto.dart';
import '../../modelos/cliente.dart';
import '../../modelos/usuario.dart';

class TelaCadastroPedido extends StatefulWidget {
  final Pedido? pedido;
  final List<Produto> produtos;
  final List<Cliente> clientes;
  final Usuario usuario;

  const TelaCadastroPedido({
    super.key,
    this.pedido,
    required this.produtos,
    required this.clientes,
    required this.usuario,
  });

  @override
  State<TelaCadastroPedido> createState() => _TelaCadastroPedidoState();
}

class _TelaCadastroPedidoState extends State<TelaCadastroPedido> {
  late List<PedidoItem> itens;
  late List<PedidoPagamento> pagamentos;
  int? idCliente;
  double totalPedido = 0;

  @override
  void initState() {
    super.initState();
    itens = widget.pedido?.itens ?? [];
    pagamentos = widget.pedido?.pagamentos ?? [];
    idCliente = widget.pedido?.idCliente;
    calcularTotal();
  }

  void calcularTotal() {
    double total = 0;
    for (var item in itens) {
      total += item.totalItem;
    }
    setState(() {
      totalPedido = total;
    });
  }

  void adicionarItem(PedidoItem item) {
    setState(() {
      itens.add(item);
      calcularTotal();
    });
  }

  void removerItem(PedidoItem item) {
    setState(() {
      itens.remove(item);
      calcularTotal();
    });
  }

  void adicionarPagamento(PedidoPagamento pagamento) {
    setState(() {
      pagamentos.add(pagamento);
    });
  }

  void removerPagamento(PedidoPagamento pagamento) {
    setState(() {
      pagamentos.remove(pagamento);
    });
  }

  bool validarPedido() {
    if (idCliente == null) {
      mostrarErro('Selecione um cliente');
      return false;
    }
    if (itens.isEmpty) {
      mostrarErro('Adicione pelo menos um item');
      return false;
    }
    if (pagamentos.isEmpty) {
      mostrarErro('Adicione pelo menos um pagamento');
      return false;
    }
    double totalPagamentos =
        pagamentos.fold(0, (soma, p) => soma + p.valorPagamento);
    if (totalPagamentos != totalPedido) {
      mostrarErro(
          'Total dos pagamentos (${totalPagamentos.toStringAsFixed(2)}) é diferente do total do pedido (${totalPedido.toStringAsFixed(2)})');
      return false;
    }
    return true;
  }

  void mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            DropdownButtonFormField<int>(
              value: idCliente,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: widget.clientes
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.nome),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  idCliente = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Itens do Pedido',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton(
              onPressed: () {
                // Aqui você implementa a tela de adicionar item
              },
              child: const Text('Adicionar Item'),
            ),
            ...itens
                .map((e) => ListTile(
                      title: Text('Produto ${e.idProduto}'),
                      subtitle: Text(
                          'Qtd: ${e.quantidade}, Total: ${e.totalItem.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removerItem(e),
                      ),
                    ))
                .toList(),
            const Divider(),
            Text(
              'Pagamentos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton(
              onPressed: () {
                // Aqui você implementa a tela de adicionar pagamento
              },
              child: const Text('Adicionar Pagamento'),
            ),
            ...pagamentos
                .map((p) => ListTile(
                      title: Text(
                          'Valor: ${p.valorPagamento.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removerPagamento(p),
                      ),
                    ))
                .toList(),
            const Divider(),
            Text(
              'Total do Pedido: R\$ ${totalPedido.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (validarPedido()) {
                  final pedido = Pedido(
                    id: widget.pedido?.id ?? DateTime.now().millisecondsSinceEpoch,
                    idCliente: idCliente!,
                    idUsuario: widget.usuario.id,
                    total: totalPedido,
                    dataCriacao: DateTime.now(),
                    itens: itens,
                    pagamentos: pagamentos,
                  );
                  Navigator.pop(context, pedido);
                }
              },
              child: const Text('Salvar Pedido'),
            )
          ],
        ),
      ),
    );
  }
}
