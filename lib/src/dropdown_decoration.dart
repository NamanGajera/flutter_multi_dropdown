import 'package:flutter/material.dart';
import 'package:flutter_multi_dropdown/src/dropdown_search_decoration.dart';

/// Customization options for the appearance of [FlutterMultiDropdown].
///
/// This class provides extensive styling options for both the dropdown button
/// and the dropdown list that appears when opened.
class DropdownDecoration {
  /// Border radius for both the dropdown button and list
  final double borderRadius;

  /// Border color for both the dropdown button and list
  final Color borderColor;

  /// Background color for both the dropdown button and list
  final Color backgroundColor;

  /// Padding inside the dropdown button
  final EdgeInsets contentPadding;

  /// Elevation of the dropdown list
  final double elevation;

  /// Maximum height of the dropdown list
  final double maxHeight;

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

  /// Color of the dropdown icon
  final Color? dropdownIconColor;

  /// Custom widget to replace the default dropdown icon
  final Widget? dropdownIcon;

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
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.elevation = 4.0,
    this.maxHeight = 260,
    this.placeholderTextStyle = const TextStyle(
      color: Color(0XFF828282),
      fontSize: 14,
    ),
    this.selectedItemTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.itemTextStyle,
    this.checkboxActiveColor,
    this.checkboxInActiveColor,
    this.dropdownIconColor = Colors.grey,
    this.checkColor,
    this.dropdownIcon,
    this.dropdownDecoration,
    this.dropdownListDecoration,
    this.boxShadow,
    this.checkboxBorderWidth = 1.5,
    this.searchDecoration = const DropdownSearchDecoration(),
  });
}
