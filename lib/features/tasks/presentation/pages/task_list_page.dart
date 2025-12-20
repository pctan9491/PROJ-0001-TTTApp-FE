import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  // State Variables
  String _searchQuery = '';
  String _activeFilter = 'All'; // Options: 'All', 'Do', 'Overdue'

  // Keys for identifying widgets in tests or inspector
  static const Key searchQueryFieldKey = Key('search_query_field');
  static const Key filterDropdownKey = Key('filter_dropdown');
  static const Key addTaskButtonKey = Key('add_task_button');
  static const Key taskListKey = Key('task_list');

  // Dummy Data (Same structure as Eisenhower Matrix for consistency)
  final List<Task> _allTasks = [
    const Task(id: '1', uuid: '1', userUuid: '1', title: 'Fix Critical Bug', importance: TaskImportance.important, urgency: TaskUrgency.urgent),
    const Task(id: '2', uuid: '2', userUuid: '1', title: 'Plan Roadmap', importance: TaskImportance.important, urgency: TaskUrgency.notUrgent),
    const Task(id: '3', uuid: '3', userUuid: '1', title: 'Reply to Emails', importance: TaskImportance.notImportant, urgency: TaskUrgency.urgent),
    const Task(id: '4', uuid: '4', userUuid: '1', title: 'Organize Files', importance: TaskImportance.notImportant, urgency: TaskUrgency.notUrgent),
    // Add a dummy "Overdue" task logic later if needed, for now just filtering by ID or Title for demo
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).scaffoldBackgroundColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    // 1. Filter Tasks Logic
    List<Task> filteredTasks = _getFilteredTasks();

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Search & Filter Bar ---
            _TaskSearchBar(
              key: searchQueryFieldKey,
              searchQuery: _searchQuery,
              onSearchChanged: (value) => setState(() => _searchQuery = value),
              onFilterTap: () => _showFilterDialog(context, primaryColor, secondaryColor),
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            ),

            // --- Filter Indicator ---
            if (_activeFilter != 'All')
              _FilterIndicator(
                key: filterDropdownKey,
                activeFilter: _activeFilter,
                onClear: () => setState(() => _activeFilter = 'All'),
                secondaryColor: secondaryColor,
              ),

            // --- Task List ---
            Expanded(
              child: _TaskListView(
                key: taskListKey,
                tasks: filteredTasks,
                secondaryColor: secondaryColor,
              ),
            ),
          ],
        ),
      ),
      //Add Task button
      floatingActionButton: FloatingActionButton(
        key: addTaskButtonKey,
        backgroundColor: secondaryColor,
        onPressed: () {
          // TODO: Implement Add Task
        },
        child: Icon(FontAwesomeIcons.plus, color: primaryColor),
      ),
    );
  }

  List<Task> _getFilteredTasks() {
    return _allTasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      bool matchesCategory = true;
      if (_activeFilter == 'Do') {
        matchesCategory = task.importance == TaskImportance.important && task.urgency == TaskUrgency.urgent;
      } else if (_activeFilter == 'Overdue') {
        matchesCategory = false; // TODO: Implement overdue logic
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _showFilterDialog(BuildContext context, Color primaryColor, Color secondaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Tasks',
                style: TextStyle(color: secondaryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildFilterOption('All Tasks', 'All', secondaryColor),
              _buildFilterOption('"Do" Tasks (Important & Urgent)', 'Do', secondaryColor),
              _buildFilterOption('Overdue Tasks', 'Overdue', secondaryColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String label, String value, Color secondaryColor) {
    final isSelected = _activeFilter == value;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? secondaryColor : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: secondaryColor) : null,
      onTap: () {
        setState(() => _activeFilter = value);
        Navigator.pop(context);
      },
    );
  }
}

// --- Sub-Widgets ---

class _TaskSearchBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final Color primaryColor;
  final Color secondaryColor;

  const _TaskSearchBar({
    Key? key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryColor.withOpacity(0.5)),
              ),
              child: TextField(
                style: TextStyle(color: secondaryColor),
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  hintStyle: TextStyle(color: secondaryColor.withOpacity(0.5)),
                  prefixIcon: Icon(Icons.search, color: secondaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: onSearchChanged,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: primaryColor),
              onPressed: onFilterTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterIndicator extends StatelessWidget {
  final String activeFilter;
  final VoidCallback onClear;
  final Color secondaryColor;

  const _FilterIndicator({
    Key? key,
    required this.activeFilter,
    required this.onClear,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Text(
            'Filtering by: $activeFilter',
            style: TextStyle(color: secondaryColor.withOpacity(0.8), fontSize: 12),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 14, color: Colors.redAccent),
          )
        ],
      ),
    );
  }
}

class _TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Color secondaryColor;

  const _TaskListView({
    Key? key,
    required this.tasks,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks found',
          style: TextStyle(color: secondaryColor.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _TaskItem(task: tasks[index], secondaryColor: secondaryColor);
      },
    );
  }
}

class _TaskItem extends StatelessWidget {
  final Task task;
  final Color secondaryColor;

  const _TaskItem({
    required this.task,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    String matrixLabel = _getMatrixLabel(task);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondaryColor.withOpacity(0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          task.title,
          style: TextStyle(
            color: secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.tag, size: 12, color: secondaryColor.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                matrixLabel,
                style: TextStyle(color: secondaryColor.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: secondaryColor.withOpacity(0.5)),
        onTap: () {
          // TODO: Navigate to Task Details
        },
      ),
    );
  }

  String _getMatrixLabel(Task task) {
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
}