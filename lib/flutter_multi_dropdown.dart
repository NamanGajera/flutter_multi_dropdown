/// A customizable multi-select dropdown widget for Flutter applications.
///
/// This package provides a versatile dropdown widget that supports:
/// - Single and multiple selection modes
/// - Select all/none functionality
/// - API data integration with proper selection handling
/// - Customizable appearance
/// - Controller-based state management
/// - Search functionality
///
/// To use, import this file and create a [FlutterMultiDropdown] widget.
library;

// Core exports
export 'src/core/multi_dropdown_controller.dart';
export 'src/core/dropdown_item.dart';
export 'src/utils/dropdown_selection_mode.dart';

// Widget exports
export 'src/widgets/multi_dropdown.dart';
export 'src/widgets/dropdown_search_field.dart';

// Theme/Decoration exports - Main composite class
export 'src/themes/dropdown_decoration.dart';

// Individual decoration components (required for full customization)
export 'src/themes/dropdown_check_box_decoration.dart';
export 'src/themes/dropdown_icon_decoration.dart';
export 'src/themes/dropdown_search_decoration.dart';
export 'src/themes/dropdown_text_style.dart';
export 'src/themes/dropdown_style.dart';
