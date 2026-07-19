import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/task.dart';
import 'add_task_page.dart';

class TaskDetailPage extends StatelessWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  String _getMatrixLabel() {
    if (task.importance == TaskImportance.important && task.urgency == TaskUrgency.urgent) {
      return 'Do (Important & Urgent)';
    } else if (task.importance == TaskImportance.important && task.urgency == TaskUrgency.notUrgent) {
      return 'Schedule (Important & Not Urgent)';
    } else if (task.importance == TaskImportance.notImportant && task.urgency == TaskUrgency.urgent) {
      return 'Delegate (Not Important & Urgent)';
    } else {
      return 'Delete (Not Important & Not Urgent)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).scaffoldBackgroundColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Task Details', style: TextStyle(color: secondaryColor, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: secondaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskPage(task: task),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title ---
            Text(
              task.title,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- Categorization ---
            _buildSectionLabel('Categorization', secondaryColor),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryColor.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(FontAwesomeIcons.tableCellsLarge, color: secondaryColor, size: 20),
                ),
                title: Text('Eisenhower Matrix', style: TextStyle(color: secondaryColor)),
                subtitle: Text(_getMatrixLabel(), style: TextStyle(color: Colors.white70)),
              ),
            ),

            // --- Details & Attachments ---
            _buildSectionLabel('Details', secondaryColor),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.description.isEmpty ? 'No description provided.' : task.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
                  ),
                  const Divider(color: Colors.white24, height: 30),
                  if (task.attachments.isEmpty)
                    Row(
                      children: [
                        Icon(Icons.attach_file, color: secondaryColor.withOpacity(0.5)),
                        const SizedBox(width: 8),
                        Text('No attachments', style: TextStyle(color: Colors.white38)),
                      ],
                    )
                  else
                    Column(
                      children: task.attachments.map((att) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.attach_file, color: secondaryColor),
                        title: Text(att, style: TextStyle(color: Colors.white70)),
                      )).toList(),
                    ),
                ],
              ),
            ),

            // --- Schedule ---
            _buildSectionLabel('Schedule', secondaryColor),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today_outlined, color: secondaryColor),
                title: Text(
                  task.schedule == null ? 'No Due Date' : task.schedule.toString().split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // --- Subtasks (Placeholder as Entity doesn't have subtasks yet) ---
            _buildSectionLabel('Subtasks', secondaryColor),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.check_circle_outline, color: Colors.white38),
                title: Text('No subtasks', style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(color: color.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
  }
}