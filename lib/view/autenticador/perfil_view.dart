import 'package:flutter/material.dart';
import 'package:dayflow/view/autenticador/editar_perfil_view.dart';
import 'package:dayflow/model/usuario_model.dart';
import 'package:dayflow/view/autenticador/adm_view.dart';
import 'package:dayflow/view/Autenticador/login_view.dart';

class PerfilView extends StatefulWidget {
  final Usuario usuario;
  const PerfilView({super.key, required this.usuario});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  late Usuario _usuario;

  @override
  void initState() {
    super.initState();
    _usuario = widget.usuario;
  }

  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: orangeColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _usuario.nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),

              _buildButton('Editar Perfil', () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarPerfilView(
                      idUsuario: _usuario.id!,
                      nomeAtual: _usuario.nome,
                      emailAtual: _usuario.email,
                    ),
                  ),
                );
                if (resultado != null) {
                  setState(() {
                    _usuario = Usuario(
                      id: _usuario.id,
                      nome: resultado['nome'],
                      email: resultado['email'],
                      senha: _usuario.senha,
                    );
                  });
                }
              }),
              const SizedBox(height: 16),

              _buildButton('Configurações', () {}),
              const SizedBox(height: 16),

              _buildButton('ADM', () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdmView()),
                );
              }),
              const SizedBox(height: 16),


              _buildButton('Sair da Conta', () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                        (route) => false,
                  );
                },
                cor: const Color(0xFFFF5A5A),
                corTexto: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, {
    Color cor = Colors.white,
    Color corTexto = Colors.black,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: corTexto,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}