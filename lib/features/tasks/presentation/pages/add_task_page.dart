import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/task.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task; // Optional task for editing mode

  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // Form State
  late String _title;
  late String _details;
  DateTime? _schedule;
  late TaskImportance _importance;
  late TaskUrgency _urgency;
  
  // Subtasks
  final List<String> _subtasks = [];
  final TextEditingController _subtaskController = TextEditingController();
  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    // Initialize state based on whether we are editing or creating
    final task = widget.task;
    if (task != null) {
      _title = task.title;
      _details = task.description;
      _schedule = task.schedule;
      _importance = task.importance;
      _urgency = task.urgency;
      // Note: Subtasks are not yet in the Task entity, so we leave list empty or load if added later
    } else {
      _title = '';
      _details = '';
      _schedule = null;
      _importance = TaskImportance.important;
      _urgency = TaskUrgency.urgent;
    }

    _titleController = TextEditingController(text: _title);
    _detailsController = TextEditingController(text: _details);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }


  // Helper to map Matrix Category
  void _setMatrixCategory(String category) {
    setState(() {
      switch (category) {
        case 'Do':
          _importance = TaskImportance.important;
          _urgency = TaskUrgency.urgent;
          break;
        case 'Schedule':
          _importance = TaskImportance.important;
          _urgency = TaskUrgency.notUrgent;
          break;
        case 'Delegate':
          _importance = TaskImportance.notImportant;
          _urgency = TaskUrgency.urgent;
          break;
        case 'Delete':
          _importance = TaskImportance.notImportant;
          _urgency = TaskUrgency.notUrgent;
          break;
      }
    });
  }

  String _getCurrentMatrixLabel() {
    if (_importance == TaskImportance.important && _urgency == TaskUrgency.urgent) return 'Do';
    if (_importance == TaskImportance.important && _urgency == TaskUrgency.notUrgent) return 'Schedule';
    if (_importance == TaskImportance.notImportant && _urgency == TaskUrgency.urgent) return 'Delegate';
    return 'Delete';
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
          icon: Icon(Icons.close, color: secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.task == null ? 'Create New Task' : 'Edit Task', style: TextStyle(color: secondaryColor, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save or Update logic here
              Navigator.pop(context);
            },
            child: Text('Save', style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Title Input ---
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
              onChanged: (val) => _title = val,
            ),

            const SizedBox(height: 20),

            // --- Eisenhower Matrix Selector ---
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
                  child: Icon(FontAwesomeIcons.tableCellsLarge, color: secondaryColor, size: 20),
                ),
                title: Text('Eisenhower Matrix', style: TextStyle(color: secondaryColor)),
                subtitle: Text(_getCurrentMatrixLabel(), style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.arrow_drop_down, color: secondaryColor),
                onTap: () => _showMatrixSelectionModal(context, primaryColor, secondaryColor),
              ),
            ),

            // --- Details & Attachments ---
            _buildSectionLabel('Details', secondaryColor),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _detailsController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Add description...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      icon: Icon(Icons.description_outlined, color: secondaryColor.withOpacity(0.7)),
                    ),
                    onChanged: (val) => _details = val,
                  ),

                  const Divider(color: Colors.white24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.attach_file, color: secondaryColor.withOpacity(0.7)),
                    title: Text('Add Attachment', style: TextStyle(color: Colors.white70)),
                    onTap: () {
                      // TODO: Implement file picker
                    },
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
                  _schedule == null ? 'Set Due Date' : _schedule.toString().split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
                trailing: _schedule != null 
                  ? IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () => setState(() => _schedule = null))
                  : null,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: secondaryColor,
                            onPrimary: primaryColor,
                            surface: primaryColor,
                            onSurface: secondaryColor,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) setState(() => _schedule = date);
                },
              ),
            ),

            // --- Subtasks ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionLabel('Subtasks', secondaryColor),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: secondaryColor),
                  onPressed: _showAddSubtaskDialog,
                ),
              ],
            ),
            if (_subtasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No subtasks yet', style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic)),
              )
            else
              Column(
                children: _subtasks.map((subtask) => ListTile(
                  leading: Icon(Icons.check_circle_outline, color: Colors.white38),
                  title: Text(subtask, style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => setState(() => _subtasks.remove(subtask)),
                  ),
                )).toList(),
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

  void _showMatrixSelectionModal(BuildContext context, Color primaryColor, Color secondaryColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Importance & Urgency', style: TextStyle(color: secondaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildMatrixOption('Do', 'Important & Urgent', ctx, secondaryColor),
              _buildMatrixOption('Schedule', 'Important & Not Urgent', ctx, secondaryColor),
              _buildMatrixOption('Delegate', 'Not Important & Urgent', ctx, secondaryColor),
              _buildMatrixOption('Delete', 'Not Important & Not Urgent', ctx, secondaryColor),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMatrixOption(String label, String sub, BuildContext ctx, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(Icons.circle, size: 12, color: color),
      title: Text(label, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(sub, style: TextStyle(color: Colors.white60, fontSize: 12)),
      onTap: () {
        _setMatrixCategory(label);
        Navigator.pop(ctx);
      },
    );
  }

  void _showAddSubtaskDialog() {
    _subtaskController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Add Subtask', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        content: TextField(
          controller: _subtaskController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(hintText: 'Subtask title', hintStyle: TextStyle(color: Colors.white38)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              if (_subtaskController.text.isNotEmpty) {
                setState(() => _subtasks.add(_subtaskController.text));
                Navigator.pop(ctx);
              }
            },
            child: Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}