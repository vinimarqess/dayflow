import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/habito_model.dart';
import 'constants.dart';

class HabitoService {

  // INSERIR
  Future<String> inserir(String nome, String horarioInicio, String horarioFim, int idDiaSemana) async {
    final url = Uri.parse('$baseUrl/Habito.php?acao=inserir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'horario_inicio': horarioInicio,
        'horario_fim': horarioFim,
        'id_diasemana': idDiaSemana,
      }),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  //  LISTAR
  Future<List<Habito>> listar(int idDiaSemana) async {
    final url = Uri.parse('$baseUrl/Habito.php?acao=listar&id_diasemana=$idDiaSemana');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Habito.fromJson(e)).toList();
  }

  //ATUALIZAR
  Future<String> atualizar(int idHabito, String nome, String horarioInicio, String horarioFim) async {
    final url = Uri.parse('$baseUrl/Habito.php?acao=atualizar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_habito': idHabito,
        'nome': nome,
        'horario_inicio': horarioInicio,
        'horario_fim': horarioFim,
      }),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // EXCLUIR
  Future<String> excluir(int idHabito) async {
    final url = Uri.parse('$baseUrl/Habito.php?acao=excluir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_habito': idHabito}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // ATUALIZAR STATUS
  Future<void> atualizarStatus(int idHabito, bool concluido) async {
    final url = Uri.parse('$baseUrl/Habito.php?acao=atualizarStatus');
    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_habito': idHabito,
        'concluido': concluido ? 1 : 0,
      }),
    );
  }
}