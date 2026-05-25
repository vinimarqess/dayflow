import 'package:flutter/material.dart';
import 'package:dayflow/view/evento_view.dart';
import 'package:dayflow/view/rotina_view.dart';
import 'package:dayflow/view/autenticador/perfil_view.dart';
import 'package:dayflow/model/usuario_model.dart';

class HomeView extends StatefulWidget {
  final Usuario usuario;
  const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Cores baseadas no seu protótipo
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
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilView(usuario: widget.usuario),
                  ),
                );
              },
              child: Icon(Icons.account_circle, color: orangeColor, size: 35),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        // Isso permite deslizar a tela para baixo
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // SEÇÃO DE EVENTOS
            _buildSectionHeader("Eventos"),
            const SizedBox(height: 10),
            _buildMainCard(
              child: Column(
                children: [
                  _buildMonthSelector("Mês de ", "Maio"),
                  const SizedBox(height: 20),
                  _buildWhiteButton("Novo Evento", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EventoView()),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SEÇÃO DE ROTINAS
            _buildSectionHeader("Rotinas"),
            const SizedBox(height: 10),
            _buildMainCard(
              child: Column(
                children: [
                  _buildWhiteButton("Nova Rotina", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RotinaView()),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Widget para o título da seção (Eventos / Rotinas)
  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

  // Container escuro que envolve os botões (estilo do protótipo)
  Widget _buildMainCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: child,
    );
  }

  // Seletor de mês com setas
  Widget _buildMonthSelector(String prefix, String month) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.arrow_back_ios, color: orangeColor, size: 20),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 18, color: Colors.white),
            children: [
              TextSpan(text: prefix),
              TextSpan(text: month, style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Icon(Icons.arrow_forward_ios, color: orangeColor, size: 20),
      ],
    );
  }

  // O botão branco solicitado
  Widget _buildWhiteButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(Icons.add, color: orangeColor, size: 28),
          ],
        ),
      ),
    );
  }
}