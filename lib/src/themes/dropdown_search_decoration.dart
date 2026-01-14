import 'package:flutter/material.dart';

/// Customization options for the search field in [FlutterMultiDropdown].
///
/// This class provides styling options for the search text field that appears
/// at the top of the dropdown list.
///
/// Example:
/// ```dart
/// DropdownSearchDecoration(
///   hintText: 'Search items...',
///   backgroundColor: Colors.grey[100],
///   borderRadius: BorderRadius.circular(8.0),
/// )
/// ```
class DropdownSearchDecoration {
  /// The hint text to display when the search field is empty
  final String? hintText;

  /// The style of the hint text
  final TextStyle? hintStyle;

  /// The style of the text entered in the search field
  final TextStyle? textStyle;

  /// The color of the cursor in the search field
  final Color? cursorColor;

  /// The color of the text selection highlight
  final Color? selectionColor;

  /// The decoration of the search field
  final InputDecoration? decoration;

  /// The background color of the search field
  final Color? backgroundColor;

  /// The padding around the search field
  final EdgeInsetsGeometry? padding;

  /// The border radius of the search field container
  final BorderRadius? borderRadius;

  /// The width of the search field's border
  final double? borderWidth;

  /// The color of the search field's border
  final Color? borderColor;

  /// Creates a [DropdownSearchDecoration] with customizable options
  const DropdownSearchDecoration({
    this.hintText = 'Search...',
    this.hintStyle,
    this.textStyle,
    this.cursorColor,
    this.selectionColor,
    this.decoration,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.borderWidth,
    this.borderColor,
  });

  /// Creates a copy of this object with the given fields replaced
  DropdownSearchDecoration copyWith({
    String? hintText,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    Color? cursorColor,
    Color? selectionColor,
    InputDecoration? decoration,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? borderColor,
  }) {
    return DropdownSearchDecoration(
      hintText: hintText ?? this.hintText,
      hintStyle: hintStyle ?? this.hintStyle,
      textStyle: textStyle ?? this.textStyle,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionColor: selectionColor ?? this.selectionColor,
      decoration: decoration ?? this.decoration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  String toString() {
    return 'DropdownSearchDecoration(hintText: $hintText)';
  }
}
