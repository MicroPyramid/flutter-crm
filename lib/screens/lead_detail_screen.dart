import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/api_models.dart';
import '../services/leads_service.dart';

class LeadDetailScreen extends StatefulWidget {
  final String leadId;

  const LeadDetailScreen({super.key, required this.leadId});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  final LeadsService _leadsService = LeadsService();
  Lead? _lead;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeadDetails();
  }

  Future<void> _loadLeadDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final lead = await _leadsService.getLeadById(widget.leadId);
      if (mounted) {
        setState(() {
          _lead = lead;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading lead details: $e')),
        );
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return const Color(0xFF2196F3); // Modern blue
      case 'CONTACTED':
        return const Color(0xFFFF9800); // Vibrant orange
      case 'QUALIFIED':
        return const Color(0xFF4CAF50); // Success green
      case 'LOST':
        return const Color(0xFFE53935); // Error red
      case 'PROPOSAL':
        return const Color(0xFF9C27B0); // Purple
      case 'NEGOTIATION':
        return const Color(0xFF607D8B); // Blue grey
      default:
        return const Color(0xFF757575); // Neutral grey
    }
  }

  Color _getRatingColor(String? rating) {
    switch (rating?.toLowerCase()) {
      case 'hot':
        return const Color(0xFFE53935); // Hot red
      case 'warm':
        return const Color(0xFFFF9800); // Warm orange
      case 'cold':
        return const Color(0xFF2196F3); // Cool blue
      default:
        return const Color(0xFF757575); // Neutral grey
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String? value,
    required ThemeData theme,
    VoidCallback? onTap,
  }) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.launch,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, ThemeData theme) {
    final statusColor = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(String rating, ThemeData theme) {
    final ratingColor = _getRatingColor(rating);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ratingColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ratingColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            size: 16,
            color: ratingColor,
          ),
          const SizedBox(width: 6),
          Text(
            rating.toUpperCase(),
            style: TextStyle(
              color: ratingColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    required ThemeData theme,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.02),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _lead?.fullName ?? 'Lead Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_lead != null) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton.filledTonal(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to edit lead screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Edit functionality coming soon'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!(_lead?.isConverted ?? false))
              Container(
                margin: const EdgeInsets.only(right: 12),
                child: IconButton.filled(
                  icon: const Icon(Icons.transform_rounded),
                  tooltip: 'Convert Lead',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // TODO: Implement convert lead functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Convert functionality coming soon',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lead == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(
                        alpha: 0.1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_off_rounded,
                      size: 64,
                      color: theme.colorScheme.error.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Lead not found',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The lead you\'re looking for doesn\'t exist or has been removed.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _loadLeadDetails,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadLeadDetails,
              child: ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                children: [
                  // Hero Header Card
                  RepaintBoundary(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.03,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar and Status Row
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _lead!.fullName.isNotEmpty
                                          ? _lead!.fullName
                                                .split(' ')
                                                .map(
                                                  (n) =>
                                                      n.isNotEmpty ? n[0] : '',
                                                )
                                                .take(2)
                                                .join()
                                                .toUpperCase()
                                          : 'L',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _lead!.fullName,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              height: 1.1,
                                            ),
                                      ),
                                      if (_lead!.title != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          _lead!.title!,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                      if (_lead!.company != null) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.business_rounded,
                                              size: 16,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                _lead!.company!,
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                _buildStatusChip(_lead!.status, theme),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Rating and Source Row
                            Row(
                              children: [
                                if (_lead!.rating != null) ...[
                                  _buildRatingChip(_lead!.rating!, theme),
                                  const SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.colorScheme.outline
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.source_rounded,
                                          size: 16,
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            _lead!.leadSource,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Converted Status
                            if (_lead!.isConverted) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Successfully Converted',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (_lead!.convertedAt != null)
                                            Text(
                                              DateFormat(
                                                'MMM dd, yyyy • HH:mm',
                                              ).format(_lead!.convertedAt!),
                                              style: TextStyle(
                                                color: Colors.green.withValues(
                                                  alpha: 0.8,
                                                ),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                        ],
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
                  ),

                  // Contact Information
                  RepaintBoundary(
                    child: _buildSectionCard(
                      title: 'Contact Information',
                      icon: Icons.contact_phone_rounded,
                      theme: theme,
                      children: [
                        _buildInfoRow(
                          icon: Icons.email_rounded,
                          label: 'Email Address',
                          value: _lead!.email,
                          theme: theme,
                          onTap: _lead!.email != null
                              ? () {
                                  HapticFeedback.lightImpact();
                                  // TODO: Launch email app
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Email: ${_lead!.email}'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                        if (_lead!.email != null && _lead!.phone != null)
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: theme.dividerColor.withValues(alpha: 0.3),
                          ),
                        _buildInfoRow(
                          icon: Icons.phone_rounded,
                          label: 'Phone Number',
                          value: _lead!.phone,
                          theme: theme,
                          onTap: _lead!.phone != null
                              ? () {
                                  HapticFeedback.lightImpact();
                                  // TODO: Launch phone app
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Phone: ${_lead!.phone}'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),

                  // Additional Information
                  if (_lead!.industry != null || _lead!.description != null)
                    RepaintBoundary(
                      child: _buildSectionCard(
                        title: 'Additional Information',
                        icon: Icons.info_rounded,
                        theme: theme,
                        children: [
                          _buildInfoRow(
                            icon: Icons.business_center_rounded,
                            label: 'Industry',
                            value: _lead!.industry,
                            theme: theme,
                          ),
                          if (_lead!.industry != null &&
                              _lead!.description != null)
                            Container(
                              height: 1,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              color: theme.dividerColor.withValues(alpha: 0.3),
                            ),
                          if (_lead!.description != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.description_rounded,
                                          size: 20,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'Description',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.colorScheme.outline
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: Text(
                                      _lead!.description!,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            height: 1.5,
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.8),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                  // Owner Information
                  if (_lead!.owner != null)
                    RepaintBoundary(
                      child: _buildSectionCard(
                        title: 'Lead Owner',
                        icon: Icons.person_rounded,
                        theme: theme,
                        children: [
                          _buildInfoRow(
                            icon: Icons.account_circle_rounded,
                            label: 'Name',
                            value: _lead!.owner!.name,
                            theme: theme,
                          ),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: theme.dividerColor.withValues(alpha: 0.3),
                          ),
                          _buildInfoRow(
                            icon: Icons.alternate_email_rounded,
                            label: 'Email Address',
                            value: _lead!.owner!.email,
                            theme: theme,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // TODO: Launch email app
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Owner Email: ${_lead!.owner!.email}',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),

                  // Timeline Information
                  RepaintBoundary(
                    child: _buildSectionCard(
                      title: 'Timeline',
                      icon: Icons.schedule_rounded,
                      theme: theme,
                      children: [
                        _buildInfoRow(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'Created',
                          value: DateFormat(
                            'MMM dd, yyyy • HH:mm',
                          ).format(_lead!.createdAt),
                          theme: theme,
                        ),
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: theme.dividerColor.withValues(alpha: 0.3),
                        ),
                        _buildInfoRow(
                          icon: Icons.update_rounded,
                          label: 'Last Updated',
                          value: DateFormat(
                            'MMM dd, yyyy • HH:mm',
                          ).format(_lead!.updatedAt),
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
