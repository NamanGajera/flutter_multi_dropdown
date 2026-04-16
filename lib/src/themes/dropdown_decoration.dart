import 'package:flutter/material.dart';
import 'dropdown_check_box_decoration.dart';
import 'dropdown_style.dart';
import 'dropdown_icon_decoration.dart';
import 'dropdown_search_decoration.dart';
import 'dropdown_text_style.dart';

/// Main decoration class that composes all dropdown style components.
///
/// [DropdownDecoration] provides a unified interface for customizing the appearance
/// of a multi-select dropdown widget. It combines multiple specialized decoration
/// classes to offer granular control over every visual aspect of the dropdown.
///
/// ## Features
/// * **Container Styling**: Border radius, colors, elevation, and shadows
/// * **Sizing**: Control over padding, item heights, and visible items
/// * **Text Styling**: Separate styles for placeholder, selected items, and list items
/// * **Checkbox Customization**: Colors, border width, and check icon color
/// * **Icon Customization**: Custom icons and colors for dropdown states
/// * **Search Integration**: Built-in search field styling
///
/// ## Usage Examples
///
/// ### Basic Usage
/// ```dart
/// DropdownDecoration(
///   container: DropdownContainerDecoration(
///     borderRadius: 8.0,
///     borderColor: Colors.blue,
///   ),
///   maxVisibleItems: 5,
///   itemHeight: 56.0,
/// )
/// ```
///
/// ### Complete Customization
/// ```dart
/// DropdownDecoration(
///   container: DropdownContainerDecoration(
///     borderRadius: 12.0,
///     borderColor: Colors.grey.shade300,
///     backgroundColor: Colors.white,
///     elevation: 8.0,
///     boxShadow: [
///       BoxShadow(
///         color: Colors.black12,
///         blurRadius: 10,
///         offset: Offset(0, 4),
///       ),
///     ],
///   ),
///   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
///   maxVisibleItems: 8,
///   itemHeight: 52.0,
///   minHeight: 150.0,
///   textStyle: DropdownTextStyle(
///     placeholder: TextStyle(
///       color: Colors.grey.shade500,
///       fontSize: 16,
///       fontStyle: FontStyle.italic,
///     ),
///     selectedItem: TextStyle(
///       color: Colors.blue.shade900,
///       fontSize: 16,
///       fontWeight: FontWeight.w600,
///     ),
///     item: TextStyle(
///       color: Colors.grey.shade800,
///       fontSize: 14,
///     ),
///   ),
///   checkbox: DropdownCheckboxDecoration(
///     activeColor: Colors.blue,
///     inactiveColor: Colors.grey.shade400,
///     checkColor: Colors.white,
///     borderWidth: 2.0,
///   ),
///   icon: DropdownIconDecoration(
///     closeIconColor: Colors.blue,
///     openIconColor: Colors.blue,
///     closeIcon: Icon(Icons.arrow_drop_up),
///     openIcon: Icon(Icons.arrow_drop_down),
///   ),
/// )
/// ```
///
/// ### Quick Setup with Simple Constructor
/// ```dart
/// DropdownDecoration.simple(
///   borderRadius: 8.0,
///   borderColor: Colors.teal,
///   backgroundColor: Colors.white,
///   maxVisibleItems: 6,
///   checkboxActiveColor: Colors.teal,
/// )
/// ```
///
/// ### Partial Override
/// ```dart
/// final baseDecoration = DropdownDecoration(
///   container: DropdownContainerDecoration(
///     borderRadius: 8.0,
///     backgroundColor: Colors.white,
///   ),
///   maxVisibleItems: 5,
/// );
///
/// final customDecoration = baseDecoration.copyWith(
///   icon: DropdownIconDecoration(
///     closeIcon: Icon(Icons.expand_less),
///     openIcon: Icon(Icons.expand_more),
///   ),
///   checkbox: DropdownCheckboxDecoration(
///     activeColor: Colors.green,
///   ),
/// );
/// ```
///
/// ## Design Guidelines
/// * **Accessibility**: Ensure sufficient color contrast between text and background
/// * **Touch Targets**: Minimum recommended item height is 48.0 for touch devices
/// * **Performance**: Keep `maxVisibleItems` reasonable (3-8) for optimal UX
/// * **Responsiveness**: Consider screen size when setting `maxVisibleItems` and `minHeight`
///
/// See also:
/// * [DropdownContainerDecoration] for container-specific styling
/// * [DropdownTextStyle] for text styling options
/// * [DropdownCheckboxDecoration] for checkbox customization
/// * [DropdownIconDecoration] for icon customization
/// * [DropdownSearchDecoration] for search field styling
class DropdownDecoration {
  /// Container styling including borders, background, elevation, and shadows
  ///
  /// Controls the visual appearance of both the dropdown button and list containers.
  /// Use this to customize border radius, colors, and shadow effects.
  ///
  /// Defaults to [DropdownStyle] with standard values.
  final DropdownStyle dropdownStyle;

