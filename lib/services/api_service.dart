import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cita_medica.dart';
import '../models/doctor.dart';
import '../models/paciente.dart';

class ApiService {
  static const String defaultBaseUrl = 'http://10.79.13.130:5087/api';

  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? defaultBaseUrl;

  final String baseUrl;

  Future<List<Paciente>> getPacientes() async {
    final response = await http
        .get(Uri.parse('$baseUrl/pacientes'))
        .timeout(const Duration(seconds: 15));
    _checkResponse(response, 'cargar pacientes');
    return _decodeList(response).map(Paciente.fromJson).toList();
  }

  Future<bool> crearPaciente(Paciente paciente) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/pacientes'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(paciente.toJson()),
        )
        .timeout(const Duration(seconds: 15));
    _checkResponse(response, 'registrar paciente');
    return true;
  }

  Future<List<CitaMedica>> getCitas() async {
    final response = await http
        .get(Uri.parse('$baseUrl/citas'))
        .timeout(const Duration(seconds: 15));
    _checkResponse(response, 'cargar citas médicas');
    return _decodeList(response).map(CitaMedica.fromJson).toList();
  }

  Future<List<Doctor>> getDoctores() async {
    final response = await http
        .get(Uri.parse('$baseUrl/doctores'))
        .timeout(const Duration(seconds: 15));
    _checkResponse(response, 'cargar doctores');
    return _decodeList(response).map(Doctor.fromJson).toList();
  }

  Future<bool> crearDoctor(Doctor doctor) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/doctores'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(doctor.toJson()),
        )
        .timeout(const Duration(seconds: 15));
    _checkResponse(response, 'registrar doctor');
    return true;
  }

  List<Map<String, dynamic>> _decodeList(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException('La API devolvió un formato inesperado.');
    }
    return decoded
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  void _checkResponse(http.Response response, String action) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String detail = '';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['mensaje'] != null) {
          detail = ': ${body['mensaje']}';
        }
      } on FormatException {
        detail = '';
      }
      throw ApiException('No se pudo $action$detail');
    }
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}