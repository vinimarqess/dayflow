import 'package:flutter/material.dart';
import 'add_evento_view.dart';

class EventoView extends StatefulWidget {
  const EventoView({super.key});

  @override
  State<EventoView> createState() => _EventoViewState();
}

class _EventoViewState extends State<EventoView> {
  // Cores baseadas no seu protótipo
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkCardColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: orangeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Evento do mês", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCalendario(),
            const SizedBox(height: 20),
            _buildNovoEventoButton(),
            const SizedBox(height: 20),
            const Text("Seus eventos aparecerão aqui...",
                style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendario() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: darkCardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_ios, color: orangeColor, size: 20),
              const Text("Maio", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, color: orangeColor, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          // Placeholder simples para os dias da semana e números
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: 31,
            itemBuilder: (context, index) {
              int dia = index + 1;
              // Simulando dias com eventos (vermelho conforme seu pedido)
              bool temEvento = [4, 28, 30].contains(dia);
              return Center(
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: temEvento ? Colors.red : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text("$dia", style: const TextStyle(color: Colors.white)),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildNovoEventoButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventoView()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Novo Evento", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Icon(Icons.add, color: orangeColor, size: 30),
          ],
        ),
      ),
    );
  }
}