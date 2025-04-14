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
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  int _perfilSelecionado = 1;  // 1 para "Admin", 0 para "Comum"
  Usuario? _usuarioEmEdicao;
  bool _modoEdicao = false;

  // Função para validar os campos obrigatórios
  bool _validarCampos() {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty ||
        _telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return false;
    }
    return true;
  }

  // Função para salvar ou editar o usuário
  void _salvarUsuario() async {
    if (!_validarCampos()) return;

    final usuario = Usuario(
      id: _usuarioEmEdicao?.id ?? DateTime.now().millisecondsSinceEpoch,
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      telefone: _telefoneController.text,
      perfil: _perfilSelecionado == 1 ? 'Admin' : 'Comum', // Convertendo para String
    );

    if (_modoEdicao) {
      await _controller.atualizar(usuario);
    } else {
      await _controller.adicionar(usuario);
    }

    _limparCampos();
    setState(() {});
  }

  // Limpa os campos após salvar ou cancelar
  void _limparCampos() {
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _telefoneController.clear();
    _perfilSelecionado = 1;  // Resetando o perfil para "Admin"
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
            _campoTexto(_nomeController, 'Nome *'),
            _campoTexto(_emailController, 'E-mail *'),
            _campoTexto(_senhaController, 'Senha *', isPassword: true),
            _campoTexto(_telefoneController, 'Telefone *'),
            DropdownButton<int>(
              value: _perfilSelecionado,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(_modoEdicao ? 'Salvar Alterações' : 'Cadastrar'),
                  ),
                ),
                if (_modoEdicao)
                  const SizedBox(width: 10),
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
                itemCount: _controller.usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _controller.usuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text(usuario.nome),
                      subtitle: Text('E-mail: ${usuario.email}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              setState(() {
                                _usuarioEmEdicao = usuario;
                                _modoEdicao = true;
                                _nomeController.text = usuario.nome;
                                _emailController.text = usuario.email;
                                _senhaController.text = usuario.senha;
                                _telefoneController.text = usuario.telefone;
                                _perfilSelecionado = usuario.perfil == 'Admin' ? 1 : 0;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
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

  Widget _campoTexto(TextEditingController controller, String label, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword, // Definindo se é para ocultar o texto (senha)
    );
  }
}