  /// Padding inside the dropdown button
  ///
  /// Controls the spacing between the button's content (selected items/placeholder)
  /// and its borders. Affects touch target size and visual comfort.
  ///
  /// **Default**: `EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0)`
  /// **Recommended**: Minimum 12px vertical padding for touch targets
  ///
  /// Example:
  /// ```dart
  /// contentPadding: EdgeInsets.all(16.0), // Uniform padding
  /// contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14), // More horizontal space
  /// ```
  final EdgeInsetsGeometry contentPadding;

  /// Maximum number of visible items in the dropdown list
  ///
  /// Determines how many items are shown before the list becomes scrollable.
  /// If actual item count is less than this value, the list will shrink to fit.
  ///
  /// **Default**: 6 items
  /// **Range**: 3-10 recommended for optimal user experience
  /// **Performance**: Higher values may impact performance on older devices
  ///
  /// Example:
  /// ```dart
  /// maxVisibleItems: 5, // Show 5 items before scrolling
  /// maxVisibleItems: 8, // Show 8 items before scrolling
  /// ```
  final int maxVisibleItems;

  /// Height of each dropdown item in pixels
  ///
  /// Used to calculate total dropdown height: `min(maxVisibleItems * itemHeight, totalItems * itemHeight)`
  /// Also ensures consistent spacing and touch target sizes.
  ///
  /// **Default**: 48.0 pixels (standard Material Design ListTile height)
  /// **Minimum**: 44.0 pixels for touch accessibility (Material Design guideline)
  /// **Recommended**: 48.0 - 56.0 pixels for comfortable touch interaction
  ///
  /// Example:
  /// ```dart
  /// itemHeight: 56.0, // Larger touch target
  /// itemHeight: 44.0, // Compact list (minimum for accessibility)
  /// ```
  final double itemHeight;

  /// Minimum height of the dropdown list in pixels
  ///
  /// Ensures the dropdown doesn't become too small when there are few items,
  /// maintaining visual consistency and usability.
  ///
  /// **Default**: 100.0 pixels
  /// **Usage**: Override when you have very few items but want a larger dropdown
  ///
  /// Example:
  /// ```dart
  /// minHeight: 120.0, // Ensure minimum height even with 1-2 items
  /// minHeight: 80.0,  // Allow smaller dropdown for compact UIs
  /// ```
  final double minHeight;

  /// Text styling for all text elements in the dropdown
  ///
  /// Controls placeholder text, selected items text, and list items text styles.
  /// Each can be customized independently for maximum flexibility.
  ///
  /// Defaults to [DropdownTextStyle] with standard typography.
  final DropdownTextStyle textStyle;

  /// Checkbox styling for multi-selection items
  ///
  /// Customizes the appearance of checkboxes in the dropdown list,
  /// including colors, border width, and check icon color.
  ///
  /// Defaults to [DropdownCheckboxDecoration] with standard Material colors.
  final DropdownCheckboxDecoration checkboxDecoration;

  /// Icon styling for dropdown open/close states
  ///
  /// Customizes the dropdown toggle icons including colors, sizes,
  /// and custom widget replacements.
  ///
  /// Defaults to [DropdownIconDecoration] with standard Material icons.
  final DropdownIconDecoration iconDecoration;

  /// Search field styling when search is enabled
  ///
  /// Provides comprehensive styling options for the search input field
  /// that appears above the dropdown list when searching is enabled.
  ///
  /// Defaults to [DropdownSearchDecoration] with standard Material styling.
  final DropdownSearchDecoration searchDecoration;

  /// Creates a [DropdownDecoration] with the specified styling options.
  ///
  /// All parameters are optional and will use their default values if not provided.
  ///
  /// Example:
  /// ```dart
  /// const DropdownDecoration(
  ///   container: DropdownContainerDecoration(
  ///     borderRadius: 12.0,
  ///     borderColor: Colors.blue,
  ///   ),
  ///   maxVisibleItems: 5,
  ///   itemHeight: 56.0,
  /// )
  /// ```
  const DropdownDecoration({
    this.dropdownStyle = const DropdownStyle(),
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.maxVisibleItems = 6,
    this.itemHeight = 48.0,
    this.minHeight = 100.0,
    this.textStyle = const DropdownTextStyle(),
    this.checkboxDecoration = const DropdownCheckboxDecoration(),
    this.iconDecoration = const DropdownIconDecoration(),
    this.searchDecoration = const DropdownSearchDecoration(),
  });

