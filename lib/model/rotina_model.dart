class Rotina {
  final int? idRotina;
  final String nome;
  final String descricao;
  final bool ativa;
  final int idUsuario;

  Rotina({
    this.idRotina,
    required this.nome,
    required this.descricao,
    required this.ativa,
    required this.idUsuario,
  });

  // Recebe em php e passa para json
  factory Rotina.fromJson(Map<String, dynamic> json) {
    return Rotina(
      idRotina: json['id_rotina'] is String ? int.parse(json['id_rotina']) : json['id_rotina'],
      nome: json['nome'],
      descricao: json['descricao'] ?? '',
      ativa: json['ativa'] == 1 || json['ativa'] == '1' || json['ativa'] == true,
      idUsuario: json['id_usuario'] is String ? int.parse(json['id_usuario']) : json['id_usuario'],
    );
  }

  // Recebe em json e passa para php
  Map<String, dynamic> toJson() {
    return {
      'id_rotina': idRotina,
      'nome': nome,
      'descricao': descricao,
      'ativa': ativa ? 1 : 0,
      'id_usuario': idUsuario,
    };
  }
}