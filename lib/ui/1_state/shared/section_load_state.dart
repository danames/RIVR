// lib/ui/1_state/shared/section_load_state.dart

/// Per-section loading state for forecast data.
///
/// Replaces boolean flags with a richer state model that distinguishes
/// between "empty because still loading", "empty because server returned
/// no data", and "empty because request failed".
enum SectionLoadState {
  /// Not yet started loading.
  idle,

  /// Currently fetching from the API.
  loading,

  /// Successfully loaded with data.
  loaded,

  /// Server returned 200 but data arrays are empty (likely transient).
  empty,

  /// Request failed (timeout, HTTP error, network issue).
  error,

  /// Reach is not covered by this forecast type (permanent).
  unavailable,
}

extension SectionLoadStateX on SectionLoadState {
  bool get isLoading => this == SectionLoadState.loading;
  bool get isLoaded => this == SectionLoadState.loaded;
  bool get isEmpty => this == SectionLoadState.empty;
  bool get isError => this == SectionLoadState.error;
  bool get isUnavailable => this == SectionLoadState.unavailable;
  bool get isIdle => this == SectionLoadState.idle;

  /// Whether data is available for display (only true when loaded with data).
  bool get hasData => this == SectionLoadState.loaded;

  /// Whether the section has finished loading (regardless of outcome).
  bool get isDone =>
      this == SectionLoadState.loaded ||
      this == SectionLoadState.empty ||
      this == SectionLoadState.error ||
      this == SectionLoadState.unavailable;
}
