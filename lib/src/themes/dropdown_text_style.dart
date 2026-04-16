import 'package:flutter/material.dart';

/// Text styling for different dropdown elements
class DropdownTextStyle {
  /// Text style for the placeholder text when no items are selected
  final TextStyle? placeholder;

  /// Text style for the selected items text
  final TextStyle? selectedItem;

  /// Text style for items in the dropdown list
  final TextStyle? item;

  const DropdownTextStyle({
    this.placeholder = const TextStyle(
      color: Color(0xFF828282),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.selectedItem = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.item,
  });

  DropdownTextStyle copyWith({
    TextStyle? placeholder,
    TextStyle? selectedItem,
    TextStyle? item,
  }) {
    return DropdownTextStyle(
      placeholder: placeholder ?? this.placeholder,
      selectedItem: selectedItem ?? this.selectedItem,
      item: item ?? this.item,
    );
  }
}
