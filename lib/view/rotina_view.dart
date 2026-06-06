import 'package:flutter/material.dart';
import 'package:dayflow/controller/rotina_controller.dart';
import 'package:dayflow/model/rotina_model.dart';
import 'package:dayflow/view/diasemana_view.dart';

class RotinaView extends StatefulWidget {
  final int idUsuario;
  const RotinaView({super.key, required this.idUsuario});

  @override
  State<RotinaView> createState() => _RotinaViewState();
}

class _RotinaViewState extends State<RotinaView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color redColor = const Color(0xFFFF5A5A);

  List<Rotina> _rotinas = [];
  Rotina? _rotinaSelecionada; // controla o menu excluir/editar

  @override
  void initState() {
    super.initState();
    _carregarRotinas();
  }

  Future<void> _carregarRotinas() async {
    try {
      final service = RotinaService();
      final lista = await service.listar(widget.idUsuario);
      setState(() => _rotinas = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _novaRotina() {
    final nomeController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nova Rotina',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildModalField(controller: nomeController, hint: 'Nome da rotina'),
            const SizedBox(height: 12),
            _buildModalField(controller: descController, hint: 'Descrição (opcional)'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (nomeController.text.isEmpty) return;
                  final service = RotinaService();
                  await service.inserir(
                    nomeController.text,
                    descController.text,
                    widget.idUsuario,
                  );
                  Navigator.pop(context);
                  _carregarRotinas();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Salvar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // modal para editar rotina
  void _editarRotina(Rotina rotina) {
    final nomeController = TextEditingController(text: rotina.nome);
    final descController = TextEditingController(text: rotina.descricao);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editar Rotina',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildModalField(controller: nomeController, hint: 'Nome da rotina'),
            const SizedBox(height: 12),
            _buildModalField(controller: descController, hint: 'Descrição (opcional)'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final service = RotinaService();
                  await service.atualizar(rotina.idRotina!, nomeController.text, descController.text);
                  Navigator.pop(context);
                  setState(() => _rotinaSelecionada = null);
                  _carregarRotinas();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('Salvar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _excluirRotina(Rotina rotina) async {
    final service = RotinaService();
    await service.excluir(rotina.idRotina!);
    setState(() => _rotinaSelecionada = null);
    _carregarRotinas();
  }

  Future<void> _toggleAtiva(Rotina rotina) async {
    final service = RotinaService();
    await service.marcarAtiva(rotina.idRotina!, widget.idUsuario);
    _carregarRotinas();
  }

  Widget _buildModalField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2B2B2B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: orangeColor, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Planos de Rotina', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GestureDetector(
        // Fecha menu ao tocar fora
        onTap: () => setState(() => _rotinaSelecionada = null),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Botão Nova Rotina
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _novaRotina,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Nova Rotina',
                          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Icon(Icons.add, color: orangeColor, size: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de rotinas
              Expanded(
                child: ListView.builder(
                  itemCount: _rotinas.length,
                  itemBuilder: (context, index) {
                    final rotina = _rotinas[index];
                    final selecionada = _rotinaSelecionada?.idRotina == rotina.idRotina;

                    return GestureDetector(
                      // Clique normal — vai para tela de dias da semana
                      onTap: () {
                        if (_rotinaSelecionada != null) {
                          setState(() => _rotinaSelecionada = null);
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiaSemanaView(
                              idRotina: rotina.idRotina!,
                              nomeRotina: rotina.nome,
                            ),
                          ),
                        );
                      },
                      // Pressionar e segurar — abre menu excluir/editar
                      onLongPress: () => setState(() => _rotinaSelecionada = rotina),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(rotina.nome,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      if (rotina.descricao.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(rotina.descricao,
                                            style: const TextStyle(
                                                color: Colors.white54, fontSize: 13)),
                                      ]
                                    ],
                                  ),
                                ),
                                //Estrela laranja = ativa, cinza = inativa
                                GestureDetector(
                                  onTap: () => _toggleAtiva(rotina),
                                  child: Icon(
                                    Icons.star,
                                    color: rotina.ativa ? orangeColor : Colors.grey,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // menu excluir/editar
                          if (selecionada)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
                                ),
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _excluirRotina(rotina),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: redColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        minimumSize: const Size(100, 40),
                                      ),
                                      child: const Text('Excluir',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() => _rotinaSelecionada = null);
                                        _editarRotina(rotina);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2B2B2B),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        minimumSize: const Size(100, 40),
                                      ),
                                      child: const Text('Editar',
                                          style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}