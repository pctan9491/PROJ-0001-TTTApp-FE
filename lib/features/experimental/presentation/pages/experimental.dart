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
  final ValueChanged<bool>? onChanged; // Changed to nullable
  final Color? activeColor;

  const ExperimentToggle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeColor: activeColor ?? Theme.of(context).colorScheme.secondary,
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
          _buildMasterToggle(),
          const Divider(color: Colors.white24),
          _buildBypassLoginExperiment(),
          _buildShowAddTaskButtonExperiment(),
        ],
      ),
    );
  }

  Widget _buildMasterToggle() {
    return ExperimentToggle(
      title: 'Enable All Experiments',
      subtitle: 'Master switch for all experimental features',
      value: AppConfig.enableAllExperiments,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          // Update master toggle immediately (optimistic UI)
          AppConfig.setEnableAllExperiments(value).then((_) {
            // Rebuild again once all child experiments have been updated
            if (mounted) setState(() {});
          });
        });
      },
    );
  }

  Widget _buildBypassLoginExperiment() {
    return ExperimentToggle(
      title: 'Bypass Login Validation',
      subtitle: 'Allows logging in with any password (dev only)',
      value: AppConfig.experiment1BypassLoginValidation,
      onChanged: (bool value) {
        setState(() {
          AppConfig.setExperiment1BypassLoginValidation(value);
        });
      },
    );
  }

  Widget _buildShowAddTaskButtonExperiment() {
    return ExperimentToggle(
      title: 'Show Add Task Button',
      subtitle: 'Toggle visibility of the Add Task button in Eisenhower Matrix',
      value: AppConfig.experimentShowAddTaskButton,
      onChanged: (bool value) {
        setState(() {
          AppConfig.setExperimentShowAddTaskButton(value);
        });
      },
    );
  }
}