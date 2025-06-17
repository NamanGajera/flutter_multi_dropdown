import 'package:flutter/foundation.dart';

/// A controller class for managing the state of a [FlutterMultiDropdown].
///
/// This controller allows you to programmatically:
/// - Update the selected items
/// - Clear the selection
/// - Listen to selection changes
class MultiDropdownController<T> extends ChangeNotifier {
  List<T> _selectedIds = [];

  /// The currently selected item IDs
  List<T> get selectedIds => _selectedIds;

  /// Updates the selection with the provided list of IDs
  ///
  /// Notifies all listeners of the change
  void updateSelection(List<T> ids) {
    _selectedIds = List.from(ids);
    notifyListeners();
  }

  /// Clears the current selection
  ///
  /// Notifies all listeners of the change
  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }
}
