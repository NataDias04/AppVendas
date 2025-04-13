import 'package:flutter/material.dart';
import '../../modelos/produto.dart';
import 'produto_controller.dart';

class TelaProduto extends StatefulWidget {
  const TelaProduto({super.key});

  @override
  State<TelaProduto> createState() => _TelaProdutoState();
}

class _TelaProdutoState extends State<TelaProduto> {
  final ProdutoController _controller = ProdutoController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _unidadeController = TextEditingController();
  final TextEditingController _precoVendaController = TextEditingController();
  final TextEditingController _qtdEstoqueController = TextEditingController();
  final TextEditingController _codigoBarrasController = TextEditingController();
  final TextEditingController _custoController = TextEditingController();
  int _statusSelecionado = 1;

  Produto? _produtoEmEdicao;
  bool _modoEdicao = false;

  void _limparCampos() {
    _nomeController.clear();
    _unidadeController.clear();
    _precoVendaController.clear();
    _qtdEstoqueController.clear();
    _codigoBarrasController.clear();
    _custoController.clear();
    _statusSelecionado = 1;
    _produtoEmEdicao = null;
    _modoEdicao = false;
  }

  void _salvarProduto() async {
    if (_nomeController.text.isEmpty ||
        _unidadeController.text.isEmpty ||
        _precoVendaController.text.isEmpty ||
        _qtdEstoqueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }
    final unidadesPermitidas = ['un', 'cx', 'kg', 'lt', 'ml'];
    if (!unidadesPermitidas.contains(_unidadeController.text.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unidade inválida! Use apenas: un, cx, kg, lt, ml')),
      );
      return;
    }

    final produto = Produto(
      id: _produtoEmEdicao?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      unidade: _unidadeController.text,
      precoVenda: double.tryParse(_precoVendaController.text) ?? 0.0,
      qtdEstoque: int.tryParse(_qtdEstoqueController.text) ?? 0,
      custo: double.tryParse(_custoController.text) ?? 0.0,
      status: _statusSelecionado,
      codigoBarras: _codigoBarrasController.text,
    );

    if (_modoEdicao) {
      await _controller.atualizar(produto);
    } else {
      await _controller.adicionar(produto);
    }

    _limparCampos();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller.carregarProdutos().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar Produto' : 'Cadastro de Produto'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _campoTexto(_nomeController, 'Nome *'),
            _campoTexto(_unidadeController, 'Unidade *'),
            _campoTexto(_precoVendaController, 'Preço de Venda *', isNumber: true),
            _campoTexto(_qtdEstoqueController, 'Quantidade em Estoque *', isNumber: true),
            _campoTexto(_codigoBarrasController, 'Código de Barras'),
            _campoTexto(_custoController, 'Custo', isNumber: true),
            DropdownButton<int>(
              value: _statusSelecionado,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Ativo')),
                DropdownMenuItem(value: 0, child: Text('Inativo')),
              ],
              onChanged: (valor) {
                setState(() {
                  _statusSelecionado = valor ?? 1;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvarProduto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(_modoEdicao ? 'Salvar Alterações' : 'Cadastrar'),
                  ),
                ),
                if (_modoEdicao) const SizedBox(width: 10),
                if (_modoEdicao)
                  ElevatedButton(
                    onPressed: () {
                      _limparCampos();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text('Cancelar'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.produtos.length,
                itemBuilder: (context, index) {
                  final produto = _controller.produtos[index];
                  return Card(
                    child: ListTile(
                      title: Text(produto.nome),
                      subtitle: Text('Preço: R\$${produto.precoVenda.toStringAsFixed(2)} | Estoque: ${produto.qtdEstoque}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _produtoEmEdicao = produto;
                                _modoEdicao = true;
                                _nomeController.text = produto.nome;
                                _unidadeController.text = produto.unidade;
                                _precoVendaController.text = produto.precoVenda.toString();
                                _qtdEstoqueController.text = produto.qtdEstoque.toString();
                                _codigoBarrasController.text = produto.codigoBarras;
                                _custoController.text = produto.custo.toString();
                                _statusSelecionado = produto.status;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _controller.remover(produto.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }
}
