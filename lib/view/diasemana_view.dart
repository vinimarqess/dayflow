import 'package:flutter/material.dart';
import 'package:dayflow/controller/diasemana_controller.dart';
import 'package:dayflow/model/diasemana_model.dart';
import 'habito_view.dart';

class DiaSemanaView extends StatefulWidget {
  final int idRotina;
  final String nomeRotina;

  const DiaSemanaView({
    super.key,
    required this.idRotina,
    required this.nomeRotina,
  });

  @override
  State<DiaSemanaView> createState() => _DiaSemanaViewState();
}

class _DiaSemanaViewState extends State<DiaSemanaView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color redColor = const Color(0xFFFF5A5A);

  List<DiaSemana> _dias = [];
  DiaSemana? _diaSelecionado;

  //Dias disponiveis para seleçao
  final List<String> _diasSemana = [
    'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'
  ];

  @override
  void initState() {
    super.initState();
    _carregarDias();
  }

  Future<void> _carregarDias() async {
    try {
      final service = DiaSemanaService();
      final lista = await service.listar(widget.idRotina);
      setState(() => _dias = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  //Abre seletor de dias da semana
  void _novoDia() {
    // Filtra os dias que já foram adicionados
    final diasJaAdicionados = _dias.map((d) => d.nome).toList();
    final diasDisponiveis = _diasSemana
        .where((d) => !diasJaAdicionados.contains(d))
        .toList();

    if (diasDisponiveis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todos os dias já foram adicionados!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      // Desliza a tela para ver dia semana
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecione o dia',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...diasDisponiveis.map((dia) => ListTile(
                  title: Text(dia,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () async {
                    Navigator.pop(context);
                    final service = DiaSemanaService();
                    await service.inserir(dia, widget.idRotina);
                    _carregarDias();
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _excluirDia(DiaSemana dia) async {
    final service = DiaSemanaService();
    await service.excluir(dia.idDiaSemana!);
    setState(() => _diaSelecionado = null);
    _carregarDias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: orangeColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.nomeRotina,
            style: TextStyle(
                color: orangeColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => setState(() => _diaSelecionado = null),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lista de dias
                ..._dias.map((dia) {
                  final selecionado = _diaSelecionado?.idDiaSemana == dia.idDiaSemana;
                  return GestureDetector(
                    onTap: () {
                      if (_diaSelecionado != null) {
                        setState(() => _diaSelecionado = null);
                        return;
                      }
                      //Navega para a tela de habitos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitoView(
                            idRotina: widget.idRotina,
                            nomeRotina: widget.nomeRotina,
                            dias: _dias,
                            diaInicial: dia,
                          ),
                        ),
                      );
                    },
                    onLongPress: () => setState(() => _diaSelecionado = dia),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B2B2B),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            dia.nome,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                        //Menu excluir ao pressionar
                        if (selecionado)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black45, blurRadius: 8)
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () => _excluirDia(dia),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: redColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: const Size(100, 40),
                                ),
                                child: const Text('Excluir',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 8),

                // Botao Novo Dia
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _novoDia,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Novo dia',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 10),
                        Icon(Icons.add, color: orangeColor, size: 28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}