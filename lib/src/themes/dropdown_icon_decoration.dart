import 'package:flutter/material.dart';

/// Icon styling and customization for dropdown
class DropdownIconDecoration {
  /// Color of the close dropdown icon
  final Color? closeIconColor;

  /// Color of the open dropdown icon
  final Color? openIconColor;

  /// Custom widget to replace the default close dropdown icon
  final Widget? closeIcon;

  /// Custom widget to replace the default open dropdown icon
  final Widget? openIcon;

  /// Custom size of close dropdown icon
  final double? closeIconSize;

  /// Custom size of open dropdown icon
  final double? openIconSize;

  const DropdownIconDecoration({
    this.closeIconColor = const Color(0xFF757575),
    this.openIconColor = const Color(0xFF757575),
    this.closeIcon,
    this.openIcon,
    this.closeIconSize,
    this.openIconSize,
  });

  DropdownIconDecoration copyWith({
    Color? closeIconColor,
    Color? openIconColor,
    Widget? closeIcon,
    Widget? openIcon,
    double? closeIconSize,
    double? openIconSize,
  }) {
    return DropdownIconDecoration(
      closeIconColor: closeIconColor ?? this.closeIconColor,
      openIconColor: openIconColor ?? this.openIconColor,
      closeIcon: closeIcon ?? this.closeIcon,
      openIcon: openIcon ?? this.openIcon,
      closeIconSize: closeIconSize ?? this.closeIconSize,
      openIconSize: openIconSize ?? this.openIconSize,
    );
  }
}
