import 'package:flutter/material.dart';
import '../themes/dropdown_decoration.dart';

/// A widget that renders a "Select All" option in multi-select dropdowns.
///
/// The [DropdownSelectAllTile] provides a consistent UI for bulk selection
/// operations, allowing users to select or deselect all items with a single tap.
/// It automatically adapts to the dropdown's styling and supports custom builders.
///
/// ## Features
///
/// - **Bulk Selection**: Toggle all items at once
/// - **Visual Feedback**: Shows current "all selected" state
/// - **Customizable**: Supports custom builders for complete UI control
/// - **Consistent Styling**: Inherits colors and dimensions from [DropdownDecoration]
/// - **Material Design**: Follows Material Design guidelines
///
/// ## Behavior
///
/// The tile displays:
/// - A checkbox indicating whether all items are selected
/// - A "Select All" (or custom) label
/// - Appropriate Material Design touch targets
///
/// When tapped, it triggers the provided callback with the new state.
/// The state should be used to update the actual selection of all items.
///
/// ## Usage Examples
///
/// ### Basic Usage
/// ```dart
/// DropdownSelectAllTile(
///   isSelected: _areAllSelected,
///   onChanged: (value) => _toggleSelectAll(),
///   selectAllText: 'Select All',
///   decoration: myDecoration,
/// )
/// ```
///
/// ### With Custom Builder
/// ```dart
/// DropdownSelectAllTile(
///   isSelected: isAllSelected,
///   onChanged: handleSelectAll,
///   decoration: decoration,
///   selectAllBuilder: (context, isSelected, onChanged) {
///     return Container(
///       color: isSelected ? Colors.blue[50] : null,
///       child: ListTile(
///         leading: Icon(
///           isSelected ? Icons.done_all : Icons.select_all,
///           color: isSelected ? Colors.blue : Colors.grey,
///         ),
///         title: Text(
///           isSelected ? 'Deselect All' : 'Select All',
///           style: TextStyle(
///             fontWeight: FontWeight.bold,
///             color: isSelected ? Colors.blue : null,
///           ),
///         ),
///         onTap: () => onChanged!(!isSelected),
///       ),
///     );
///   },
/// )
/// ```
///
/// ### Custom Styling
/// ```dart
/// DropdownSelectAllTile(
///   isSelected: isAllSelected,
///   onChanged: handleSelectAll,
///   selectAllText: 'Choose All Items',
///   decoration: DropdownDecoration(
///     itemHeight: 56,
///     itemTextStyle: TextStyle(
///       fontSize: 16,
///       fontWeight: FontWeight.w600,
///       color: Colors.blue,
///     ),
///     checkboxActiveColor: Colors.blue,
///     checkboxInActiveColor: Colors.grey[400],
///     checkColor: Colors.white,
///   ),
/// )
/// ```
///
/// See also:
/// - [DropdownListView] which positions this tile above the items
/// - [DropdownDecoration] for styling configuration
/// - [FlutterMultiDropdown] for the complete dropdown implementation
class DropdownSelectAllTile extends StatelessWidget {
  /// Whether all items are currently selected
  ///
  /// When true, the checkbox appears checked and the visual state
  /// indicates "deselect all" functionality.
  final bool isSelected;

  /// Callback triggered when the tile is tapped
  ///
  /// Provides the new desired selection state (true to select all,
  /// false to deselect all). The parent should handle the actual
  /// selection/deselection of all items.
  final ValueChanged<bool?>? onChanged;

  /// Custom text for the select all label
  ///
  /// If null, defaults to "Select All".
  final String? selectAllText;

  /// Styling configuration inherited from the parent dropdown
  final DropdownDecoration decoration;

  /// Custom builder for complete UI control
  ///
  /// If provided, overrides the default [CheckboxListTile] rendering.
  /// The builder receives:
  /// - [context] - Build context
  /// - [isSelected] - Current selection state
  /// - [onChanged] - Callback to toggle state
  ///
  /// Example:
  /// ```dart
  /// selectAllBuilder: (context, isSelected, onChanged) {
  ///   return InkWell(
  ///     onTap: () => onChanged!(!isSelected),
  ///     child: Container(
  ///       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ///       child: Row(
  ///         children: [
  ///           Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
  ///           SizedBox(width: 16),
  ///           Text(isSelected ? 'Deselect All' : 'Select All'),
  ///         ],
  ///       ),
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget? Function(
    BuildContext,
    bool,
    ValueChanged<bool?>?,
  )? selectAllBuilder;

  /// Creates a [DropdownSelectAllTile] widget.
  ///
  /// The [isSelected] and [decoration] parameters are required.
  const DropdownSelectAllTile({
    super.key,
    required this.isSelected,
    this.onChanged,
    this.selectAllText,
    required this.decoration,
    this.selectAllBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (selectAllBuilder != null) {
      return SizedBox(
        height: decoration.itemHeight,
        child: selectAllBuilder!(context, isSelected, onChanged),
      );
    }

    return SizedBox(
      height: decoration.itemHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          checkboxTheme: CheckboxThemeData(
            side: BorderSide(
              color: decoration.checkboxInActiveColor ?? const Color(0xFF757575),
              width: decoration.checkboxBorderWidth,
            ),
          ),
        ),
        child: CheckboxListTile(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          dense: true,
          title: Text(
            selectAllText ?? 'Select All',
            style: decoration.itemTextStyle,
          ),
          checkColor: decoration.checkColor ?? const Color(0xFFFFFFFF),
          value: isSelected,
          onChanged: onChanged,
          activeColor: decoration.checkboxActiveColor,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}
