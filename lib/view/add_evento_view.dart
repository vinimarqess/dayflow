import 'package:flutter/material.dart';

class AddEventoView extends StatefulWidget {
  const AddEventoView({super.key});

  @override
  State<AddEventoView> createState() => _AddEventoViewState();
}

class _AddEventoViewState extends State<AddEventoView> {
  final _nomeController = TextEditingController();
  final _descController = TextEditingController();
  bool _alarmeAtivo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color(0xFFFBA150)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Adicionar Evento", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildField(label: "NOME", hint: "Trabalho importante", controller: _nomeController),
            const SizedBox(height: 20),
            _buildField(label: "DESCRIÇÃO", hint: "Descrição do evento", controller: _descController),
            const SizedBox(height: 20),

            // Fileira de Hora e Dia
            Row(
              children: [
                Expanded(child: _buildSmallField(label: "HORA", hint: "23:59")),
                const SizedBox(width: 15),
                Expanded(child: _buildSmallField(label: "DIA", hint: "31", isDropdown: true)),
              ],
            ),
            const SizedBox(height: 20),

            // Sessão de Alarme
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildSmallField(label: "ALARME", hint: "13:59")),
                Switch(
                  value: _alarmeAtivo,
                  activeColor: const Color(0xFFFBA150),
                  onChanged: (value) => setState(() => _alarmeAtivo = value),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () { /* Lógica para salvar no Banco de Dados futuramente */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFBA150),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Salvar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reaproveitando a lógica de campos do seu grupo
  Widget _buildField({required String label, required String hint, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF2B2B2B),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallField({required String label, required String hint, bool isDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(color: const Color(0xFF2B2B2B), borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(hint, style: const TextStyle(color: Colors.white54)),
              if (isDropdown) const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            ],
          ),
        ),
      ],
    );
  }
}