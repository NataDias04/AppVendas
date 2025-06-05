import 'package:flutter/material.dart';
import '../../modelos/pedido.dart';
import '../../modelos/cliente.dart';
import '../../modelos/produto.dart';
import '../../modelos/usuario.dart';
import 'pedido_controller.dart';
import 'tela_pedido.dart';

class TelaListaPedidos extends StatefulWidget {
  final PedidoController controller;
  final List<Cliente> clientes;
  final List<Produto> produtos;
  final Usuario usuario;

  const TelaListaPedidos({
    super.key,
    required this.controller,
    required this.clientes,
    required this.produtos,
    required this.usuario,
  });

  @override
  State<TelaListaPedidos> createState() => _TelaListaPedidosState();
}

class _TelaListaPedidosState extends State<TelaListaPedidos> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregarPedidos().then((_) {
      setState(() {});
    });
  }

  String nomeCliente(int idCliente) {
    return widget.clientes
            .firstWhere((c) => c.id == idCliente, orElse: () => Cliente(id: 0, nome: 'Cliente não encontrado'))
            .nome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: ListView.builder(
        itemCount: widget.controller.listaPedidos.length,
        itemBuilder: (context, index) {
          final pedido = widget.controller.listaPedidos[index];
          return ListTile(
            title: Text('Pedido ${pedido.id} - ${nomeCliente(pedido.idCliente)}'),
            subtitle: Text(
                'Total: R\$ ${pedido.total.toStringAsFixed(2)} - ${pedido.dataCriacao.day}/${pedido.dataCriacao.month}/${pedido.dataCriacao.year}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.controller.excluir(pedido.id);
                });
              },
            ),
            onTap: () async {
              final pedidoEditado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaCadastroPedido(
                    pedido: pedido,
                    clientes: widget.clientes,
                    produtos: widget.produtos,
                    usuario: widget.usuario,
                  ),
                ),
              );
              if (pedidoEditado != null) {
                setState(() {
                  widget.controller.atualizar(pedidoEditado);
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pedidoNovo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TelaCadastroPedido(
                clientes: widget.clientes,
                produtos: widget.produtos,
                usuario: widget.usuario,
              ),
            ),
          );
          if (pedidoNovo != null) {
            setState(() {
              widget.controller.adicionar(pedidoNovo);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