  /// Convenience constructor for quick setup with common options.
  ///
  /// This constructor provides a simplified API for the most frequently used
  /// customization options, making it perfect for rapid prototyping and
  /// simple use cases.
  ///
  /// Parameters:
  /// * [borderRadius] - Border radius for dropdown containers (default: 6.0)
  /// * [borderColor] - Border color for containers (default: #E0E0E0)
  /// * [backgroundColor] - Background color for containers (default: white)
  /// * [maxVisibleItems] - Maximum visible items before scrolling (default: 6)
  /// * [checkboxActiveColor] - Color of checkbox when selected (default: Theme's primary color)
  ///
  /// Example:
  /// ```dart
  /// DropdownDecoration.simple(
  ///   borderRadius: 10.0,
  ///   borderColor: Colors.teal,
  ///   backgroundColor: Colors.grey.shade50,
  ///   maxVisibleItems: 4,
  ///   checkboxActiveColor: Colors.teal,
  /// )
  /// ```
  DropdownDecoration.simple({
    double? borderRadius,
    Color? borderColor,
    Color? backgroundColor,
    int? maxVisibleItems,
    Color? checkboxActiveColor,
  }) : this(
          dropdownStyle: DropdownStyle(
            borderRadius: borderRadius ?? 6.0,
            borderColor: borderColor ?? const Color(0xFFE0E0E0),
            backgroundColor: backgroundColor ?? Colors.white,
          ),
          maxVisibleItems: maxVisibleItems ?? 6,
          checkboxDecoration: DropdownCheckboxDecoration(
            activeColor: checkboxActiveColor,
          ),
        );

  /// Creates a copy of this decoration with the given fields replaced.
  ///
  /// This method allows for partial updates of the decoration configuration
  /// without affecting other properties. Useful for creating variations
  /// of a base decoration.
  ///
  /// Example:
  /// ```dart
  /// final baseDecoration = DropdownDecoration(
  ///   container: DropdownContainerDecoration(borderRadius: 8.0),
  ///   maxVisibleItems: 5,
  /// );
  ///
  /// final largerDecoration = baseDecoration.copyWith(
  ///   maxVisibleItems: 8,
  ///   itemHeight: 56.0,
  /// );
  /// ```
  DropdownDecoration copyWith({
    DropdownStyle? dropdownStyle,
    EdgeInsetsGeometry? contentPadding,
    int? maxVisibleItems,
    double? itemHeight,
    double? minHeight,
    DropdownTextStyle? textStyle,
    DropdownCheckboxDecoration? checkboxDecoration,
    DropdownIconDecoration? iconDecoration,
    DropdownSearchDecoration? searchDecoration,
  }) {
    return DropdownDecoration(
      dropdownStyle: dropdownStyle ?? this.dropdownStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      maxVisibleItems: maxVisibleItems ?? this.maxVisibleItems,
      itemHeight: itemHeight ?? this.itemHeight,
      minHeight: minHeight ?? this.minHeight,
      textStyle: textStyle ?? this.textStyle,
      checkboxDecoration: checkboxDecoration ?? this.checkboxDecoration,
      iconDecoration: iconDecoration ?? this.iconDecoration,
      searchDecoration: searchDecoration ?? this.searchDecoration,
    );
  }

  /// Returns a string representation of this decoration for debugging.
  ///
  /// Provides a human-readable description of the decoration configuration,
  /// useful for logging and debugging purposes.
  @override
  String toString() {
    return 'DropdownDecoration('
        'dropdownStyle: $dropdownStyle, '
        'contentPadding: $contentPadding, '
        'maxVisibleItems: $maxVisibleItems, '
        'itemHeight: $itemHeight, '
        'minHeight: $minHeight, '
        'textStyle: $textStyle, '
        'checkboxDecoration: $checkboxDecoration, '
        'iconDecoration: $iconDecoration, '
        'searchDecoration: $searchDecoration'
        ')';
  }

  /// Compares this decoration to another object for equality.
  ///
  /// Two decorations are considered equal if all their properties are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is DropdownDecoration &&
        other.dropdownStyle == dropdownStyle &&
        other.contentPadding == contentPadding &&
        other.maxVisibleItems == maxVisibleItems &&
        other.itemHeight == itemHeight &&
        other.minHeight == minHeight &&
        other.textStyle == textStyle &&
        other.checkboxDecoration == checkboxDecoration &&
        other.iconDecoration == iconDecoration &&
        other.searchDecoration == searchDecoration;
  }

  /// Returns a hash code for this decoration.
  @override
  int get hashCode => Object.hash(
        dropdownStyle,
        contentPadding,
        maxVisibleItems,
        itemHeight,
        minHeight,
        textStyle,
        checkboxDecoration,
        iconDecoration,
        searchDecoration,
      );
}
