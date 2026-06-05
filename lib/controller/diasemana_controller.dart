import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dayflow/model/diasemana_model.dart';
import 'constants.dart';

class DiaSemanaService {

  // INSERIR DIA
  Future<String> inserir(String nome, int idRotina) async {
    final url = Uri.parse('$baseUrl/DiaSemana.php?acao=inserir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'id_rotina': idRotina}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // LISTAR DIAS DA ROTINA
  Future<List<DiaSemana>> listar(int idRotina) async {
    final url = Uri.parse('$baseUrl/DiaSemana.php?acao=listar&id_rotina=$idRotina');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => DiaSemana.fromJson(e)).toList();
  }

  // EXCLUIR DIA
  Future<String> excluir(int idDiaSemana) async {
    final url = Uri.parse('$baseUrl/DiaSemana.php?acao=excluir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_diasemana': idDiaSemana}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}