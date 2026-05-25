class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  // Recebe em json e passa para php
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  // Recebe em php e passa para json
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      nome: json['nome_usuario'],
      email: json['email'],
      senha: json['senha'] ?? '',
    );
  }
}