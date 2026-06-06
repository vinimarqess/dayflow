import 'package:flutter/material.dart';
import 'package:dayflow/controller/evento_controller.dart';
import 'package:dayflow/model/evento_model.dart';

class EventoView extends StatefulWidget {
  final int idUsuario;
  const EventoView({super.key, required this.idUsuario});

  @override
  State<EventoView> createState() => _EventoViewState();
}

class _EventoViewState extends State<EventoView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkCardColor = const Color(0xFF1E1E1E);
  final Color redColor = const Color(0xFFFF5A5A);
  final Color fieldColor = const Color(0xFF2B2B2B);

  DateTime _mesAtual = DateTime.now();
  List<Evento> _eventos = [];
  Evento? _eventoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    try {
      final service = EventoService();
      final lista = await service.listar(widget.idUsuario);
      setState(() => _eventos = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar eventos: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Set<int> _diasComEvento() {
    return _eventos
        .where((e) {
      final data = DateTime.tryParse(e.data);
      return data != null &&
          data.month == _mesAtual.month &&
          data.year == _mesAtual.year;
    })
        .map((e) => DateTime.parse(e.data).day)
        .toSet();
  }

  List<Evento> _eventosdoMes() {
    return _eventos.where((e) {
      final data = DateTime.tryParse(e.data);
      return data != null &&
          data.month == _mesAtual.month &&
          data.year == _mesAtual.year;
    }).toList();
  }

  Future<void> _excluir(Evento evento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkCardColor,
        title: const Text('Confirmar exclusão', style: TextStyle(color: Colors.white)),
        content: Text('Excluir "${evento.nome}"?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir', style: TextStyle(color: redColor)),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    final service = EventoService();
    final msg = await service.excluir(evento.idEvento!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: orangeColor),
    );
    setState(() => _eventoSelecionado = null);
    _carregarEventos();
  }

  String _nomeMes(int mes) {
    const meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[mes - 1];
  }

  // modal de adicionar/editar evento
  void _abrirModal({Evento? evento}) {
    final editando = evento != null;
    final nomeController = TextEditingController(text: editando ? evento.nome : '');
    final descController = TextEditingController(text: editando ? evento.descricao : '');

    DateTime? dataSelecionada = editando ? DateTime.tryParse(evento.data) : null;
    TimeOfDay? horaSelecionada;
    TimeOfDay? alarmeSelecionado;
    bool alarmeAtivo = false;

    if (editando) {
      final partes = evento.hora.split(':');
      horaSelecionada = TimeOfDay(
        hour: int.parse(partes[0]),
        minute: int.parse(partes[1]),
      );
      if (evento.alarme != null) {
        alarmeAtivo = true;
        final partesAlarme = evento.alarme!.split(':');
        alarmeSelecionado = TimeOfDay(
          hour: int.parse(partesAlarme[0]),
          minute: int.parse(partesAlarme[1]),
        );
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: darkCardColor,
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  editando ? 'Editar Evento' : 'Novo Evento',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Campo nome
                _buildModalField(controller: nomeController, hint: 'Nome do evento'),
                const SizedBox(height: 12),

                // Campo descrição
                _buildModalField(controller: descController, hint: 'Descrição (opcional)'),
                const SizedBox(height: 12),

                // HORA e DATA
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final h = await showTimePicker(
                            context: context,
                            initialTime: horaSelecionada ?? TimeOfDay.now(),
                          );
                          if (h != null) setModalState(() => horaSelecionada = h);
                        },
                        child: _buildModalTapField(
                          label: 'HORA',
                          valor: horaSelecionada != null
                              ? '${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}'
                              : '--:--',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: dataSelecionada ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (d != null) setModalState(() => dataSelecionada = d);
                        },
                        child: _buildModalTapField(
                          label: 'DATA',
                          valor: dataSelecionada != null
                              ? '${dataSelecionada!.day.toString().padLeft(2, '0')}/${dataSelecionada!.month.toString().padLeft(2, '0')}/${dataSelecionada!.year}'
                              : '--/--/----',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ALARME com toggle
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: alarmeAtivo
                            ? () async {
                          final h = await showTimePicker(
                            context: context,
                            initialTime: alarmeSelecionado ?? TimeOfDay.now(),
                          );
                          if (h != null) setModalState(() => alarmeSelecionado = h);
                        }
                            : null,
                        child: _buildModalTapField(
                          label: 'ALARME',
                          valor: alarmeSelecionado != null
                              ? '${alarmeSelecionado!.hour.toString().padLeft(2, '0')}:${alarmeSelecionado!.minute.toString().padLeft(2, '0')}'
                              : '--:--',
                          ativo: alarmeAtivo,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: alarmeAtivo,
                      activeColor: orangeColor,
                      onChanged: (value) => setModalState(() {
                        alarmeAtivo = value;
                        if (!value) alarmeSelecionado = null;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Botão Salvar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nomeController.text.isEmpty ||
                          dataSelecionada == null ||
                          horaSelecionada == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha nome, data e hora.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      final data =
                          '${dataSelecionada!.year}-${dataSelecionada!.month.toString().padLeft(2, '0')}-${dataSelecionada!.day.toString().padLeft(2, '0')}';
                      final hora =
                          '${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}:00';
                      final alarme = alarmeAtivo && alarmeSelecionado != null
                          ? '${alarmeSelecionado!.hour.toString().padLeft(2, '0')}:${alarmeSelecionado!.minute.toString().padLeft(2, '0')}:00'
                          : null;

                      final novoEvento = Evento(
                        idEvento: editando ? evento.idEvento : null,
                        nome: nomeController.text,
                        descricao: descController.text,
                        data: data,
                        hora: hora,
                        alarme: alarme,
                        idUsuario: widget.idUsuario,
                      );

                      final service = EventoService();
                      final msg = editando
                          ? await service.atualizar(novoEvento)
                          : await service.inserir(novoEvento);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg), backgroundColor: orangeColor),
                      );

                      if (msg.contains('sucesso')) {
                        Navigator.pop(context);
                        _carregarEventos();
                      }
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
      ),
    );
  }

  Widget _buildModalField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildModalTapField({required String label, required String valor, bool ativo = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: ativo ? fieldColor : fieldColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 4),
          Text(valor,
              style: TextStyle(
                  color: ativo ? Colors.white : Colors.white30, fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diasComEvento = _diasComEvento();
    final primeiroDia = DateTime(_mesAtual.year, _mesAtual.month, 1);
    final totalDias = DateTime(_mesAtual.year, _mesAtual.month + 1, 0).day;
    final offsetInicio = primeiroDia.weekday % 7;

    final temMesAnterior = _eventos.any((e) {
      final data = DateTime.tryParse(e.data);
      return data != null &&
          (data.year < _mesAtual.year ||
              (data.year == _mesAtual.year && data.month < _mesAtual.month));
    });

    final temProximoMes = _eventos.any((e) {
      final data = DateTime.tryParse(e.data);
      return data != null &&
          (data.year > _mesAtual.year ||
              (data.year == _mesAtual.year && data.month > _mesAtual.month));
    });

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
      body: GestureDetector(
        onTap: () => setState(() => _eventoSelecionado = null),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // Calendario
              Container(
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
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              color: temMesAnterior ? orangeColor : Colors.transparent, size: 20),
                          onPressed: temMesAnterior
                              ? () => setState(() =>
                          _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1))
                              : null,
                        ),
                        Text(
                          '${_nomeMes(_mesAtual.month)} ${_mesAtual.year}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios,
                              color: temProximoMes ? orangeColor : Colors.transparent, size: 20),
                          onPressed: temProximoMes
                              ? () => setState(() =>
                          _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1))
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S']
                          .map((d) => SizedBox(
                        width: 35,
                        child: Center(
                          child: Text(d,
                              style: const TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: offsetInicio + totalDias,
                      itemBuilder: (context, index) {
                        if (index < offsetInicio) return const SizedBox();
                        final dia = index - offsetInicio + 1;
                        final temEvento = diasComEvento.contains(dia);
                        final hoje = DateTime.now();
                        final ehHoje = dia == hoje.day &&
                            _mesAtual.month == hoje.month &&
                            _mesAtual.year == hoje.year;
                        return Center(
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: temEvento
                                  ? redColor
                                  : ehHoje
                                  ? Colors.grey.shade700
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text('$dia',
                                  style: TextStyle(
                                    color: temEvento || ehHoje
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: temEvento
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Botão Novo Evento — abre modal
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _abrirModal(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Novo Evento",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Icon(Icons.add, color: orangeColor, size: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),


              // Lista de eventos
              ..._eventosdoMes().map((evento) {
                final selecionado = _eventoSelecionado?.idEvento == evento.idEvento;
                final data = DateTime.tryParse(evento.data);
                final dataFormatada = data != null
                    ? '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}'
                    : '';
                final horaFormatada = evento.hora.substring(0, 5);

                return GestureDetector(
                  onTap: () => setState(() =>
                  _eventoSelecionado = selecionado ? null : evento),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: darkCardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(evento.nome,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('$dataFormatada - $horaFormatada',
                                      style: const TextStyle(
                                          color: Colors.white60, fontSize: 13)),
                                  if (evento.descricao.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(evento.descricao,
                                        style: const TextStyle(
                                            color: Colors.white54, fontSize: 13)),
                                  ]
                                ],
                              ),
                            ),
                            Icon(Icons.notifications,
                                color: evento.alarme != null ? redColor : Colors.grey),
                          ],
                        ),
                      ),


                      // Menu excluir/editar
                      if (selecionado)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: darkCardColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black45, blurRadius: 8)
                              ],
                            ),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _excluir(evento),
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


                                //Editar abre modal com campos preenchidos
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => _eventoSelecionado = null);
                                    _abrirModal(evento: evento);
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}