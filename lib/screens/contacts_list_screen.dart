import 'package:flutter/material.dart';
import '../models/api_models.dart';
import '../services/contacts_service.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final ContactsService _contactsService = ContactsService();
  final ScrollController _scrollController = ScrollController();

  List<Contact> _contacts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
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
        _loadMoreContacts();
      }
    }
  }

  Future<void> _loadContacts({bool isRefresh = false}) async {
    debugPrint('Loading contacts - refresh: $isRefresh');
    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _hasMoreData = true;
        _isLoading = true;
        _hasError = false;
      });
    }

    try {
      final response = await _contactsService.getContacts(page: _currentPage);

      if (response != null) {
        setState(() {
          if (isRefresh || _currentPage == 1) {
            _contacts = response.contacts;
          } else {
            _contacts.addAll(response.contacts);
          }
          _hasMoreData = response.pagination?.hasNext ?? false;
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load contacts';
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

  Future<void> _loadMoreContacts() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    _currentPage++;

    try {
      final response = await _contactsService.getContacts(page: _currentPage);

      if (response != null) {
        setState(() {
          _contacts.addAll(response.contacts);
          _hasMoreData = response.pagination?.hasNext ?? false;
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
    await _loadContacts(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: RefreshIndicator(onRefresh: _onRefresh, child: _buildContent()),
      floatingActionButton: FloatingActionButton(
        heroTag: "contacts_fab",
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).pushNamed('/contact-create');
          // If contact was created successfully, refresh the contacts list
          if (result == true) {
            _loadContacts(isRefresh: true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _contacts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (_hasError && _contacts.isEmpty) {
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
                  onPressed: () => _loadContacts(isRefresh: true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (_contacts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.contacts_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No contacts found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your first contact to get started',
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
      itemCount: _contacts.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _contacts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final contact = _contacts[index];
        return _buildContactCard(contact);
      },
    );
  }

  Widget _buildContactCard(Contact contact) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            contact.firstName.isNotEmpty
                ? contact.firstName[0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.title != null) ...[
              const SizedBox(height: 4),
              Text(
                contact.title!,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
            if (contact.email != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      contact.email!,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
            if (contact.phone != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    contact.phone!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
            if (contact.owner != null) ...[
              const SizedBox(height: 4),
              Text(
                'Owner: ${contact.owner!.fullName}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showContactOptions(context, contact);
          },
        ),
        onTap: () {
          Navigator.of(
            context,
          ).pushNamed('/contact-detail', arguments: contact.id);
        },
      ),
    );
  }

  void _showContactOptions(BuildContext context, Contact contact) {
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                  ).pushNamed('/contact-detail', arguments: contact.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Contact'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to edit contact
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Contact',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, contact);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Contact'),
          content: Text(
            'Are you sure you want to delete ${contact.fullName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteContact(contact);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteContact(Contact contact) async {
    final success = await _contactsService.deleteContact(contact.id);

    if (success) {
      setState(() {
        _contacts.removeWhere((c) => c.id == contact.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${contact.fullName} deleted successfully')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete contact')),
        );
      }
    }
  }
}
