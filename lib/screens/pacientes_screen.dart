import 'package:flutter/material.dart';

import '../models/paciente.dart';
import '../services/api_service.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final ApiService _api = ApiService();
  late Future<List<Paciente>> _pacientesFuture;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  void _recargar() {
    _pacientesFuture = _api.getPacientes();
  }

  Future<void> _mostrarDialogoNuevoPaciente() async {
    final nombreController = TextEditingController();
    final direccionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final guardado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nuevo paciente'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: _required,
              ),
              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: _required,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await _api.crearPaciente(
                  Paciente(
                    nombre: nombreController.text.trim(),
                    fechaNacimiento: DateTime.now().toIso8601String(),
                    direccion: direccionController.text.trim(),
                    idCiudad: 1,
                  ),
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext, true);
              } catch (error) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(error.toString())),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    nombreController.dispose();
    direccionController.dispose();
    if (guardado == true && mounted) {
      setState(_recargar);
    }
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Campo obligatorio' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes · Sitio A')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogoNuevoPaciente,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo'),
      ),
      body: FutureBuilder<List<Paciente>>(
        future: _pacientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorState(message: snapshot.error.toString(), onRetry: () => setState(_recargar));
          }
          final pacientes = snapshot.data ?? const <Paciente>[];
          if (pacientes.isEmpty) {
            return const Center(child: Text('No hay pacientes registrados.'));
          }
          return RefreshIndicator(
            onRefresh: () async => setState(_recargar),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
              itemCount: pacientes.length,
              separatorBuilder: (_, index) => const SizedBox(height: 4),
              itemBuilder: (_, index) {
                final paciente = pacientes[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(paciente.nombre),
                    subtitle: Text('Dirección: ${paciente.direccion}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}