import 'package:flutter/material.dart';
import 'dropdown_search_decoration.dart';

class DropdownSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final DropdownSearchDecoration decoration;

  const DropdownSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: decoration.padding,
      margin: EdgeInsets.only(left: 12, right: 10, top: 10),
      decoration: BoxDecoration(
        color: decoration.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: decoration.borderRadius ?? BorderRadius.circular(4.0),
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
        cursorColor: decoration.cursorColor ?? theme.colorScheme.primary,
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
                vertical: 14.0,
                horizontal: 12,
              ),
            ),
      ),
    );
  }
}
