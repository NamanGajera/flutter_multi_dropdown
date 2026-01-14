import '../core/dropdown_item.dart';

/// Utility functions for dropdown operations
class DropdownHelpers {
  /// Deep compares two lists for equality
  static bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Safely gets the first element or returns null
  static T? firstOrNull<T>(List<T> list) {
    return list.isEmpty ? null : list.first;
  }

  /// Formats selected items for display
  static String formatSelectedItems<T>(
    List<({String name, T id})> items,
    bool showNames,
    int? maxDisplayCount,
  ) {
    if (items.isEmpty) return '';

    if (!showNames) {
      return '${items.length} ${items.length == 1 ? 'item' : 'items'} selected';
    }

    final displayItems = maxDisplayCount != null && items.length > maxDisplayCount ? items.take(maxDisplayCount) : items;

    final names = displayItems.map((item) => item.name).join(', ');

    if (maxDisplayCount != null && items.length > maxDisplayCount) {
      return '$names, +${items.length - maxDisplayCount} more';
    }

    return names;
  }

  /// Validates selection constraints
  static bool canSelectMore({
    required int currentSelectionCount,
    required int? maxSelection,
    required bool isAlreadySelected,
  }) {
    if (maxSelection == null) return true;
    if (isAlreadySelected) return true; // Deselecting is always allowed
    return currentSelectionCount < maxSelection;
  }

  /// Calculates dynamic dropdown height based on item count and configuration
  static double calculateDropdownHeight({
    required int itemCount,
    required int maxVisibleItems,
    required double itemHeight,
    required double minHeight,
    bool hasSearch = false,
    bool hasSelectAll = false,
    bool isLoading = false,
    bool isEmpty = false,
  }) {
    // If loading or empty state, use minHeight
    if (isLoading || isEmpty) {
      return minHeight;
    }

    // Calculate base items to show (limited by maxVisibleItems)
    final visibleItemCount = itemCount.clamp(0, maxVisibleItems);

    // Calculate base height from items
    double height = visibleItemCount * itemHeight;

    // Add extra space for search field if present
    if (hasSearch) {
      height += 56.0; // Approximate height of search field with padding
    }

    // Add extra space for select all if present
    if (hasSelectAll) {
      height += itemHeight; // Select all takes one item height
    }

    // Ensure height is at least minHeight
    return height.clamp(minHeight, double.infinity);
  }

  /// Counts actual displayable items (filtered by search, excluding disabled)
  static int getDisplayItemCount({
    required List<DropDownMenuItemData> items,
    required String searchQuery,
  }) {
    if (searchQuery.isEmpty) {
      return items.length;
    }

    return items.where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase())).length;
  }
}
