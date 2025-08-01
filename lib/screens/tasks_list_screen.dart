import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/tasks_service.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  final TasksService _tasksService = TasksService();
  final ScrollController _scrollController = ScrollController();

  List<Task> _tasks = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 0;
  bool _hasMoreData = true;
  final int _limit = 10;

  // Filter options
  String? _selectedStatus;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreTasks();
      }
    }
  }

  Future<void> _loadTasks({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        _currentPage = 0;
        _hasMoreData = true;
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final response = await _tasksService.getTasks(
        status: _selectedStatus,
        priority: _selectedPriority,
        limit: _limit,
        offset: _currentPage * _limit,
      );

      if (response != null) {
        setState(() {
          if (isRefresh || _currentPage == 0) {
            _tasks = response.tasks;
          } else {
            _tasks.addAll(response.tasks);
          }
          _hasMoreData =
              response.pagination?.hasNext ?? (response.tasks.length == _limit);
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load tasks';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTasks() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;

    try {
      final response = await _tasksService.getTasks(
        status: _selectedStatus,
        priority: _selectedPriority,
        limit: _limit,
        offset: _currentPage * _limit,
      );

      if (response != null) {
        setState(() {
          _tasks.addAll(response.tasks);
          _hasMoreData =
              response.pagination?.hasNext ?? (response.tasks.length == _limit);
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _isLoadingMore = false;
          _currentPage--;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadTasks(isRefresh: true);
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter Tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Status:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedStatus == null,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedStatus = selected
                                  ? null
                                  : _selectedStatus;
                            });
                          },
                        ),
                        ...TaskStatus.values.map(
                          (status) => FilterChip(
                            label: Text(status.value),
                            selected: _selectedStatus == status.value,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedStatus = selected
                                    ? status.value
                                    : null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Priority:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _selectedPriority == null,
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedPriority = selected
                                  ? null
                                  : _selectedPriority;
                            });
                          },
                        ),
                        ...TaskPriority.values.map(
                          (priority) => FilterChip(
                            label: Text(priority.value),
                            selected: _selectedPriority == priority.value,
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedPriority = selected
                                    ? priority.value
                                    : null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _selectedStatus = null;
                              _selectedPriority = null;
                            });
                          },
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                            _loadTasks(isRefresh: true);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: (_selectedStatus != null || _selectedPriority != null)
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _buildContent()),
      floatingActionButton: FloatingActionButton(
        heroTag: "tasks_fab",
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/task-create');
          // If task was created successfully, refresh the tasks list
          if (result == true) {
            _loadTasks(isRefresh: true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _tasks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_hasError && _tasks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
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
                  onPressed: () => _loadTasks(isRefresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_tasks.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No tasks found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first task to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _tasks.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _tasks.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final task = _tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    final bool isOverdue = task.isOverdue;
    final Color priorityColor = _getPriorityColor(task.priority);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: priorityColor, width: 3),
          bottom: BorderSide(
            color: isOverdue ? Colors.red.shade200 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            if (isOverdue)
              const Icon(Icons.warning, color: Colors.red, size: 20),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(task.status),
                const SizedBox(width: 8),
                _buildPriorityChip(task.priority),
              ],
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDueDate(task.dueDate!),
                    style: TextStyle(
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: isOverdue
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (task.owner != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    task.owner!.name,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
            if (task.account != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.account!.name,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
            if (task.contact != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.contact_phone_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.contact!.fullName,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showTaskOptions(context, task);
          },
        ),
        onTap: () async {
          final result = await Navigator.of(
            context,
          ).pushNamed('/task-detail', arguments: task.id);
          // If task was deleted or modified, refresh the tasks list
          if (result == true) {
            _loadTasks(isRefresh: true);
          }
        },
      ),
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskStatus.notStarted:
        backgroundColor = Colors.grey[200]!;
        textColor = Colors.grey[700]!;
        break;
      case TaskStatus.inProgress:
        backgroundColor = Colors.blue[100]!;
        textColor = Colors.blue[700]!;
        break;
      case TaskStatus.completed:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        break;
      case TaskStatus.cancelled:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.value,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    final Color color = _getPriorityColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        priority.value,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
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

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      final days = difference.inDays.abs();
      if (days == 0) {
        return 'Overdue today';
      } else if (days == 1) {
        return 'Overdue by 1 day';
      } else {
        return 'Overdue by $days days';
      }
    } else {
      final days = difference.inDays;
      if (days == 0) {
        return 'Due today';
      } else if (days == 1) {
        return 'Due tomorrow';
      } else if (days < 7) {
        return 'Due in $days days';
      } else {
        return 'Due ${dueDate.day}/${dueDate.month}/${dueDate.year}';
      }
    }
  }

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('View Details'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.of(
                    context,
                  ).pushNamed('/task-detail', arguments: task.id);
                  // If task was deleted or modified, refresh the tasks list
                  if (result == true) {
                    _loadTasks(isRefresh: true);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Task'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.of(
                    context,
                  ).pushNamed('/task-edit', arguments: task.id);
                  // If task was updated successfully, refresh the tasks list
                  if (result == true) {
                    _loadTasks(isRefresh: true);
                  }
                },
              ),
              if (task.status != TaskStatus.completed)
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text('Mark as Complete'),
                  onTap: () {
                    Navigator.pop(context);
                    _markTaskComplete(task);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, task);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: Text(
            'Are you sure you want to delete "${task.subject}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask(task);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _markTaskComplete(Task task) async {
    final success = await _tasksService.updateTask(
      task.id,
      status: TaskStatus.completed.value,
    );

    if (success != null) {
      setState(() {
        final index = _tasks.indexWhere((t) => t.id == task.id);
        if (index != -1) {
          _tasks[index] = success;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task "${task.subject}" marked as complete')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update task')));
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    final success = await _tasksService.deleteTask(task.id);

    if (success) {
      setState(() {
        _tasks.removeWhere((t) => t.id == task.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task.subject}" deleted successfully'),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete task')));
      }
    }
  }
}
