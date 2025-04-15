import 'package:flutter/material.dart';
import '../../modelos/usuario.dart';
import 'usuario_controller.dart';

class TelaUsuario extends StatefulWidget {
  const TelaUsuario({super.key});

  @override
  State<TelaUsuario> createState() => _TelaUsuarioState();
}

class _TelaUsuarioState extends State<TelaUsuario> {
  final UsuarioController _controller = UsuarioController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  int _perfilSelecionado = 1; // 1 para Admin, 0 para Comum

  Usuario? _usuarioEmEdicao;
  bool _modoEdicao = false;

  void _salvarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = Usuario(
      id: _usuarioEmEdicao?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text.trim(),
      senha: _senhaController.text.trim(),
      perfil: _perfilSelecionado == 1 ? 'Admin' : 'Comum',
    );

    if (_modoEdicao) {
      await _controller.atualizar(usuario);
    } else {
      await _controller.adicionar(usuario);
    }

    _limparCampos();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário ${_modoEdicao ? "atualizado" : "cadastrado"} com sucesso')),
    );
  }

  void _limparCampos() {
    _nomeController.clear();
    _senhaController.clear();
    _perfilSelecionado = 1;
    _usuarioEmEdicao = null;
    _modoEdicao = false;
  }

  @override
  void initState() {
    super.initState();
    _controller.carregarUsuarios().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modoEdicao ? 'Editar Usuário' : 'Cadastro de Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _campoTexto(
                    controller: _nomeController,
                    label: 'Nome *',
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Informe o nome' : null,
                  ),
                  _campoTexto(
                    controller: _senhaController,
                    label: 'Senha *',
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.length < 4 ? 'Senha muito curta' : null,
                  ),
                  DropdownButtonFormField<int>(
                    value: _perfilSelecionado,
                    decoration: const InputDecoration(labelText: 'Perfil'),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Admin')),
                      DropdownMenuItem(value: 0, child: Text('Comum')),
                    ],
                    onChanged: (valor) {
                      setState(() {
                        _perfilSelecionado = valor ?? 1;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _salvarUsuario,
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _controller.usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _controller.usuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text(usuario.nome),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _usuarioEmEdicao = usuario;
                                _modoEdicao = true;
                                _nomeController.text = usuario.nome;
                                _senhaController.text = usuario.senha;
                                _perfilSelecionado = usuario.perfil == 'Admin' ? 1 : 0;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _controller.remover(usuario.id);
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

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
