class Paciente {
  final int? id;
  final String nombre;
  final String fechaNacimiento;
  final String direccion;
  final int idCiudad;

  const Paciente({
    this.id,
    required this.nombre,
    required this.fechaNacimiento,
    required this.direccion,
    required this.idCiudad,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: _toInt(json['id'] ?? json['ID']),
      nombre: _toText(json['nombre'] ?? json['NOMBRE']),
      fechaNacimiento: _toText(
        json['fechaNacimiento'] ??
            json['fechA_NACIMIENTO'] ??
            json['FECHA_NACIMIENTO'],
      ),
      direccion: _toText(json['direccion'] ?? json['DIRECCION']),
      idCiudad: _toInt(json['idCiudad'] ?? json['iD_CIUDAD'] ?? json['ID_CIUDAD']) ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento,
      'direccion': direccion,
      'idCiudad': idCiudad,
    };
  }
}

int? _toInt(dynamic value) => value is int ? value : int.tryParse('$value');

String _toText(dynamic value) => value?.toString() ?? '';