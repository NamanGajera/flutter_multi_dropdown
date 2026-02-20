import 'package:flutter/material.dart';
import 'multi_dropdown_controller.dart';
import '../utils/dropdown_selection_mode.dart';

/// Manages selection logic and constraints for dropdown items.
///
/// The [DropdownSelectionManager] handles the core selection behavior of the dropdown,
/// including toggling individual items, managing select-all functionality, and
/// enforcing selection limits. It acts as a bridge between the UI and the controller.
///
/// This class is used internally by [FlutterMultiDropdown] but can be useful
/// for custom implementations that need consistent selection logic.
///
/// ## Features
///
/// - **Toggle Individual Items**: Select or deselect single items
/// - **Select All/Deselect All**: Handle bulk selection operations
/// - **Selection Limits**: Enforce maximum selection constraints
/// - **Mode Support**: Handle both single and multi-select modes
/// - **Callbacks**: Trigger actions when limits are reached
///
/// ## Selection Behavior
///
/// ### Single Selection Mode
/// - Selecting a new item automatically deselects the previous one
/// - Select all is disabled
/// - Max selection is always 1
///
/// ### Multi-Select Mode
/// - Items can be toggled independently
/// - Select all selects all enabled items
/// - Max selection limits total selected count
///
/// ## Usage Example
///
/// ```dart
/// final selectionManager = DropdownSelectionManager<int>(
///   mode: DropdownSelectionMode.multiple,
///   maxSelection: 5,
///   onMaxReached: () => print('Maximum selection reached'),
///   controller: myController,
/// );
///
/// // Toggle an item
/// selectionManager.toggleItem(42);
///
/// // Select all enabled items
/// final enabledIds = [1, 2, 3, 4, 5];
/// selectionManager.toggleSelectAll(enabledIds);
///
/// // Check if more can be selected
/// if (selectionManager.canSelectMore()) {
///   // Allow selection
/// }
/// ```
///
/// See also:
/// - [MultiDropdownController] for the underlying data store
/// - [DropdownSelectionMode] for selection mode options
class DropdownSelectionManager<T> {
  /// The selection mode (single or multiple)
  final DropdownSelectionMode mode;

  /// Maximum number of items that can be selected
  ///
  /// If null, no limit is enforced.
  final int? maxSelection;

  /// Callback triggered when selection limit is reached
  final VoidCallback? onMaxReached;

  /// The controller managing the actual selection state
  final MultiDropdownController<T> controller;

  /// Creates a [DropdownSelectionManager] with the specified configuration.
  ///
  /// All parameters are required.
  DropdownSelectionManager({
    required this.mode,
    this.maxSelection,
    this.onMaxReached,
    required this.controller,
  });

  /// Toggles the selection state of a single item.
  ///
  /// In single selection mode:
  /// - Sets the provided ID as the only selected item
  ///
  /// In multi-select mode:
  /// - If already selected: Deselects the item
  /// - If not selected: Selects the item, respecting [maxSelection] limit
  ///
  /// When [maxSelection] is reached, triggers [onMaxReached] callback
  /// and does not select the new item.
  ///
  /// Example:
  /// ```dart
  /// // Toggle item with ID 5
  /// selectionManager.toggleItem(5);
  /// ```
  void toggleItem(T id) {
    if (mode == DropdownSelectionMode.single) {
      controller.updateSelection([id]);
      return;
    }

    final current = controller.selectedIds;

    if (current.contains(id)) {
      controller.removeSelection(id);
      return;
    }

    if (maxSelection != null && current.length >= maxSelection!) {
      onMaxReached?.call();
      return;
    }

    controller.addSelection(id);
  }

  /// Toggles selection of all enabled items.
  ///
  /// This method implements "Select All" and "Deselect All" functionality.
  /// Only applicable in multi-select mode; does nothing in single mode.
  ///
  /// Behavior:
  /// - If all items are selected: Deselects all items
  /// - Otherwise: Selects all items, respecting [maxSelection] limit
  ///
  /// The [enabledIds] list should contain IDs of all items that are
  /// currently enabled and visible (respecting any search filter).
  ///
  /// Example:
  /// ```dart
  /// // Get all enabled item IDs
  /// final enabledIds = items
  ///   .where((item) => item.enabled)
  ///   .map((item) => item.id)
  ///   .toList();
  ///
  /// // Toggle select all
  /// selectionManager.toggleSelectAll(enabledIds);
  /// ```
  void toggleSelectAll(List<T> enabledIds) {
    if (mode != DropdownSelectionMode.multiple) return;

    final allSelected = enabledIds.every(controller.selectedIds.contains);

    if (allSelected) {
      for (final id in enabledIds) {
        controller.removeSelection(id);
      }
    } else {
      for (final id in enabledIds) {
        if (maxSelection != null && controller.selectedIds.length >= maxSelection!) {
          break;
        }
        controller.addSelection(id);
      }
    }
  }

  /// Checks whether more items can be selected.
  ///
  /// Returns true if:
  /// - In single mode and no item is selected
  /// - In multi-mode and [maxSelection] is not reached
  ///
  /// Returns false if:
  /// - In single mode and an item is already selected
  /// - In multi-mode and [maxSelection] is reached
  ///
  /// Example:
  /// ```dart
  /// if (selectionManager.canSelectMore()) {
  ///   // Allow selection
  /// } else {
  ///   // Show limit reached message
  /// }
  /// ```
  bool canSelectMore() {
    if (mode == DropdownSelectionMode.single) return controller.selectedIds.isEmpty;
    if (maxSelection == null) return true;
    return controller.selectedIds.length < maxSelection!;
  }

  /// Returns the current number of selected items.
  int get selectedCount => controller.selectedIds.length;
}
