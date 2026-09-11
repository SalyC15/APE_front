import 'package:flutter/material.dart';

import '../models/cita_medica.dart';
import '../services/api_service.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final ApiService _api = ApiService();
  late Future<List<CitaMedica>> _citasFuture;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  void _recargar() => _citasFuture = _api.getCitas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas médicas distribuidas')),
      body: FutureBuilder<List<CitaMedica>>(
        future: _citasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return _ErrorState(message: snapshot.error.toString(), onRetry: () => setState(_recargar));
          final citas = snapshot.data ?? const <CitaMedica>[];
          if (citas.isEmpty) return const Center(child: Text('No hay citas registradas.'));
          return RefreshIndicator(
            onRefresh: () async => setState(_recargar),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: citas.length,
              itemBuilder: (_, index) => _CitaCard(cita: citas[index]),
            ),
          );
        },
      ),
    );
  }
}

class _CitaCard extends StatelessWidget {
  const _CitaCard({required this.cita});

  final CitaMedica cita;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cita #${cita.num}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const _SiteLabel(label: 'Sitio A · Paciente', color: Colors.teal),
          _InfoRow(icon: Icons.person, text: cita.paciente),
          _InfoRow(icon: Icons.location_on, text: cita.ciudadPaciente),
          const Divider(height: 24),
          const _SiteLabel(label: 'Sitio B · Doctor', color: Colors.indigo),
          _InfoRow(icon: Icons.medical_services, text: cita.doctor),
          _InfoRow(icon: Icons.school, text: cita.especialidad),
          _InfoRow(icon: Icons.location_on, text: cita.ciudadDoctor),
          const Divider(height: 24),
          const _SiteLabel(label: 'Sitio C · Diagnóstico', color: Colors.deepOrange),
          _InfoRow(icon: Icons.schedule, text: cita.fechaHora),
          _InfoRow(icon: Icons.description, text: 'Diagnóstico: ${cita.descripcion}'),
          _InfoRow(icon: Icons.medication, text: 'Tratamiento: ${cita.tratamiento}'),
        ]),
      ),
    );
  }
}

class _SiteLabel extends StatelessWidget {
  const _SiteLabel({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)));
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ]),
      );
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off, size: 48),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Reintentar')),
      ])));
}