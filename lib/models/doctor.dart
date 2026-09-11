class Doctor {
  final int? id;
  final String nombre;
  final int idEspecialidad;
  final int idCiudad;
  final String? especialidad;
  final String? ciudad;

  const Doctor({
    this.id,
    required this.nombre,
    required this.idEspecialidad,
    required this.idCiudad,
    this.especialidad,
    this.ciudad,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: _toInt(json['id'] ?? json['ID']),
      nombre: _toText(json['nombre'] ?? json['NOMBRE']),
      idEspecialidad: _toInt(
            json['idEspecialidad'] ??
                json['iD_ESPECIALIDAD'] ??
                json['ID_ESPECIALIDAD'],
          ) ??
          1,
      idCiudad: _toInt(json['idCiudad'] ?? json['iD_CIUDAD'] ?? json['ID_CIUDAD']) ?? 1,
      especialidad: _nullableText(json['especialidad'] ?? json['ESPECIALIDAD']),
      ciudad: _nullableText(json['ciudad'] ?? json['CIUDAD']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'idEspecialidad': idEspecialidad,
      'idCiudad': idCiudad,
    };
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('$value');

String _toText(dynamic value) => value?.toString() ?? '';

String? _nullableText(dynamic value) => value?.toString();