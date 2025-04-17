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
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _estoqueController = TextEditingController();
  final TextEditingController _custoController = TextEditingController();
  final TextEditingController _codigoBarrasController = TextEditingController();

  String? _erroNome;
  String? _erroPreco;
  String? _erroEstoque;
  String? _erroCusto;
  String? _erroCodigoBarras;

  String _unidadeSelecionada = 'UN'; // unidade padrão
  int _statusSelecionado = 0; // 0 = Ativo, 1 = Inativo

  Produto? _produtoEmEdicao;
  bool _modoEdicao = false;

  @override
  void initState() {
    super.initState();
    _controller.carregarProdutos().then((_) => setState(() {}));
  }

  void _limparCampos() {
    _nomeController.clear();
    _precoController.clear();
    _estoqueController.clear();
    _custoController.clear();
    _codigoBarrasController.clear();
    _unidadeSelecionada = 'UN';
    _statusSelecionado = 0;
    _produtoEmEdicao = null;
    _modoEdicao = false;

    _erroNome = null;
    _erroPreco = null;
    _erroEstoque = null;
    _erroCusto = null;
    _erroCodigoBarras = null;
  }

  bool _validarCampos() {
    bool valido = true;

    setState(() {
      _erroNome = _nomeController.text.isEmpty ? 'Informe o nome do produto' : null;
      _erroPreco = double.tryParse(_precoController.text) == null ? 'Preço inválido' : null;
      _erroEstoque = int.tryParse(_estoqueController.text) == null ? 'Estoque inválido' : null;
      _erroCusto = double.tryParse(_custoController.text) == null ? 'Custo inválido' : null;
      _erroCodigoBarras = _codigoBarrasController.text.isEmpty ? 'Informe o código de barras' : null;

      valido = [_erroNome, _erroPreco, _erroEstoque, _erroCusto, _erroCodigoBarras].every((e) => e == null);
    });

    return valido;
  }

  void _salvarProduto() async {
    if (!_validarCampos()) return;

    final produto = Produto(
      id: _produtoEmEdicao?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      unidade: _unidadeSelecionada,
      qtdEstoque: int.parse(_estoqueController.text),
      precoVenda: double.parse(_precoController.text),
      status: _statusSelecionado,
      custo: double.parse(_custoController.text),
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

  Widget _campoTexto(TextEditingController controller, String label, String? erro, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            labelText: label,
            errorText: erro,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
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
            _campoTexto(_nomeController, 'Nome *', _erroNome),
            _campoTexto(_precoController, 'Preço de venda *', _erroPreco, isNumber: true),
            _campoTexto(_estoqueController, 'Quantidade em estoque *', _erroEstoque, isNumber: true),
            _campoTexto(_custoController, 'Custo *', _erroCusto, isNumber: true),
            _campoTexto(_codigoBarrasController, 'Código de barras *', _erroCodigoBarras),

            DropdownButton<String>(
              value: _unidadeSelecionada,
              onChanged: (String? nova) {
                setState(() {
                  _unidadeSelecionada = nova!;
                });
              },
              items: ['UN', 'KG', 'L', 'M'].map((String unidade) {
                return DropdownMenuItem<String>(
                  value: unidade,
                  child: Text(unidade),
                );
              }).toList(),
            ),

            DropdownButton<int>(
              value: _statusSelecionado,
              onChanged: (int? novoStatus) {
                setState(() {
                  _statusSelecionado = novoStatus!;
                });
              },
              items: const [
                DropdownMenuItem(value: 0, child: Text('Ativo')),
                DropdownMenuItem(value: 1, child: Text('Inativo')),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvarProduto,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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
                    child: const Text('Cancelar'),
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
                      subtitle: Text(
                        'R\$ ${produto.precoVenda.toStringAsFixed(2)} - ${produto.unidade} - ${produto.status == 0 ? 'Ativo' : 'Inativo'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _produtoEmEdicao = produto;
                                _modoEdicao = true;
                                _nomeController.text = produto.nome;
                                _precoController.text = produto.precoVenda.toString();
                                _estoqueController.text = produto.qtdEstoque.toString();
                                _custoController.text = produto.custo.toString();
                                _codigoBarrasController.text = produto.codigoBarras;
                                _unidadeSelecionada = produto.unidade;
                                _statusSelecionado = produto.status;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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
}
