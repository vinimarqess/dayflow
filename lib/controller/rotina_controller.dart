import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dayflow/model/rotina_model.dart';
import 'constants.dart';

class RotinaService {

  // INSERIR
  Future<String> inserir(String nome, String descricao, int idUsuario) async {
    final url = Uri.parse('$baseUrl/Rotina.php?acao=inserir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'descricao': descricao, 'id_usuario': idUsuario}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // 2. LISTAR
  Future<List<Rotina>> listar(int idUsuario) async {
    final url = Uri.parse('$baseUrl/Rotina.php?acao=listar&id_usuario=$idUsuario');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Rotina.fromJson(e)).toList();
  }

  // TUALIZAR
  Future<String> atualizar(int idRotina, String nome, String descricao) async {
    final url = Uri.parse('$baseUrl/Rotina.php?acao=atualizar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_rotina': idRotina, 'nome': nome, 'descricao': descricao}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // MARCAR COMO ATIVA
  Future<String> marcarAtiva(int idRotina, int idUsuario) async {
    final url = Uri.parse('$baseUrl/Rotina.php?acao=marcarAtiva');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_rotina': idRotina, 'id_usuario': idUsuario}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // EXCLUIR
  Future<String> excluir(int idRotina) async {
    final url = Uri.parse('$baseUrl/Rotina.php?acao=excluir');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id_rotina': idRotina}),
    );
    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }
}