import 'package:flutter/material.dart';

/// Checkbox styling for dropdown items
class DropdownCheckboxDecoration {
  /// Color of the checkbox when active (checked)
  final Color? activeColor;

  /// Color of the checkbox when inactive (unchecked)
  final Color? inactiveColor;

  /// Color of the check icon inside the checkbox
  final Color? checkIconColor;

  /// Width of the checkbox border
  final double borderWidth;

  const DropdownCheckboxDecoration({
    this.activeColor,
    this.inactiveColor,
    this.checkIconColor,
    this.borderWidth = 1.5,
  });

  DropdownCheckboxDecoration copyWith({
    Color? activeColor,
    Color? inactiveColor,
    Color? checkIconColor,
    double? borderWidth,
  }) {
    return DropdownCheckboxDecoration(
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      checkIconColor: checkIconColor ?? this.checkIconColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }
}
