import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../services/api_service.dart';

class DoctoresScreen extends StatefulWidget {
  const DoctoresScreen({super.key});

  @override
  State<DoctoresScreen> createState() => _DoctoresScreenState();
}

class _DoctoresScreenState extends State<DoctoresScreen> {
  final ApiService _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _ciudadController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _especialidadController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      await _api.crearDoctor(
        Doctor(
          nombre: _nombreController.text.trim(),
          idEspecialidad: int.parse(_especialidadController.text.trim()),
          idCiudad: int.parse(_ciudadController.text.trim()),
        ),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _nombreController.clear();
      _especialidadController.clear();
      _ciudadController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doctor registrado correctamente.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctores · Sitio B')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.medical_services, size: 64),
              const SizedBox(height: 16),
              Text('Registrar doctor', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextFormField(controller: _nombreController, decoration: const InputDecoration(labelText: 'Nombre completo', border: OutlineInputBorder()), validator: _required),
              const SizedBox(height: 16),
              TextFormField(controller: _especialidadController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ID de especialidad', border: OutlineInputBorder()), validator: _number),
              const SizedBox(height: 16),
              TextFormField(controller: _ciudadController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ID de ciudad', border: OutlineInputBorder()), validator: _number),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: _guardando ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                label: const Text('Guardar doctor'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'Campo obligatorio' : null;

  String? _number(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obligatorio';
    return int.tryParse(value.trim()) == null ? 'Introduce un número válido' : null;
  }
}