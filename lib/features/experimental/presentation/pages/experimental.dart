import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';

class ExperimentalPage extends StatefulWidget {
  const ExperimentalPage({super.key});

  @override
  State<ExperimentalPage> createState() => _ExperimentalPageState();
}

class ExperimentToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ExperimentToggle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.secondary,
    );
  }
}

class _ExperimentalPageState extends State<ExperimentalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experimental Features', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          _buildBypassLoginExperiment(),
        ],
      ),
    );
  }

  Widget _buildBypassLoginExperiment() {
    return ExperimentToggle(
      title: 'Bypass Login Validation',
      subtitle: 'Allows logging in with any password (dev only)',
      value: AppConfig.bypassLoginValidation,
      onChanged: (bool value) {
        setState(() {
          AppConfig.setBypassLoginValidation(value);
        });
      },
    );
  }
}