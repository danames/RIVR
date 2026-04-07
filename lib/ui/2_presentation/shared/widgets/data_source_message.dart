// lib/ui/2_presentation/shared/widgets/data_source_message.dart

import 'package:flutter/cupertino.dart';
import 'package:rivr/ui/1_state/shared/section_load_state.dart';

/// Human-readable forecast type labels for user-facing messages.
String _forecastLabel(String forecastType) {
  switch (forecastType) {
    case 'short_range':
      return 'short-range';
    case 'medium_range':
      return 'medium-range';
    case 'long_range':
      return 'long-range';
    default:
      return forecastType.replaceAll('_', ' ');
  }
}

/// Transparent data-source messaging widget (Phase 3).
///
/// Shows contextual, plain-language messages based on [SectionLoadState].
/// Differentiates between transient server issues, permanent no-coverage,
/// and loading states so users always understand what's happening.
class DataSourceMessage extends StatelessWidget {
  final SectionLoadState state;
  final String forecastType;
  final VoidCallback? onRetry;

  /// If true, uses a compact single-line layout (for inline use in cards).
  /// If false, uses a centered full-page layout (for empty/error states).
  final bool compact;

  const DataSourceMessage({
    super.key,
    required this.state,
    required this.forecastType,
    this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) return _buildCompact(context);
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    final (icon, color) = _iconAndColor(state);
    return Row(
      children: [
        Icon(icon, size: 14, color: color.resolveFrom(context)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            _message(),
            style: TextStyle(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFull(BuildContext context) {
    final (icon, color) = _iconAndColor(state);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color.resolveFrom(context)),
            const SizedBox(height: 16),
            Text(
              _title(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _message(),
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null && _showRetry()) ...[
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _title() {
    final label = _forecastLabel(forecastType);
    switch (state) {
      case SectionLoadState.loading:
        return 'Loading Forecast';
      case SectionLoadState.loaded:
        return 'Forecast Loaded';
      case SectionLoadState.empty:
        return 'Forecast Temporarily Unavailable';
      case SectionLoadState.error:
        return 'Unable to Load Forecast';
      case SectionLoadState.unavailable:
        return 'No ${label[0].toUpperCase()}${label.substring(1)} Coverage';
      case SectionLoadState.idle:
        return 'Waiting to Load';
    }
  }

  String _message() {
    final label = _forecastLabel(forecastType);
    switch (state) {
      case SectionLoadState.loading:
        return 'Fetching $label forecast from NOAA National Water Model...';
      case SectionLoadState.loaded:
        return 'Data: NOAA National Water Model';
      case SectionLoadState.empty:
        return 'The NOAA National Water Model $label forecast is temporarily '
            'unavailable. This usually resolves on its own \u2014 try '
            'refreshing in a few minutes.';
      case SectionLoadState.error:
        return 'Something went wrong loading the $label forecast. '
            'Pull down to retry.';
      case SectionLoadState.unavailable:
        return 'This reach does not have $label coverage '
            'in the National Water Model.';
      case SectionLoadState.idle:
        return 'Waiting to load $label forecast...';
    }
  }

  (IconData, CupertinoDynamicColor) _iconAndColor(SectionLoadState s) {
    switch (s) {
      case SectionLoadState.loading:
        return (
          CupertinoIcons.clock,
          CupertinoColors.secondaryLabel,
        );
      case SectionLoadState.loaded:
        return (
          CupertinoIcons.checkmark_circle,
          CupertinoColors.systemGreen,
        );
      case SectionLoadState.empty:
        return (
          CupertinoIcons.exclamationmark_circle,
          CupertinoColors.systemOrange,
        );
      case SectionLoadState.error:
        return (
          CupertinoIcons.exclamationmark_triangle,
          CupertinoColors.systemRed,
        );
      case SectionLoadState.unavailable:
        return (
          CupertinoIcons.xmark_circle,
          CupertinoColors.systemGrey,
        );
      case SectionLoadState.idle:
        return (
          CupertinoIcons.clock,
          CupertinoColors.systemGrey,
        );
    }
  }

  bool _showRetry() {
    return state == SectionLoadState.error || state == SectionLoadState.empty;
  }
}

/// Small, unobtrusive data source attribution label.
///
/// Use this on loaded forecast sections to show where data comes from.
class DataSourceAttribution extends StatelessWidget {
  const DataSourceAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.info_circle,
            size: 12,
            color: CupertinoColors.tertiaryLabel.resolveFrom(context),
          ),
          const SizedBox(width: 4),
          Text(
            'Data: NOAA National Water Model',
            style: TextStyle(
              fontSize: 11,
              color: CupertinoColors.tertiaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
