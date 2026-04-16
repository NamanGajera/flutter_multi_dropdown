import 'package:flutter/material.dart';

/// Container and box styling for dropdown
class DropdownStyle {
  /// Border radius for both the dropdown button and list
  final double borderRadius;

  /// Border color for both the dropdown button and list
  final Color borderColor;

  /// Background color for both the dropdown button and list
  final Color backgroundColor;

  /// Elevation of the dropdown list
  final double elevation;

  /// Box shadows for the dropdown list
  final List<BoxShadow>? boxShadow;

  /// Custom decoration for the dropdown button
  final BoxDecoration? fieldDecoration;

  /// Custom decoration for the dropdown list
  final BoxDecoration? listDecoration;

  const DropdownStyle({
    this.borderRadius = 6.0,
    this.borderColor = const Color(0xFFE0E0E0),
    this.backgroundColor = Colors.white,
    this.elevation = 4.0,
    this.boxShadow,
    this.fieldDecoration,
    this.listDecoration,
  });

  DropdownStyle copyWith({
    double? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    double? elevation,
    List<BoxShadow>? boxShadow,
    BoxDecoration? fieldDecoration,
    BoxDecoration? listDecoration,
  }) {
    return DropdownStyle(
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      boxShadow: boxShadow ?? this.boxShadow,
      fieldDecoration: fieldDecoration ?? this.fieldDecoration,
      listDecoration: listDecoration ?? this.listDecoration,
    );
  }
}
