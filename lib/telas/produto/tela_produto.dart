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

  String _unidadeSelecionada = 'UN';
  int _statusSelecionado = 0;

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
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: '$label *', // Adicionando o asterisco ao lado do rótulo
        errorText: erro,
        filled: true,
        fillColor: Colors.white,  // Cor de fundo branca
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definindo a cor azul diretamente
    Color azul = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar Produto' : 'Cadastro de Produto'),
        backgroundColor: azul, // Cor azul diretamente no AppBar
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _campoTexto(_nomeController, 'Nome', _erroNome),
            const SizedBox(height: 12),
            _campoTexto(_precoController, 'Preço de venda', _erroPreco, isNumber: true),
            const SizedBox(height: 12),
            _campoTexto(_estoqueController, 'Quantidade em estoque', _erroEstoque, isNumber: true),
            const SizedBox(height: 12),
            _campoTexto(_custoController, 'Custo', _erroCusto, isNumber: true),
            const SizedBox(height: 12),
            _campoTexto(_codigoBarrasController, 'Código de barras', _erroCodigoBarras),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _unidadeSelecionada,
              decoration: InputDecoration(
                labelText: 'Unidade',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,  // Cor de fundo branca
              ),
              onChanged: (String? nova) {
                setState(() {
                  _unidadeSelecionada = nova!;
                });
              },
              items: ['UN', 'KG', 'L', 'M'].map((String unidade) {
                return DropdownMenuItem<String>(value: unidade, child: Text(unidade));
              }).toList(),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              value: _statusSelecionado,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,  // Cor de fundo branca
              ),
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
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _salvarProduto,
                    icon: const Icon(Icons.check),
                    label: Text(_modoEdicao ? 'Salvar Alterações' : 'Cadastrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul, // Cor azul no botão
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                if (_modoEdicao) const SizedBox(width: 10),
                if (_modoEdicao)
                  ElevatedButton.icon(
                    onPressed: () {
                      _limparCampos();
                      setState(() {});
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),

            const Divider(),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.produtos.length,
              itemBuilder: (context, index) {
                final produto = _controller.produtos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(produto.nome),
                    subtitle: Text(
                      'R\$ ${produto.precoVenda.toStringAsFixed(2)} - ${produto.unidade} - ${produto.status == 0 ? 'Ativo' : 'Inativo'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: azul), // Cor azul no ícone de editar
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
          ],
        ),
      ),
    );
  }
}
