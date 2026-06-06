class Evento {
  final int? idEvento;
  final String nome;
  final String descricao;
  final String data;
  final String hora;
  final String? alarme;
  final int idUsuario;

  Evento({
    this.idEvento,
    required this.nome,
    required this.descricao,
    required this.data,
    required this.hora,
    this.alarme,
    required this.idUsuario,
  });

  // Recebe em php e passa para json
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      idEvento: json['id_evento'] is String ? int.parse(json['id_evento']) : json['id_evento'],
      nome: json['nome'],
      descricao: json['descricao'] ?? '',
      data: json['data'],
      hora: json['hora'],
      alarme: json['alarme'],
      idUsuario: json['id_usuario'] is String ? int.parse(json['id_usuario']) : json['id_usuario'],
    );
  }
  // Recebe em json e passa para php
  Map<String, dynamic> toJson() {
    return {
      'id_evento': idEvento,
      'nome': nome,
      'descricao': descricao,
      'data': data,
      'hora': hora,
      'alarme': alarme,
      'id_usuario': idUsuario,
    };
  }
}