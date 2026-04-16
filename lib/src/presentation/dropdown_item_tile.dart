import 'package:flutter/material.dart';
import '../core/dropdown_item.dart';
import '../themes/dropdown_decoration.dart';
import '../utils/dropdown_selection_mode.dart';

/// A widget that renders a single selectable item in the dropdown list.
///
/// The [DropdownItemTile] handles the visual representation of a dropdown item,
/// automatically adapting its appearance based on selection mode and item state.
/// It supports both checkbox (multi-select) and radio button (single-select) styles.
///
/// ## Features
///
/// - **Adaptive Selection UI**: Automatically switches between radio (single)
///   and checkbox (multi) based on [selectionMode]
/// - **Disabled State**: Visually dims and disables interaction when [item.enabled] is false
/// - **Customizable**: Supports custom item builders for complete UI control
/// - **Consistent Sizing**: Maintains uniform height across all items
/// - **Theme Integration**: Respects Material Design theming
///
/// ## Visual States
///
/// ### Enabled State
/// - Full opacity
/// - Interactive (responds to taps)
/// - Shows selection state via radio/checkbox
///
/// ### Disabled State
/// - 50% opacity
/// - Non-interactive (taps are ignored)
/// - Selection state is still visible but greyed out
///
/// ## Usage Examples
///
/// ### Basic Usage
/// ```dart
/// DropdownItemTile<int>(
///   item: myItem,
///   isSelected: false,
///   onChanged: (value) => handleToggle(),
///   decoration: myDecoration,
///   selectionMode: DropdownSelectionMode.multiple,
/// )
/// ```
///
/// ### Custom Styling
/// ```dart
/// DropdownItemTile<String>(
///   item: item,
///   isSelected: selectedIds.contains(item.id),
///   onChanged: (value) => toggleItem(item.id),
///   decoration: DropdownDecoration(
///     itemHeight: 56,
///     itemTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
///     checkboxActiveColor: Colors.green,
///   ),
///   selectionMode: DropdownSelectionMode.multiple,
/// )
/// ```
///
/// ### With Custom Builder
/// ```dart
/// // This is typically handled by FlutterMultiDropdown's itemBuilder
/// DropdownItemTile<User>(
///   item: userItem,
///   isSelected: isSelected,
///   onChanged: onChanged,
///   decoration: decoration,
///   selectionMode: mode,
///   itemBuilder: (context, item, isSelected, onChanged) {
///     return CustomUserTile(user: item, isSelected: isSelected);
///   },
/// )
/// ```
///
/// See also:
/// - [DropdownListView] which uses this widget to render the list
/// - [DropDownMenuItemData] for item data structure
/// - [DropdownDecoration] for styling options
class DropdownItemTile<T> extends StatelessWidget {
  /// The data for this dropdown item
  final DropDownMenuItemData<T> item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback triggered when the item's selection state should change
  ///
  /// The callback receives a boolean indicating the new selection state.
  /// When null, the item is non-interactive (disabled).
  final ValueChanged<bool?>? onChanged;

  /// Styling configuration for the item
  final DropdownDecoration decoration;

  /// The selection mode determining whether to show radio or checkbox
  final DropdownSelectionMode selectionMode;

  /// Custom builder for complete UI control
  ///
  /// If provided, this overrides the default radio/checkbox tile rendering.
  final Widget? Function(
    BuildContext,
    DropDownMenuItemData<T>,
    bool,
    ValueChanged<bool?>?,
  )? itemBuilder;

  /// Creates a [DropdownItemTile] widget.
  ///
  /// All parameters except [itemBuilder] are required.
  const DropdownItemTile({
    super.key,
    required this.item,
    required this.isSelected,
    this.onChanged,
    required this.decoration,
    required this.selectionMode,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (itemBuilder != null) {
      return SizedBox(
        height: decoration.itemHeight,
        child: itemBuilder!(context, item, isSelected, onChanged),
      );
    }

    return SizedBox(
      height: decoration.itemHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Opacity(
          opacity: item.enabled ? 1.0 : 0.5,
          child: selectionMode == DropdownSelectionMode.single
              ? RadioListTile<T>(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  dense: true,
                  title: Text(
                    item.name,
                    style: decoration.textStyle.item?.copyWith(
                      color: item.enabled ? (decoration.textStyle.item?.color ?? Colors.black) : Colors.grey,
                    ),
                  ),
                  value: item.id,
                  groupValue: isSelected ? item.id : null,
                  onChanged: item.enabled ? (_) => onChanged?.call(!isSelected) : null,
                  activeColor: decoration.checkboxDecoration.activeColor,
                  controlAffinity: ListTileControlAffinity.leading,
                )
              : CheckboxListTile(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  dense: true,
                  title: Text(
                    item.name,
                    style: decoration.textStyle.item?.copyWith(
                      color: item.enabled ? (decoration.textStyle.item?.color ?? Colors.black) : Colors.grey,
                    ),
                  ),
                  checkColor: decoration.checkboxDecoration.checkIconColor ?? const Color(0xFFFFFFFF),
                  value: isSelected,
                  onChanged: item.enabled ? onChanged : null,
                  activeColor: decoration.checkboxDecoration.activeColor,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
        ),
      ),
    );
  }
}
