import 'package:flutter/material.dart';

import 'citas_screen.dart';
import 'doctores_screen.dart';
import 'pacientes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediCity'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              Icons.local_hospital_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Sistema médico distribuido',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Consulta y registra información conectada entre los sitios A, B y C.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            _MenuButton(
              icon: Icons.people_alt_rounded,
              title: 'Pacientes',
              subtitle: 'Gestionar pacientes del Sitio A',
              onPressed: () => _open(context, const PacientesScreen()),
            ),
            _MenuButton(
              icon: Icons.medical_services_rounded,
              title: 'Doctores',
              subtitle: 'Registrar doctores del Sitio B',
              onPressed: () => _open(context, const DoctoresScreen()),
            ),
            _MenuButton(
              icon: Icons.calendar_month_rounded,
              title: 'Citas médicas',
              subtitle: 'Consultar la vista distribuida',
              onPressed: () => _open(context, const CitasScreen()),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onPressed,
      ),
    );
  }
}