class DiaSemana {
  final int? idDiaSemana;
  final String nome;
  final int idRotina;

  DiaSemana({
    this.idDiaSemana,
    required this.nome,
    required this.idRotina,
  });

  // Recebe em php e passa para json
  factory DiaSemana.fromJson(Map<String, dynamic> json) {
    return DiaSemana(
      idDiaSemana: json['id_diasemana'] is String ? int.parse(json['id_diasemana']) : json['id_diasemana'],
      nome: json['nome'],
      idRotina: json['id_rotina'] is String ? int.parse(json['id_rotina']) : json['id_rotina'],
    );
  }
  // Recebe em json e passa para php
  Map<String, dynamic> toJson() {
    return {
      'id_diasemana': idDiaSemana,
      'nome': nome,
      'id_rotina': idRotina,
    };
  }
}