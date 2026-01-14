import 'package:flutter/material.dart';
import '../themes/dropdown_search_decoration.dart';

/// A search field widget for filtering dropdown items.
///
/// This widget provides a text field with customizable decoration
/// for searching through dropdown items.
class DropdownSearchField extends StatelessWidget {
  /// Controller for the search text field
  final TextEditingController controller;

  /// Callback when the search text changes
  final ValueChanged<String> onChanged;

  /// Decoration options for the search field
  final DropdownSearchDecoration decoration;

  /// Creates a [DropdownSearchField] widget
  const DropdownSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: decoration.padding,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: decoration.backgroundColor ?? colorScheme.surface,
        borderRadius: decoration.borderRadius,
        border: decoration.borderColor != null || decoration.borderWidth != null
            ? Border.all(
                color: decoration.borderColor ?? theme.dividerColor,
                width: decoration.borderWidth ?? 1.0,
              )
            : null,
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: decoration.cursorColor ?? colorScheme.primary,
        cursorWidth: 1.0,
        cursorRadius: const Radius.circular(1.0),
        style: decoration.textStyle ?? theme.textTheme.bodyMedium,
        decoration: decoration.decoration ??
            InputDecoration(
              hintText: decoration.hintText,
              hintStyle: decoration.hintStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              prefixIcon: const Icon(Icons.search, size: 20),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 36,
                minHeight: 36,
              ),
            ),
      ),
    );
  }
}
