import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/app_config.dart';
import '../../../tasks/domain/entities/task.dart';

class EisenhowerMatrixPage extends StatelessWidget {
  const EisenhowerMatrixPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to State Management (Bloc/Provider) here
    // 1. Inject TaskBloc or TaskRepository
    // 2. Use BlocBuilder<TaskBloc, TaskState> to get the list of tasks
    // 3. Replace the dummy 'tasks' list below with 'state.tasks'
    
    // Dummy Data
    final tasks = [
      const Task(id: '1', uuid: '1', userUuid: '1', title: 'Fix Critical Bug', importance: TaskImportance.important, urgency: TaskUrgency.urgent),
      const Task(id: '2', uuid: '2', userUuid: '1', title: 'Plan Roadmap', importance: TaskImportance.important, urgency: TaskUrgency.notUrgent),
      const Task(id: '3', uuid: '3', userUuid: '1', title: 'Reply to Emails', importance: TaskImportance.notImportant, urgency: TaskUrgency.urgent),
      const Task(id: '4', uuid: '4', userUuid: '1', title: 'Organize Files', importance: TaskImportance.notImportant, urgency: TaskUrgency.notUrgent),
    ];

    return Stack(
      children: [
        Column(
          children: [
            // Top Row
            Expanded(
              child: Row(
                children: [
                  // Do (Important & Urgent)
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      title: 'Do',
                      description: 'Urgent & Important',
                      tasks: tasks,
                      importance: TaskImportance.important,
                      urgency: TaskUrgency.urgent,
                      color: Colors.green.shade400,
                      
                    ),
                  ),
                  // Schedule (Important & Not Urgent)
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      title: 'Schedule',
                      description: 'Not Urgent & Important',
                      tasks: tasks,
                      importance: TaskImportance.important,
                      urgency: TaskUrgency.notUrgent,
                      color: const Color(0xFFFAE3AC), // App Secondary
                      textColor: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Row
            Expanded(
              child: Row(
                children: [
                  // Delegate (Not Important & Urgent)
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      title: 'Delegate',
                      description: 'Urgent & Not Important',
                      tasks: tasks,
                      importance: TaskImportance.notImportant,
                      urgency: TaskUrgency.urgent,
                      color: Colors.blue.shade300,
                    ),
                  ),
                  // Delete (Not Important & Not Urgent)
                  Expanded(
                    child: _buildQuadrant(
                      context,
                      title: 'Delete',
                      description: 'Not Urgent & Not Important',
                      tasks: tasks,
                      importance: TaskImportance.notImportant,
                      urgency: TaskUrgency.notUrgent,
                      color: Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Central Buttons
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10), // Adjust as needed
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add Task Button
                  if (AppConfig.experimentShowAddTaskButton)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white, // Semi-transparent background
                        border: Border.all(color: Colors.green.shade400, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.rocket, color: Color.fromRGBO(102, 187, 106, 1)),
                        onPressed: () {
                          // TODO: Implement Add Task
                        },
                      ),
                    ),
                  
                  // Future Use Button (Always Visible or controlled by another flag if needed)
                   Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.white, // Semi-transparent background
                        border: Border.all(color: const Color(0xFFFAE3AC), width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.plus, color: Color(0xFFFAE3AC)), // Rocket icon for future use
                        onPressed: () {
                          // Future use
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuadrant(
    BuildContext context, {
    required String title,
    required String description,
    required List<Task> tasks,
    required TaskImportance importance,
    required TaskUrgency urgency,
    required Color color,
    Color textColor = Colors.white,
  }) {
    final quadrantTasks = tasks
        .where((t) => t.importance == importance && t.urgency == urgency)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Subtle background
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8),
            color: color.withOpacity(0.8),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor.withOpacity(0.9),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: quadrantTasks.length,
              itemBuilder: (context, index) {
                final task = quadrantTasks[index];
                return Card(
                  color: const Color(0xFF01344F), // App Primary
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(color: Color(0xFFFAE3AC), fontSize: 14),
                    ),
                    dense: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}