import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/api_models.dart';
import '../services/tasks_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TasksService _tasksService = TasksService();

  Task? _task;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  Future<void> _loadTaskDetails() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final task = await _tasksService.getTaskById(widget.taskId);

      if (task != null && mounted) {
        setState(() {
          _task = task;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Task not found';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _copyToClipboard(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.normal:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
    IconData? icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool copyable = false,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: copyable ? () => _copyToClipboard(value, label) : null,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: copyable ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildStatusPriorityChips() {
    if (_task == null) return const SizedBox.shrink();

    return Row(
      children: [
        // Status Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(_task!.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(_task!.status).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            _task!.status.value,
            style: TextStyle(
              color: _getStatusColor(_task!.status),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Priority Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getPriorityColor(_task!.priority).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getPriorityColor(_task!.priority).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flag,
                size: 14,
                color: _getPriorityColor(_task!.priority),
              ),
              const SizedBox(width: 4),
              Text(
                _task!.priority.value,
                style: TextStyle(
                  color: _getPriorityColor(_task!.priority),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _markTaskComplete() async {
    if (_task == null) return;

    try {
      final updatedTask = await _tasksService.updateTask(
        _task!.id,
        status: TaskStatus.completed.value,
      );

      if (updatedTask != null && mounted) {
        setState(() {
          _task = updatedTask;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${_task!.subject}" marked as complete'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update task'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation() {
    if (_task == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete "${_task!.subject}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask() async {
    if (_task == null) return;

    try {
      final success = await _tasksService.deleteTask(_task!.id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${_task!.subject}" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to the tasks list
        Navigator.of(
          context,
        ).pop(true); // Return true to indicate task was deleted
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete task'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCommentItem(TaskComment comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    comment.author?.name.isNotEmpty == true
                        ? comment.author!.name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author?.name ?? 'Unknown User',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDateTime(comment.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (comment.isPrivate)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Private',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_task?.subject ?? 'Task Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (_task != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.of(
                  context,
                ).pushNamed('/task-edit', arguments: widget.taskId);
                // If task was updated successfully, refresh the task details
                if (result == true) {
                  _loadTaskDetails();
                }
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'complete':
                    _markTaskComplete();
                    break;
                  case 'delete':
                    _showDeleteConfirmation();
                    break;
                }
              },
              itemBuilder: (context) => [
                if (_task!.status != TaskStatus.completed)
                  const PopupMenuItem(
                    value: 'complete',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Mark as Complete'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete Task'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTaskDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_task == null) {
      return const Center(child: Text('Task not found'));
    }

    return RefreshIndicator(
      onRefresh: _loadTaskDetails,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header with Status and Priority
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _task!.subject,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusPriorityChips(),
                    if (_task!.isOverdue) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Overdue',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Description
            if (_task!.description != null && _task!.description!.isNotEmpty)
              _buildInfoSection(
                title: 'Description',
                icon: Icons.description,
                children: [
                  Text(
                    _task!.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

            // Task Details
            _buildInfoSection(
              title: 'Task Details',
              icon: Icons.info_outline,
              children: [
                if (_task!.dueDate != null)
                  _buildInfoRow(
                    label: 'Due Date',
                    value: _formatDateTime(_task!.dueDate!),
                  ),
                _buildInfoRow(
                  label: 'Created',
                  value: _formatDateTime(_task!.createdAt),
                ),
                if (_task!.updatedAt != _task!.createdAt)
                  _buildInfoRow(
                    label: 'Updated',
                    value: _formatDateTime(_task!.updatedAt),
                  ),
              ],
            ),

            // Owner Information
            if (_task!.owner != null || _task!.createdBy != null)
              _buildInfoSection(
                title: 'People',
                icon: Icons.people_outline,
                children: [
                  if (_task!.owner != null) ...[
                    _buildInfoRow(
                      label: 'Owner',
                      value: _task!.owner!.name,
                      copyable: true,
                    ),
                    _buildInfoRow(
                      label: 'Email',
                      value: _task!.owner!.email,
                      copyable: true,
                    ),
                  ],
                  if (_task!.createdBy != null &&
                      _task!.createdBy!.id != _task!.owner?.id) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      label: 'Created By',
                      value: _task!.createdBy!.name,
                      copyable: true,
                    ),
                  ],
                ],
              ),

            // Related Records
            if (_task!.account != null ||
                _task!.contact != null ||
                _task!.opportunity != null)
              _buildInfoSection(
                title: 'Related Records',
                icon: Icons.link,
                children: [
                  if (_task!.account != null) ...[
                    _buildInfoRow(
                      label: 'Account',
                      value: _task!.account!.name,
                    ),
                    if (_task!.account!.phone != null)
                      _buildInfoRow(
                        label: 'Phone',
                        value: _task!.account!.phone!,
                        copyable: true,
                      ),
                    if (_task!.account!.website != null)
                      _buildInfoRow(
                        label: 'Website',
                        value: _task!.account!.website!,
                        copyable: true,
                      ),
                  ],
                  if (_task!.contact != null) ...[
                    if (_task!.account != null) const SizedBox(height: 8),
                    _buildInfoRow(
                      label: 'Contact',
                      value: _task!.contact!.fullName,
                    ),
                    if (_task!.contact!.email != null)
                      _buildInfoRow(
                        label: 'Email',
                        value: _task!.contact!.email!,
                        copyable: true,
                      ),
                    if (_task!.contact!.phone != null)
                      _buildInfoRow(
                        label: 'Phone',
                        value: _task!.contact!.phone!,
                        copyable: true,
                      ),
                  ],
                  if (_task!.opportunity != null) ...[
                    if (_task!.account != null || _task!.contact != null)
                      const SizedBox(height: 8),
                    _buildInfoRow(
                      label: 'Opportunity',
                      value: _task!.opportunity!.name,
                    ),
                    _buildInfoRow(
                      label: 'Amount',
                      value:
                          '\$${_task!.opportunity!.amount.toStringAsFixed(2)}',
                    ),
                    _buildInfoRow(
                      label: 'Stage',
                      value: _task!.opportunity!.stage,
                    ),
                  ],
                ],
              ),

            // Comments Section
            if (_task!.comments != null && _task!.comments!.isNotEmpty)
              _buildInfoSection(
                title: 'Comments (${_task!.comments!.length})',
                icon: Icons.comment_outlined,
                children: [
                  Column(
                    children: _task!.comments!
                        .map((comment) => _buildCommentItem(comment))
                        .toList(),
                  ),
                ],
              ),

            const SizedBox(height: 80), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }
}
