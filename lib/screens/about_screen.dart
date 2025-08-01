import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
        });
      }
    } catch (e) {
      debugPrint('Error loading package info: $e');
    }
  }

  Widget _buildInfoCard({
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

  Widget _buildInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
    VoidCallback? onTap,
    bool copyable = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: copyable
            ? () {
                HapticFeedback.lightImpact();
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Copied $label to clipboard'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
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
              if (copyable)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
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

  Widget _buildFeatureChip({
    required String label,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'About BottleCRM',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          // App Hero Section
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                    theme.colorScheme.primary.withValues(alpha: 0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // App Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/icon/icon.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // App Name and Version
                    Text(
                      'BottleCRM',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'CRM for everyone',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Company Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business_rounded,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'by MicroPyramid',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    if (_packageInfo != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Version ${_packageInfo!.version} (${_packageInfo!.buildNumber})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // App Information
          RepaintBoundary(
            child: _buildInfoCard(
              title: 'App Information',
              icon: Icons.info_rounded,
              theme: theme,
              children: [
                if (_packageInfo != null) ...[
                  _buildInfoRow(
                    label: 'Package Name',
                    value: _packageInfo!.packageName,
                    theme: theme,
                    copyable: true,
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                  _buildInfoRow(
                    label: 'Version',
                    value: _packageInfo!.version,
                    theme: theme,
                    copyable: true,
                  ),
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    color: theme.dividerColor.withValues(alpha: 0.3),
                  ),
                  _buildInfoRow(
                    label: 'Build Number',
                    value: _packageInfo!.buildNumber,
                    theme: theme,
                    copyable: true,
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Key Features
          RepaintBoundary(
            child: _buildInfoCard(
              title: 'Key Features',
              icon: Icons.star_rounded,
              theme: theme,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    children: [
                      _buildFeatureChip(
                        label: 'Lead Management',
                        icon: Icons.person_add_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Contact Management',
                        icon: Icons.contacts_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Task Tracking',
                        icon: Icons.task_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Multi-tenant',
                        icon: Icons.business_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Dashboard Analytics',
                        icon: Icons.analytics_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Google OAuth',
                        icon: Icons.security_rounded,
                        theme: theme,
                      ),
                      _buildFeatureChip(
                        label: 'Open Source',
                        icon: Icons.code_rounded,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Company Information
          RepaintBoundary(
            child: _buildInfoCard(
              title: 'Developed by',
              icon: Icons.business_center_rounded,
              theme: theme,
              children: [
                _buildInfoRow(
                  label: 'Company',
                  value: 'MicroPyramid',
                  theme: theme,
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
                _buildInfoRow(
                  label: 'Website',
                  value: 'micropyramid.com',
                  theme: theme,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // TODO: Launch website URL
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Visit micropyramid.com for more information',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        action: SnackBarAction(
                          label: 'Copy',
                          onPressed: () {
                            Clipboard.setData(
                              const ClipboardData(
                                text: 'https://micropyramid.com',
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
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
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.description_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'About MicroPyramid',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
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
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Text(
                          'MicroPyramid is a technology company specializing in open-source CRM solutions and custom software development. We are committed to building accessible, user-friendly business tools that help organizations manage their customer relationships effectively.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
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

          // System Information
          RepaintBoundary(
            child: _buildInfoCard(
              title: 'System Information',
              icon: Icons.phone_android_rounded,
              theme: theme,
              children: [
                _buildInfoRow(
                  label: 'Platform',
                  value: Platform.isAndroid
                      ? 'Android'
                      : Platform.isIOS
                      ? 'iOS'
                      : 'Unknown',
                  theme: theme,
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
                _buildInfoRow(
                  label: 'Framework',
                  value: 'Flutter',
                  theme: theme,
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
                _buildInfoRow(label: 'Language', value: 'Dart', theme: theme),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Legal Information
          RepaintBoundary(
            child: _buildInfoCard(
              title: 'Legal',
              icon: Icons.gavel_rounded,
              theme: theme,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      showLicensePage(
                        context: context,
                        applicationName: 'BottleCRM',
                        applicationVersion: _packageInfo?.version ?? '1.0.0',
                        applicationIcon: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.business_center_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Open Source Licenses',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'View third-party licenses',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
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
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Development Information
          RepaintBoundary(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.code_rounded,
                    size: 32,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Made with ❤️ using Flutter',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Developed by MicroPyramid',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} MicroPyramid. All rights reserved.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
