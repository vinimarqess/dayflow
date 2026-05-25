import 'package:flutter/material.dart';
import 'package:dayflow/controller/usuario_controller.dart';

class EditarPerfilView extends StatefulWidget {
  final int idUsuario;
  final String nomeAtual;
  final String emailAtual;

  const EditarPerfilView({
    super.key,
    required this.idUsuario,
    required this.nomeAtual,
    required this.emailAtual,
  });

  @override
  State<EditarPerfilView> createState() => _EditarPerfilViewState();
}

class _EditarPerfilViewState extends State<EditarPerfilView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _confirmarEmailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeAtual);
    _emailController = TextEditingController(text: widget.emailAtual);
    _confirmarEmailController = TextEditingController(text: widget.emailAtual);
  }

  void _salvar() async {
    if (_emailController.text != _confirmarEmailController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Os e-mails não coincidem.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final service = UsuarioService();
      final msg = await service.atualizar(
        widget.idUsuario,
        _nomeController.text,
        _emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: orangeColor,
        ),
      );

      if (msg.contains('sucesso')) {
        Navigator.pop(context, {
          'nome': _nomeController.text,
          'email': _emailController.text,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2B2B2B),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: orangeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildField(
              label: 'NOME',
              controller: _nomeController,
              hint: 'Seu nome',
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'EMAIL',
              controller: _emailController,
              hint: 'Seu e-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildField(
              label: 'CONFIRMAR EMAIL',
              controller: _confirmarEmailController,
              hint: 'Confirme seu e-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),

            // Alterar Senha (desabilitado por enquanto)
            TextButton(
              onPressed: null,
              child: Text(
                'Alterar Senha',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}