import 'package:flutter/material.dart';
import 'package:dayflow/controller/habito_controller.dart';
import 'package:dayflow/model/habito_model.dart';
import 'package:dayflow/model/diasemana_model.dart';

class HabitoView extends StatefulWidget {
  final int idRotina;
  final String nomeRotina;
  final List<DiaSemana> dias;
  final DiaSemana diaInicial;

  const HabitoView({
    super.key,
    required this.idRotina,
    required this.nomeRotina,
    required this.dias,
    required this.diaInicial,
  });

  @override
  State<HabitoView> createState() => _HabitoViewState();
}

class _HabitoViewState extends State<HabitoView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color redColor = const Color(0xFFFF5A5A);

  late DiaSemana _diaAtual;
  List<Habito> _habitos = [];
  Habito? _habitoSelecionado;

  @override
  void initState() {
    super.initState();
    _diaAtual = widget.diaInicial;
    _carregarHabitos();
  }

  Future<void> _carregarHabitos() async {
    try {
      final service = HabitoService();
      final lista = await service.listar(_diaAtual.idDiaSemana!);
      setState(() => _habitos = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  //Navega para o dia anterior
  void _diaAnterior() {
    final index = widget.dias.indexOf(_diaAtual);
    if (index > 0) {
      setState(() {
        _diaAtual = widget.dias[index - 1];
        _habitoSelecionado = null;
      });
      _carregarHabitos();
    }
  }

  //Navega para o próximo dia
  void _proximoDia() {
    final index = widget.dias.indexOf(_diaAtual);
    if (index < widget.dias.length - 1) {
      setState(() {
        _diaAtual = widget.dias[index + 1];
        _habitoSelecionado = null;
      });
      _carregarHabitos();
    }
  }

  // Modal para adicionar habito
  void _novoHabito() {
    final nomeController = TextEditingController();
    TimeOfDay? horarioInicio;
    TimeOfDay? horarioFim;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Novo Hábito',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Campo nome
              TextField(
                controller: nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome do hábito',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2B2B2B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Horário início e fim
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final h = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (h != null) setModalState(() => horarioInicio = h);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('INÍCIO',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 4),
                            Text(
                              horarioInicio != null
                                  ? '${horarioInicio!.hour.toString().padLeft(2, '0')}:${horarioInicio!.minute.toString().padLeft(2, '0')}'
                                  : '--:--',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final h = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (h != null) setModalState(() => horarioFim = h);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FIM',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 4),
                            Text(
                              horarioFim != null
                                  ? '${horarioFim!.hour.toString().padLeft(2, '0')}:${horarioFim!.minute.toString().padLeft(2, '0')}'
                                  : '--:--',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nomeController.text.isEmpty ||
                        horarioInicio == null ||
                        horarioFim == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha todos os campos.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final inicio =
                        '${horarioInicio!.hour.toString().padLeft(2, '0')}:${horarioInicio!.minute.toString().padLeft(2, '0')}:00';
                    final fim =
                        '${horarioFim!.hour.toString().padLeft(2, '0')}:${horarioFim!.minute.toString().padLeft(2, '0')}:00';

                    final service = HabitoService();
                    await service.inserir(
                        nomeController.text, inicio, fim, _diaAtual.idDiaSemana!);
                    Navigator.pop(context);
                    _carregarHabitos();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Salvar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Modal para editar habito
  void _editarHabito(Habito habito) {
    final nomeController = TextEditingController(text: habito.nome);
    final partesInicio = habito.horarioInicio.split(':');
    final partesFim = habito.horarioFim.split(':');
    TimeOfDay horarioInicio = TimeOfDay(
        hour: int.parse(partesInicio[0]), minute: int.parse(partesInicio[1]));
    TimeOfDay horarioFim = TimeOfDay(
        hour: int.parse(partesFim[0]), minute: int.parse(partesFim[1]));

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Editar Hábito',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextField(
                controller: nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Nome do hábito',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF2B2B2B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final h = await showTimePicker(
                          context: context,
                          initialTime: horarioInicio,
                        );
                        if (h != null) setModalState(() => horarioInicio = h);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('INÍCIO',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 4),
                            Text(
                              '${horarioInicio.hour.toString().padLeft(2, '0')}:${horarioInicio.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final h = await showTimePicker(
                          context: context,
                          initialTime: horarioFim,
                        );
                        if (h != null) setModalState(() => horarioFim = h);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('FIM',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    letterSpacing: 1.2)),
                            const SizedBox(height: 4),
                            Text(
                              '${horarioFim.hour.toString().padLeft(2, '0')}:${horarioFim.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final inicio =
                        '${horarioInicio.hour.toString().padLeft(2, '0')}:${horarioInicio.minute.toString().padLeft(2, '0')}:00';
                    final fim =
                        '${horarioFim.hour.toString().padLeft(2, '0')}:${horarioFim.minute.toString().padLeft(2, '0')}:00';

                    final service = HabitoService();
                    await service.atualizar(
                        habito.idHabito!, nomeController.text, inicio, fim);
                    Navigator.pop(context);
                    setState(() => _habitoSelecionado = null);
                    _carregarHabitos();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Salvar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.dias.indexOf(_diaAtual);
    final temAnterior = index > 0;
    final temProximo = index < widget.dias.length - 1;

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
        onTap: () => setState(() => _habitoSelecionado = null),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Navegação entre dias
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: temAnterior ? orangeColor : Colors.transparent),
                    onPressed: temAnterior ? _diaAnterior : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _diaAtual.nome,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios,
                        color: temProximo ? orangeColor : Colors.transparent),
                    onPressed: temProximo ? _proximoDia : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Botão Novo Habito
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _novoHabito,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Novo Hábito',
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
              const SizedBox(height: 16),

              // Lista de habitos
              ..._habitos.map((habito) {
                final selecionado =
                    _habitoSelecionado?.idHabito == habito.idHabito;

                return GestureDetector(
                  onLongPress: () =>
                      setState(() => _habitoSelecionado = habito),
                  onTap: () => setState(() => _habitoSelecionado = null),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
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
                                  Text(habito.nome,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${habito.horarioInicio.substring(0, 5)} - ${habito.horarioFim.substring(0, 5)}',
                                    style: const TextStyle(
                                        color: Colors.white60, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            //Toggle verde/cinza — salva no banco ao clicar
                            GestureDetector(
                              onTap: () async {
                                final service = HabitoService();
                                await service.atualizarStatus(
                                    habito.idHabito!, !habito.concluido);
                                _carregarHabitos();
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: habito.concluido
                                      ? Colors.green
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Menu excluir/editar ao pressionar
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
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final service = HabitoService();
                                    await service.excluir(habito.idHabito!);
                                    setState(() => _habitoSelecionado = null);
                                    _carregarHabitos();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: redColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: const Text('Excluir',
                                      style:
                                      TextStyle(color: Colors.white)),
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(
                                            () => _habitoSelecionado = null);
                                    _editarHabito(habito);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF2B2B2B),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    minimumSize: const Size(100, 40),
                                  ),
                                  child: const Text('Editar',
                                      style:
                                      TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}