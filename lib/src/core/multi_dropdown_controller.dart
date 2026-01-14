import 'package:flutter/foundation.dart';

/// A controller class for managing the state of a [FlutterMultiDropdown].
///
/// This controller allows you to programmatically:
/// - Update the selected items
/// - Clear the selection
/// - Listen to selection changes
/// - Synchronize with API data
///
/// Example:
/// ```dart
/// final controller = MultiDropdownController<int>();
///
/// // Update selection
/// controller.updateSelection([1, 2, 3]);
///
/// // Clear selection
/// controller.clearSelection();
///
/// // Listen to changes
/// controller.addListener(() {
///   print('Selected IDs: ${controller.selectedIds}');
/// });
/// ```
class MultiDropdownController<T> extends ChangeNotifier {
  List<T> _selectedIds = [];

  /// The currently selected item IDs
  List<T> get selectedIds => List.unmodifiable(_selectedIds);

  /// Whether the controller has any selected items
  bool get hasSelection => _selectedIds.isNotEmpty;

  /// Updates the selection with the provided list of IDs
  ///
  /// This method is particularly useful when items are loaded from an API
  /// and you need to restore previous selections. It handles the case where
  /// items might be added to the dropdown after the controller is created.
  ///
  /// [ids]: List of IDs to select. Items not present in the dropdown will be
  ///        remembered and selected when they become available.
  ///
  /// Example:
  /// ```dart
  /// // When data is loaded from API, update selection
  /// controller.updateSelection([101, 102, 103]);
  /// ```
  void updateSelection(List<T> ids) {
    _selectedIds = List<T>.from(ids);
    notifyListeners();
  }

  /// Clears the current selection
  ///
  /// Notifies all listeners of the change
  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }

  /// Adds a single ID to the selection
  ///
  /// If the ID is already selected, this method does nothing
  void addSelection(T id) {
    if (!_selectedIds.contains(id)) {
      _selectedIds.add(id);
      notifyListeners();
    }
  }

  /// Removes a single ID from the selection
  void removeSelection(T id) {
    if (_selectedIds.remove(id)) {
      notifyListeners();
    }
  }

  /// Toggles the selection of a single ID
  void toggleSelection(T id) {
    if (_selectedIds.contains(id)) {
      removeSelection(id);
    } else {
      addSelection(id);
    }
  }

  /// Checks if a specific ID is selected
  bool isSelected(T id) {
    return _selectedIds.contains(id);
  }

  @override
  void dispose() {
    _selectedIds.clear();
    super.dispose();
  }
}
