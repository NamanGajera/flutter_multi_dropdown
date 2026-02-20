import 'package:flutter/material.dart';
import '../core/dropdown_item.dart';
import '../themes/dropdown_decoration.dart';
import '../utils/dropdown_selection_mode.dart';
import 'dropdown_item_tile.dart';

/// A widget that renders a scrollable list of dropdown items.
///
/// The [DropdownListView] manages the display of a list of selectable items,
/// handling empty states and providing a consistent scrolling experience.
/// It serves as the main content area of the dropdown overlay.
///
/// ## Features
///
/// - **Scrollable List**: Automatically scrolls when content exceeds available space
/// - **Empty State Handling**: Shows appropriate UI when no items are available
/// - **Selection Highlighting**: Visually indicates selected items
/// - **Consistent Item Rendering**: Uses [DropdownItemTile] for uniform appearance
/// - **Customizable**: Supports custom item builders and empty state builders
///
/// ## When to Use
///
/// This widget is primarily used internally by [FlutterMultiDropdown], but can be
/// useful when building custom dropdown implementations that need consistent
/// item list rendering.
///
/// ## Performance
///
/// The list uses [ListView.builder] for efficient memory usage, only building
/// items as they become visible during scrolling.
///
/// ## Usage Example
///
/// ```dart
/// DropdownListView<int>(
///   items: myItems,
///   selectedIds: selectedIds.toSet(),
///   onItemTap: (id) => handleItemSelection(id),
///   decoration: myDecoration,
///   selectionMode: DropdownSelectionMode.multiple,
///   itemBuilder: myCustomItemBuilder,
///   emptyBuilder: (context) => Center(
///     child: Text('No items match your search'),
///   ),
/// )
/// ```
///
/// See also:
/// - [DropdownItemTile] for individual item rendering
/// - [DropDownMenuItemData] for item data structure
/// - [DropdownDecoration] for styling options
class DropdownListView<T> extends StatelessWidget {
  /// The list of items to display
  final List<DropDownMenuItemData<T>> items;

  /// Set of currently selected item IDs
  ///
  /// Using a Set provides O(1) lookup for selection checks.
  final Set<T> selectedIds;

  /// Callback triggered when an item is tapped
  ///
  /// Provides the ID of the tapped item.
  final Function(T) onItemTap;

  /// Styling configuration for items
  final DropdownDecoration decoration;

  /// Selection mode affecting item appearance
  final DropdownSelectionMode selectionMode;

  /// Custom builder for individual items
  ///
  /// If provided, overrides the default item rendering.
  final Widget? Function(
    BuildContext,
    DropDownMenuItemData<T>,
    bool,
    ValueChanged<bool?>?,
  )? itemBuilder;

  /// Custom builder for empty state
  ///
  /// Called when [items] is empty. If not provided, shows a default
  /// "No items found" message.
  final WidgetBuilder? emptyBuilder;

  /// Creates a [DropdownListView] widget.
  ///
  /// All parameters except [itemBuilder] and [emptyBuilder] are required.
  const DropdownListView({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onItemTap,
    required this.decoration,
    required this.selectionMode,
    this.itemBuilder,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedIds.contains(item.id);

        return DropdownItemTile<T>(
          item: item,
          isSelected: isSelected,
          onChanged: item.enabled ? (value) => onItemTap(item.id) : null,
          decoration: decoration,
          selectionMode: selectionMode,
          itemBuilder: itemBuilder,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return emptyBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('No items found')),
        );
  }
}
