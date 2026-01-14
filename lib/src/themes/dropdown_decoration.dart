import 'package:flutter/material.dart';
import 'dropdown_search_decoration.dart';

/// Customization options for the appearance of [FlutterMultiDropdown].
///
/// This class provides extensive styling options for both the dropdown button
/// and the dropdown list that appears when opened.
///
/// Example:
/// ```dart
/// DropdownDecoration(
///   borderRadius: 8.0,
///   borderColor: Colors.blue,
///   backgroundColor: Colors.white,
///   maxHeight: 300,
///   checkboxActiveColor: Colors.blue,
/// )
/// ```
class DropdownDecoration {
  /// Border radius for both the dropdown button and list
  final double borderRadius;

  /// Border color for both the dropdown button and list
  final Color borderColor;

  /// Background color for both the dropdown button and list
  final Color backgroundColor;

  /// Padding inside the dropdown button
  final EdgeInsetsGeometry contentPadding;

  /// Elevation of the dropdown list
  final double elevation;

  /// Maximum number of visible items in the dropdown list
  ///
  /// If the actual item count is less than this, the dropdown will adjust
  /// its height to fit all items. If there are more items, the list will
  /// be scrollable.
  ///
  /// Defaults to 6 items.
  final int maxVisibleItems;

  /// Height of each dropdown item in pixels
  ///
  /// Used to calculate the total height of the dropdown based on
  /// [maxVisibleItems] or actual item count.
  ///
  /// Defaults to 48.0 pixels (standard ListTile/CheckboxListTile height).
  final double itemHeight;

  /// Minimum height of the dropdown list in pixels
  ///
  /// Ensures the dropdown doesn't become too small when there are few items.
  ///
  /// Defaults to 100.0 pixels.
  final double minHeight;

  /// Text style for the placeholder text when no items are selected
  final TextStyle? placeholderTextStyle;

  /// Text style for the selected items text
  final TextStyle? selectedItemTextStyle;

  /// Text style for items in the dropdown list
  final TextStyle? itemTextStyle;

  /// Color of the checkbox when active (checked)
  final Color? checkboxActiveColor;

  /// Color of the checkbox when inactive (unchecked)
  final Color? checkboxInActiveColor;

  /// Color of the check icon inside the checkbox
  final Color? checkColor;

  /// Width of the checkbox border
  final double checkboxBorderWidth;

  /// Color of the close dropdown icon
  final Color? closeDropdownIconColor;

  /// Color of the open dropdown icon
  final Color? openDropdownIconColor;

  /// Custom widget to replace the default close dropdown icon
  final Widget? closeDropdownIcon;

  /// Custom widget to replace the default open dropdown icon
  final Widget? openDropdownIcon;

  /// Custom size of close dropdown icon
  final double? closeDropdownIconSize;

  /// Custom size of open dropdown icon
  final double? openDropdownIconSize;

  /// Custom decoration for the dropdown button
  final BoxDecoration? dropdownDecoration;

  /// Custom decoration for the dropdown list
  final BoxDecoration? dropdownListDecoration;

  /// Box shadows for the dropdown list
  final List<BoxShadow>? boxShadow;

  /// Decoration options for the search field
  final DropdownSearchDecoration searchDecoration;

  /// Creates a [DropdownDecoration] with customizable appearance options
  const DropdownDecoration({
    this.borderRadius = 6.0,
    this.borderColor = const Color(0xFFE0E0E0),
    this.backgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.elevation = 4.0,
    this.maxVisibleItems = 6,
    this.itemHeight = 48.0,
    this.minHeight = 100.0,
    this.placeholderTextStyle = const TextStyle(
      color: Color(0xFF828282),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.selectedItemTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.itemTextStyle,
    this.checkboxActiveColor,
    this.checkboxInActiveColor,
    this.closeDropdownIconColor = const Color(0xFF757575),
    this.openDropdownIconColor = const Color(0xFF757575),
    this.checkColor,
    this.closeDropdownIcon,
    this.openDropdownIcon,
    this.dropdownDecoration,
    this.dropdownListDecoration,
    this.boxShadow,
    this.checkboxBorderWidth = 1.5,
    this.searchDecoration = const DropdownSearchDecoration(),
    this.closeDropdownIconSize,
    this.openDropdownIconSize,
  });

  /// Creates a copy of this decoration with the given fields replaced
  DropdownDecoration copyWith({
    double? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    double? elevation,
    int? maxVisibleItems,
    double? itemHeight,
    double? minHeight,
    TextStyle? placeholderTextStyle,
    TextStyle? selectedItemTextStyle,
    TextStyle? itemTextStyle,
    Color? checkboxActiveColor,
    Color? checkboxInActiveColor,
    Color? closeDropdownIconColor,
    Color? openDropdownIconColor,
    Color? checkColor,
    Widget? closeDropdownIcon,
    Widget? openDropdownIcon,
    BoxDecoration? dropdownDecoration,
    BoxDecoration? dropdownListDecoration,
    List<BoxShadow>? boxShadow,
    double? checkboxBorderWidth,
    DropdownSearchDecoration? searchDecoration,
    double? closeDropdownIconSize,
    double? openDropdownIconSize,
  }) {
    return DropdownDecoration(
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      contentPadding: contentPadding ?? this.contentPadding,
      elevation: elevation ?? this.elevation,
      maxVisibleItems: maxVisibleItems ?? this.maxVisibleItems,
      itemHeight: itemHeight ?? this.itemHeight,
      minHeight: minHeight ?? this.minHeight,
      placeholderTextStyle: placeholderTextStyle ?? this.placeholderTextStyle,
      selectedItemTextStyle: selectedItemTextStyle ?? this.selectedItemTextStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      checkboxActiveColor: checkboxActiveColor ?? this.checkboxActiveColor,
      checkboxInActiveColor: checkboxInActiveColor ?? this.checkboxInActiveColor,
      closeDropdownIconColor: closeDropdownIconColor ?? this.closeDropdownIconColor,
      openDropdownIconColor: openDropdownIconColor ?? this.openDropdownIconColor,
      checkColor: checkColor ?? this.checkColor,
      closeDropdownIcon: closeDropdownIcon ?? this.closeDropdownIcon,
      openDropdownIcon: openDropdownIcon ?? this.openDropdownIcon,
      dropdownDecoration: dropdownDecoration ?? this.dropdownDecoration,
      dropdownListDecoration: dropdownListDecoration ?? this.dropdownListDecoration,
      boxShadow: boxShadow ?? this.boxShadow,
      checkboxBorderWidth: checkboxBorderWidth ?? this.checkboxBorderWidth,
      searchDecoration: searchDecoration ?? this.searchDecoration,
      closeDropdownIconSize: closeDropdownIconSize ?? this.closeDropdownIconSize,
      openDropdownIconSize: openDropdownIconSize ?? this.openDropdownIconSize,
    );
  }

  @override
  String toString() {
    return 'DropdownDecoration(borderRadius: $borderRadius, borderColor: $borderColor, maxVisibleItems: $maxVisibleItems)';
  }
}
