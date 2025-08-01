import 'package:flutter/material.dart';
import '../services/tasks_service.dart';
import '../models/api_models.dart';

class TaskEditScreen extends StatefulWidget {
  final String taskId;

  const TaskEditScreen({super.key, required this.taskId});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TasksService _tasksService = TasksService();

  // Form controllers
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accountIdController = TextEditingController();
  final TextEditingController _contactIdController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasError = false;
  String? _errorMessage;

  Task? _originalTask;
  TaskStatus _selectedStatus = TaskStatus.notStarted;
  TaskPriority _selectedPriority = TaskPriority.normal;
  DateTime? _selectedDueDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _accountIdController.dispose();
    _contactIdController.dispose();
    super.dispose();
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
          _originalTask = task;
          _populateFormFields(task);
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

  void _populateFormFields(Task task) {
    _subjectController.text = task.subject;
    _descriptionController.text = task.description ?? '';
    _accountIdController.text = task.accountId ?? '';
    _contactIdController.text = task.contactId ?? '';

    _selectedStatus = task.status;
    _selectedPriority = task.priority;

    if (task.dueDate != null) {
      _selectedDueDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      _selectedTime = TimeOfDay(
        hour: task.dueDate!.hour,
        minute: task.dueDate!.minute,
      );
    }
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      DateTime? dueDateTime;
      if (_selectedDueDate != null) {
        // Combine date and time
        final time = _selectedTime ?? const TimeOfDay(hour: 9, minute: 0);
        dueDateTime = DateTime(
          _selectedDueDate!.year,
          _selectedDueDate!.month,
          _selectedDueDate!.day,
          time.hour,
          time.minute,
        );
      }

      final updatedTask = await _tasksService.updateTask(
        widget.taskId,
        subject: _subjectController.text.trim() != _originalTask?.subject
            ? _subjectController.text.trim()
            : null,
        description:
            _descriptionController.text.trim() !=
                (_originalTask?.description ?? '')
            ? (_descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim())
            : null,
        status: _selectedStatus != _originalTask?.status
            ? _selectedStatus.value
            : null,
        priority: _selectedPriority != _originalTask?.priority
            ? _selectedPriority.value
            : null,
        dueDate: dueDateTime != _originalTask?.dueDate ? dueDateTime : null,
        accountId:
            _accountIdController.text.trim() != (_originalTask?.accountId ?? '')
            ? (_accountIdController.text.trim().isEmpty
                  ? null
                  : _accountIdController.text.trim())
            : null,
        contactId:
            _contactIdController.text.trim() != (_originalTask?.contactId ?? '')
            ? (_contactIdController.text.trim().isEmpty
                  ? null
                  : _contactIdController.text.trim())
            : null,
      );

      if (updatedTask != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${updatedTask.subject}" updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
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
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _hasChanges() {
    if (_originalTask == null) return false;

    return _subjectController.text.trim() != _originalTask!.subject ||
        _descriptionController.text.trim() !=
            (_originalTask!.description ?? '') ||
        _selectedStatus != _originalTask!.status ||
        _selectedPriority != _originalTask!.priority ||
        _getDueDateTime() != _originalTask!.dueDate ||
        _accountIdController.text.trim() != (_originalTask!.accountId ?? '') ||
        _contactIdController.text.trim() != (_originalTask!.contactId ?? '');
  }

  DateTime? _getDueDateTime() {
    if (_selectedDueDate == null) return null;

    final time = _selectedTime ?? const TimeOfDay(hour: 9, minute: 0);
    return DateTime(
      _selectedDueDate!.year,
      _selectedDueDate!.month,
      _selectedDueDate!.day,
      time.hour,
      time.minute,
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges()) return true;

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDueDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    if (_selectedDueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date first')),
      );
      return;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        validator:
            validator ??
            (required ? (value) => _validateRequired(value, label) : null),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) getDisplayText,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(getDisplayText(item)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(
      children: [
        // Due Date Selector
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedDueDate != null
                          ? _formatDate(_selectedDueDate!)
                          : 'Select due date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                if (_selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDueDate = null;
                        _selectedTime = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),

        // Time Selector (only show if date is selected)
        if (_selectedDueDate != null) ...[
          const SizedBox(height: 16),
          InkWell(
            onTap: _selectTime,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Time',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedTime != null
                            ? _formatTime(_selectedTime!)
                            : 'Select due time',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges(),
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final navigator = Navigator.of(context);
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            navigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: (_isSaving || !_hasChanges()) ? null : _updateTask,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
        body: _buildBody(),
      ),
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

    if (_originalTask == null) {
      return const Center(child: Text('Task not found'));
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information Section
            _buildSectionHeader('Basic Information'),
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              required: true,
              hint: 'Enter task subject',
            ),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter task description (optional)',
              maxLines: 3,
            ),

            // Task Details Section
            _buildSectionHeader('Task Details'),
            _buildDropdown<TaskStatus>(
              label: 'Status',
              value: _selectedStatus,
              items: TaskStatus.values,
              onChanged: (TaskStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                }
              },
              getDisplayText: (status) => status.value,
              required: true,
            ),
            _buildDropdown<TaskPriority>(
              label: 'Priority',
              value: _selectedPriority,
              items: TaskPriority.values,
              onChanged: (TaskPriority? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPriority = newValue;
                  });
                }
              },
              getDisplayText: (priority) => priority.value,
              required: true,
            ),

            // Due Date and Time Section
            _buildSectionHeader('Due Date & Time'),
            _buildDateTimeSelector(),

            // Associations Section
            _buildSectionHeader('Associations'),
            _buildTextField(
              controller: _accountIdController,
              label: 'Account ID',
              hint: 'Enter associated account ID (optional)',
            ),
            _buildTextField(
              controller: _contactIdController,
              label: 'Contact ID',
              hint: 'Enter associated contact ID (optional)',
            ),

            const SizedBox(height: 32),

            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isSaving || !_hasChanges()) ? null : _updateTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Updating Task...'),
                        ],
                      )
                    : Text(
                        _hasChanges() ? 'Update Task' : 'No Changes',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Help text
            Center(
              child: Text(
                'Fields marked with * are required',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
