import 'package:flutter/material.dart';

class RotinaView extends StatefulWidget {
  const RotinaView({super.key});

  @override
  State<RotinaView> createState() => _RotinaViewState();
}

class _RotinaViewState extends State<RotinaView> {
  // Cores consistentes com o protótipo
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Seta de voltar laranja conforme a imagem
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: orangeColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Planos de Rotina",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Reutilizando o padrão de botão branco com ícone de '+'
            _buildActionCard(
              label: "Nova Rotina",
              onPressed: () {
                // Aqui você chamará a tela de cadastro de rotina
              },
            ),
            // Espaço para futuras listagens de planos
          ],
        ),
      ),
    );
  }

  // Widget reutilizável para o botão de ação principal
  Widget _buildActionCard({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.add, color: orangeColor, size: 30),
          ],
        ),
      ),
    );
  }
}