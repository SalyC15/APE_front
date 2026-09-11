class CitaMedica {
  final int num;
  final String paciente;
  final String ciudadPaciente;
  final String doctor;
  final String ciudadDoctor;
  final String especialidad;
  final String fechaHora;
  final String descripcion;
  final String tratamiento;

  const CitaMedica({
    required this.num,
    required this.paciente,
    required this.ciudadPaciente,
    required this.doctor,
    required this.ciudadDoctor,
    required this.especialidad,
    required this.fechaHora,
    required this.descripcion,
    required this.tratamiento,
  });

  factory CitaMedica.fromJson(Map<String, dynamic> json) {
    return CitaMedica(
      num: _toInt(json['num'] ?? json['NUM']) ?? 0,
      paciente: _text(json['paciente'] ?? json['PACIENTE']),
      ciudadPaciente: _text(
        json['ciudadPaciente'] ?? json['ciudaD_PACIENTE'] ?? json['CIUDAD_PACIENTE'],
      ),
      doctor: _text(json['doctor'] ?? json['DOCTOR']),
      ciudadDoctor: _text(
        json['ciudadDoctor'] ?? json['ciudaD_DOCTOR'] ?? json['CIUDAD_DOCTOR'],
      ),
      especialidad: _text(json['especialidad'] ?? json['ESPECIALIDAD']),
      fechaHora: _text(json['fechaHora'] ?? json['fechahora'] ?? json['FECHAHORA']),
      descripcion: _optionalText(json['descripcion'] ?? json['DESCRIPCION']),
      tratamiento: _optionalText(json['tratamiento'] ?? json['TRATAMIENTO']),
    );
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('$value');

String _text(dynamic value) => value?.toString() ?? '';

String _optionalText(dynamic value) => value?.toString().trim().isNotEmpty == true
    ? value.toString()
    : 'S/I';