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
  final TextEditingController _senhaController = TextEditingController();
  int _perfilSelecionado = 1;

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

  Widget _campoTexto({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _modoEdicao ? 'Editar Usuário' : 'Cadastro de Usuário',
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3E8EED),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _campoTexto(
                    controller: _nomeController,
                    label: 'Nome *',
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  _campoTexto(
                    controller: _senhaController,
                    label: 'Senha *',
                    obscureText: true,
                    validator: (value) =>
                        value == null || value.length < 4 ? 'Senha muito curta' : null,
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _salvarUsuario,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3E8EED),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _modoEdicao ? 'Salvar Alterações' : 'Cadastrar',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
