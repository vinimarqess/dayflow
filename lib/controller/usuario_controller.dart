import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usuario_model.dart';
import 'constants.dart';

class UsuarioService {

  // 1. LOGIN VIA POST
  Future<Usuario?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios.php?acao=login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    }
    return null; // login inválido
  }

  // 2. CADASTRAR VIA POST
  Future<String> cadastrar(String nome, String email, String senha) async {
    final url = Uri.parse('$baseUrl/usuarios.php?acao=cadastrar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome_usuario': nome,
        'email': email,
        'senha': senha,
      }),
    );

    final json = jsonDecode(response.body);
    return json['mensagem'] ?? json['erro'] ?? 'Erro desconhecido';
  }

  // 3. LISTAR CONTINUA GET (Porque listar não envia dados sensíveis)
  Future<List<Usuario>> listar() async {
    final url = Uri.parse('$baseUrl/usuarios.php?acao=listar');
    final response = await http.get(url);
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => Usuario.fromJson(e)).toList();
  }
}