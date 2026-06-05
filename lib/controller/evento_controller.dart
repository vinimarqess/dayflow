import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dayflow/model/evento_model.dart';
import 'constants.dart';

class EventoService {

  // INSERIR EVENTO
  Future<String> inserir(Evento evento) async {
    final url = Uri.parse('$baseUrl/Evento.php?acao=inserir');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // LISTAR EVENTOS DO USUÁRIO
  Future<List<Evento>> listar(int idUsuario) async {
    final url = Uri.parse('$baseUrl/Evento.php?acao=listar&id_usuario=$idUsuario');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Evento.fromJson(e)).toList();
  }

  // EXCLUIR EVENTO
  Future<String> excluir(int idEvento) async {
    final url = Uri.parse('$baseUrl/Evento.php?acao=excluir');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_evento': idEvento}),
    );

    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // ATUALIZAR EVENTO
  Future<String> atualizar(Evento evento) async {
    final url = Uri.parse('$baseUrl/Evento.php?acao=atualizar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(evento.toJson()),
    );

    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}