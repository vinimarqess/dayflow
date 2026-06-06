import 'package:flutter/material.dart';
import 'package:dayflow/view/evento_view.dart';
import 'package:dayflow/view/rotina_view.dart';
import 'package:dayflow/view/autenticador/perfil_view.dart';
import 'package:dayflow/model/usuario_model.dart';
import 'package:dayflow/model/evento_model.dart';
import 'package:dayflow/controller/evento_controller.dart';

class HomeView extends StatefulWidget {
  final Usuario usuario;
  const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Color orangeColor = const Color(0xFFFBA150);
  final Color darkBg = const Color(0xFF121212);
  final Color cardColor = const Color(0xFF1E1E1E);
  final Color redColor = const Color(0xFFFF5A5A);

  //controla o mes exibido
  DateTime _mesAtual = DateTime.now();

  //lista de eventos carregados do banco
  List<Evento> _eventos = [];

  @override
  void initState() {
    super.initState();
    _carregarEventos();// carrega ao abrir
  }

  //busca os eventos do usuario na API
  Future<void> _carregarEventos() async {
    try {
      final service = EventoService();
      final lista = await service.listar(widget.usuario.id!);
      setState(() => _eventos = lista);
    } catch (e) {
      debugPrint('Erro ao carregar eventos: $e');
    }
  }

  //filtra eventos do mes atual
  List<Evento> get _eventosdoMes {
    return _eventos.where((e) {
      final data = DateTime.tryParse(e.data);
      return data != null &&
          data.month == _mesAtual.month &&
          data.year == _mesAtual.year;
    }).toList();
  }

  //nome do mes em portugues
  String _nomeMes(int mes) {
    const meses = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[mes - 1];
  }

  @override
  Widget build(BuildContext context) {
    final eventosMes = _eventosdoMes;
    final temEventos = eventosMes.isNotEmpty;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Eventos", style: TextStyle(color: Colors.white)),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // SEÇao DE EVENTOS
            _buildMainCard(
              child: Column(
                children: [
                  //seletor de mes com botao "..." quando tem eventos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Seta esquerda
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: orangeColor, size: 20),
                        onPressed: () => setState(() =>
                        _mesAtual = DateTime(_mesAtual.year, _mesAtual.month - 1)),
                      ),

                      // Mês atual
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                          children: [
                            const TextSpan(text: 'Mês de '),
                            TextSpan(
                              text: _nomeMes(_mesAtual.month),
                              style: TextStyle(
                                  color: orangeColor, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      //seta direita + botão "..." quando tem eventos
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios, color: orangeColor, size: 20),
                            onPressed: () => setState(() =>
                            _mesAtual = DateTime(_mesAtual.year, _mesAtual.month + 1)),
                          ),
                          //"..." aparece so quando tem eventos
                          if (temEventos)
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventoView(
                                      idUsuario: widget.usuario.id!,
                                    ),
                                  ),
                                );
                                _carregarEventos(); // recarrega ao voltar
                              },
                              child: const Text(
                                '...',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //sem eventos → botão "Novo Evento"
                  //com eventos → lista os eventos do mes
                  if (!temEventos)
                    _buildWhiteButton("Novo Evento", () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventoView(idUsuario: widget.usuario.id!),
                        ),
                      );
                      _carregarEventos();
                    })
                  else
                    Column(
                      children: eventosMes.map((evento) {
                        final data = DateTime.tryParse(evento.data);
                        final dataFormatada = data != null
                            ? '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}'
                            : '';
                        final horaFormatada = evento.hora.substring(0, 5);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B2B2B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      evento.nome,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$dataFormatada - $horaFormatada',
                                      style: const TextStyle(
                                          color: Colors.white60, fontSize: 12),
                                    ),
                                    if (evento.descricao.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        evento.descricao,
                                        style: const TextStyle(
                                            color: Colors.white54, fontSize: 12),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                              //////sino
                              Icon(
                                Icons.notifications,
                                color: evento.alarme != null ? redColor : Colors.grey,
                                size: 22,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SEÇaO DE ROTINAS
            _buildSectionHeader("Rotinas"),
            const SizedBox(height: 10),
            _buildMainCard(
              child: Column(
                children: [
                  _buildWhiteButton("Nova Rotina", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RotinaView(idUsuario: widget.usuario.id!)),
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

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

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
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Icon(Icons.add, color: orangeColor, size: 28),
          ],
        ),
      ),
    );
  }
}