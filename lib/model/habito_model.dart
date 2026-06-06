class Habito {
  final int? idHabito;
  final String nome;
  final String horarioInicio;
  final String horarioFim;
  final bool concluido;
  final int idDiaSemana;

  Habito({
    this.idHabito,
    required this.nome,
    required this.horarioInicio,
    required this.horarioFim,
    required this.concluido,
    required this.idDiaSemana,
  });

  // Recebe em php e passa para json
  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      idHabito: json['id_habito'] is String ? int.parse(json['id_habito']) : json['id_habito'],
      nome: json['nome'],
      horarioInicio: json['horario_inicio'],
      horarioFim: json['horario_fim'],
      concluido: json['concluido'] == 1 || json['concluido'] == '1' || json['concluido'] == true,
      idDiaSemana: json['id_diasemana'] is String ? int.parse(json['id_diasemana']) : json['id_diasemana'],
    );
  }

  // Recebe em json e passa para php
  Map<String, dynamic> toJson() {
    return {
      'id_habito': idHabito,
      'nome': nome,
      'horario_inicio': horarioInicio,
      'horario_fim': horarioFim,
      'concluido': concluido ? 1 : 0,
      'id_diasemana': idDiaSemana,
    };
  }
}