import 'package:flutter/material.dart';
import '../core/dropdown_item.dart';
import '../core/dropdown_selection_manager.dart';
import '../core/multi_dropdown_controller.dart';
import '../presentation/dropdown_list_view.dart';
import '../presentation/dropdown_select_all_tile.dart';
import '../themes/dropdown_decoration.dart';
import '../utils/dropdown_selection_mode.dart';
import '../utils/dropdown_helpers.dart';
import 'dropdown_search_field.dart';

/// A highly customizable dropdown widget for Flutter applications that supports both single and multi-select functionality.
///
/// The [FlutterMultiDropdown] widget provides a rich set of features for creating dropdown interfaces
/// with support for various selection modes, styling options, and programmatic control.
///
/// ## Features
///
/// - **Single or Multiple Selection** - Choose between single and multi-select modes
/// - **Select All Functionality** - Built-in "Select All" option for multi-select mode
/// - **Customizable Appearance** - Extensive styling options through [DropdownDecoration]
/// - **Programmatic Control** - Controller support for external selection management
/// - **Search Capability** - Built-in search with custom controller support
/// - **Async Data Support** - Handle loading and empty states gracefully
/// - **Selection Limits** - Restrict maximum selections in multi-select mode
/// - **Custom Item Rendering** - Build your own item widgets
/// - **API Integration** - Seamless handling of async data loading
///
/// ## Type Parameters
///
/// The widget uses a generic type `T` for item IDs, allowing you to use any type
/// (int, String, etc.) as your item identifier.
///
/// ## Basic Usage Examples
///
/// ### Simple Multi-Select Dropdown
/// ```dart
/// FlutterMultiDropdown<int>(
///   items: [
///     DropDownMenuItemData(name: 'Apple', id: 1),
///     DropDownMenuItemData(name: 'Banana', id: 2),
///     DropDownMenuItemData(name: 'Orange', id: 3),
///   ],
///   onSelectionChanged: (selectedIds) {
///     print('Selected items: $selectedIds');
///   },
/// )
/// ```
///
/// ### Single Selection Mode
/// ```dart
/// FlutterMultiDropdown<int>(
///   selectionMode: DropdownSelectionMode.single,
///   items: categoryItems,
///   onSingleItemSelected: (selectedId) {
///     print('Selected category: $selectedId');
///   },
///   placeholder: 'Choose a category',
/// )
/// ```
///
/// ### With API Data Loading
/// ```dart
/// class MyWidget extends StatefulWidget {
///   @override
///   _MyWidgetState createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> {
///   final controller = MultiDropdownController<int>();
///   List<DropDownMenuItemData<int>> items = [];
///   bool isLoading = false;
///
///   @override
///   void initState() {
///     super.initState();
///     _loadData();
///   }
///
///   Future<void> _loadData() async {
///     setState(() => isLoading = true);
///     try {
///       final data = await ApiService.getItems();
///       setState(() {
///         items = data.map((item) =>
///           DropDownMenuItemData(name: item.name, id: item.id)
///         ).toList();
///       });
///     } finally {
///       setState(() => isLoading = false);
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return FlutterMultiDropdown<int>(
///       items: items,
///       controller: controller,
///       showLoading: isLoading,
///       loadingBuilder: (context) => Center(
///         child: CircularProgressIndicator(),
///       ),
///       onSelectionChanged: (selectedIds) {
///         // Handle selection
///       },
///     );
///   }
/// }
/// ```
///
/// ### Custom Styling
/// ```dart
/// FlutterMultiDropdown<String>(
///   items: myItems,
///   decoration: DropdownDecoration(
///     backgroundColor: Colors.grey[50],
///     borderColor: Colors.blue,
///     borderRadius: 12,
///     checkboxActiveColor: Colors.blue,
///     itemHeight: 48,
///     dropdownListDecoration: BoxDecoration(
///       color: Colors.white,
///       borderRadius: BorderRadius.circular(12),
///       boxShadow: [
///         BoxShadow(
///           color: Colors.black12,
///           blurRadius: 8,
///           offset: Offset(0, 4),
///         ),
///       ],
///     ),
///   ),
///   prefix: Icon(Icons.category),
///   placeholder: 'Select items...',
/// )
/// ```
///
/// ### With Search and Selection Limits
/// ```dart
/// FlutterMultiDropdown<int>(
///   items: availableItems,
///   enableSearch: true,
///   maxSelection: 3,
///   onMaxSelectionReached: () {
///     ScaffoldMessenger.of(context).showSnackBar(
///       SnackBar(content: Text('Maximum 3 items can be selected')),
///     );
///   },
///   showSelectedItemName: true,
///   searchController: mySearchController, // Optional custom controller
/// )
/// ```
///
/// ### Custom Item Builder
/// ```dart
/// FlutterMultiDropdown<User>(
///   items: users,
///   itemBuilder: (context, item, isSelected, onChanged) {
///     return ListTile(
///       leading: CircleAvatar(
///         backgroundImage: NetworkImage(item.avatarUrl),
///       ),
///       title: Text(item.name),
///       subtitle: Text(item.email),
///       trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
///       onTap: () => onChanged!(!isSelected),
///     );
///   },
/// )
/// ```
///
/// See also:
/// - [MultiDropdownController] - For programmatic control of selections
/// - [DropdownDecoration] - For styling configuration
/// - [DropDownMenuItemData] - For item configuration
/// - [DropdownSelectionMode] - For selection mode options
class FlutterMultiDropdown<T> extends StatefulWidget {
  /// The list of items to display in the dropdown.
  ///
  /// Each item must be of type [DropDownMenuItemData<T>] containing:
  /// - [id] - Unique identifier of type T
  /// - [name] - Display text
  /// - [enabled] - Whether the item is selectable (defaults to true)
  /// - [isSelected] - Initial selection state (optional)
  ///
  /// Example:
  /// ```dart
  /// items: [
  ///   DropDownMenuItemData(name: 'Option 1', id: 1),
  ///   DropDownMenuItemData(name: 'Option 2', id: 2, enabled: false),
  ///   DropDownMenuItemData(name: 'Option 3', id: 3, isSelected: true),
  /// ]
  /// ```
  final List<DropDownMenuItemData<T>> items;

  /// Callback triggered when selection changes in multi-select mode.
  ///
  /// Provides a list of selected item IDs whenever the selection changes.
  /// This callback is not called in single selection mode.
  ///
  /// Example:
  /// ```dart
  /// onSelectionChanged: (selectedIds) {
  ///   setState(() {
  ///     _selectedIds = selectedIds;
  ///   });
  /// }
  /// ```
  final ValueChanged<List<T>>? onSelectionChanged;

  /// Callback triggered when an item is selected in single selection mode.
  ///
  /// Provides the ID of the selected item. This callback is only called
  /// when [selectionMode] is set to [DropdownSelectionMode.single].
  ///
  /// Example:
  /// ```dart
  /// onSingleItemSelected: (selectedId) {
  ///   print('Selected: $selectedId');
  /// }
  /// ```
  final ValueChanged<T>? onSingleItemSelected;

  /// Styling configuration for the dropdown.
  ///
  /// Controls all visual aspects including borders, colors, padding, and icons.
  /// See [DropdownDecoration] for all available options.
  ///
  /// Defaults to [const DropdownDecoration()].
  final DropdownDecoration decoration;

  /// Placeholder text shown when no items are selected.
  ///
  /// Displayed in the dropdown field when the selection is empty.
  ///
  /// Defaults to 'Select Items'.
  final String? placeholder;

  /// Text label for the "Select All" option in multi-select mode.
  ///
  /// Only applicable when [showSelectAll] is true and [selectionMode] is multiple.
  ///
  /// Defaults to 'Select All'.
  final String? selectAllText;

  /// Widget to display before the selected items text.
  ///
  /// Useful for adding icons or other decorative elements to the dropdown field.
  ///
  /// Example:
  /// ```dart
  /// prefix: Icon(Icons.filter_list)
  /// ```
  final Widget? prefix;

  /// Widget to display after the selected items text.
  ///
  /// The dropdown arrow is automatically added if this is null.
  ///
  /// Example:
  /// ```dart
  /// suffix: Icon(Icons.arrow_drop_down)
  /// ```
  final Widget? suffix;

  /// Initial selected values for multi-select mode.
  ///
  /// Provides a list of item IDs that should be selected when the widget
  /// is first built. Only applies when [selectionMode] is multiple.
  ///
  /// Example:
  /// ```dart
  /// initialValue: [1, 3, 5]
  /// ```
  final List<T>? initialValue;

  /// Initial selected value for single selection mode.
  ///
  /// Provides the ID of the item that should be selected when the widget
  /// is first built. Only applies when [selectionMode] is single.
  ///
  /// Example:
  /// ```dart
  /// initialSingleValue: 42
  /// ```
  final T? initialSingleValue;

  /// Controller for programmatic control of the dropdown.
  ///
  /// Allows external manipulation of selections, useful for:
  /// - Clearing selections
  /// - Setting selections from outside the widget
  /// - Syncing with other components
  ///
  /// Example:
  /// ```dart
  /// final controller = MultiDropdownController<int>();
  ///
  /// // Later, programmatically select items
  /// controller.addSelection(5);
  /// controller.removeSelection(3);
  /// controller.clearAll();
  /// ```
  final MultiDropdownController<T>? controller;

  /// Whether to display selected item names or just the count.
  ///
  /// - If true: Shows comma-separated list of selected item names
  /// - If false: Shows "X items selected" where X is the count
  ///
  /// Defaults to true.
  final bool showSelectedItemName;

  /// Whether to enable search functionality in the dropdown.
  ///
  /// When true, adds a search field at the top of the dropdown list
  /// allowing users to filter items by name.
  ///
  /// Defaults to false.
  final bool enableSearch;

  /// Custom search controller for external search management.
  ///
  /// Useful when you need to control search from outside the widget
  /// or synchronize search with other components.
  ///
  /// Example:
  /// ```dart
  /// final searchController = SearchController();
  ///
  /// // Later
  /// searchController.text = 'search term';
  /// ```
  final SearchController? searchController;

  /// Whether to force display of empty state.
  ///
  /// Overrides the actual item list emptiness. Useful for showing
  /// empty state while waiting for data or handling errors.
  ///
  /// Defaults to false.
  final bool isEmptyData;

  /// Whether to display loading state.
  ///
  /// When true, shows loading indicator instead of dropdown items.
  /// Use with [loadingBuilder] for custom loading UI.
  ///
  /// Defaults to false.
  final bool showLoading;

  /// Whether to display the "Select All" option.
  ///
  /// Only applicable in multi-select mode. When true, adds a
  /// "Select All" tile at the top of the dropdown list.
  ///
  /// Defaults to true.
  final bool showSelectAll;

  /// Whether to automatically close dropdown when an item is selected.
  ///
  /// - In multi-select mode: Closes after each selection
  /// - In single-select mode: Always closes after selection
  ///
  /// Defaults to false.
  final bool autoCloseOnItemTap;

  /// Selection mode for the dropdown.
  ///
  /// Can be either:
  /// - [DropdownSelectionMode.multiple] - Allow multiple selections
  /// - [DropdownSelectionMode.single] - Allow only single selection
  ///
  /// Defaults to [DropdownSelectionMode.multiple].
  final DropdownSelectionMode selectionMode;

  /// Maximum number of items that can be selected in multi-select mode.
  ///
  /// When set, users cannot select more than this many items.
  /// Use [onMaxSelectionReached] to handle limit exceeded attempts.
  ///
  /// Example:
  /// ```dart
  /// maxSelection: 5, // Users can select up to 5 items
  /// ```
  final int? maxSelection;

  /// Callback triggered when user attempts to exceed [maxSelection] limit.
  ///
  /// Useful for showing feedback when selection limit is reached.
  ///
  /// Example:
  /// ```dart
  /// onMaxSelectionReached: () {
  ///   ScaffoldMessenger.of(context).showSnackBar(
  ///     SnackBar(content: Text('Maximum 5 items allowed')),
  ///   );
  /// }
  /// ```
  final VoidCallback? onMaxSelectionReached;

  /// Custom builder for empty state UI.
  ///
  /// Called when there are no items to display or when [isEmptyData] is true.
  /// If not provided, shows a default "No Data Found" message.
  ///
  /// Example:
  /// ```dart
  /// emptyBuilder: (context) => Center(
  ///   child: Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       Icon(Icons.inbox, size: 48, color: Colors.grey),
  ///       Text('No items available'),
  ///     ],
  ///   ),
  /// )
  /// ```
  final WidgetBuilder? emptyBuilder;

  /// Custom builder for loading state UI.
  ///
  /// Called when [showLoading] is true. If not provided, shows a default
  /// [CircularProgressIndicator].
  ///
  /// Example:
  /// ```dart
  /// loadingBuilder: (context) => Center(
  ///   child: Column(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       CircularProgressIndicator(),
  ///       SizedBox(height: 8),
  ///       Text('Loading items...'),
  ///     ],
  ///   ),
  /// )
  /// ```
  final WidgetBuilder? loadingBuilder;

  /// Custom builder for individual dropdown items.
  ///
  /// Allows complete customization of how each item is rendered.
  /// Provides the item, selection state, and a callback to toggle selection.
  ///
  /// Parameters:
  /// - [context] - Build context
  /// - [item] - The dropdown item data
  /// - [isSelected] - Whether the item is currently selected
  /// - [onChanged] - Callback to toggle selection (pass true/false)
  ///
  /// Example:
  /// ```dart
  /// itemBuilder: (context, item, isSelected, onChanged) {
  ///   return Container(
  ///     color: isSelected ? Colors.blue[50] : null,
  ///     child: ListTile(
  ///       leading: Icon(
  ///         isSelected ? Icons.check_box : Icons.check_box_outline_blank,
  ///         color: isSelected ? Colors.blue : null,
  ///       ),
  ///       title: Text(item.name),
  ///       onTap: () => onChanged!(!isSelected),
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    DropDownMenuItemData<T> item,
    bool isSelected,
    ValueChanged<bool?>? onChanged,
  )? itemBuilder;

  /// Custom builder for the "Select All" tile.
  ///
  /// Allows customization of the select all UI in multi-select mode.
  /// Only called when [showSelectAll] is true.
  ///
  /// Parameters:
  /// - [context] - Build context
  /// - [isSelected] - Whether all items are selected
  /// - [onChanged] - Callback to toggle select all
  ///
  /// Example:
  /// ```dart
  /// selectAllBuilder: (context, isSelected, onChanged) {
  ///   return ListTile(
  ///     leading: Checkbox(
  ///       value: isSelected,
  ///       onChanged: onChanged,
  ///     ),
  ///     title: Text(
  ///       isSelected ? 'Deselect All' : 'Select All',
  ///       style: TextStyle(fontWeight: FontWeight.bold),
  ///     ),
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    bool isSelected,
    ValueChanged<bool?>? onChanged,
  )? selectAllBuilder;

  /// Creates a [FlutterMultiDropdown] widget.
  ///
  /// The [items] parameter is required and must not be null.
  ///
  /// Throws assertions if:
  /// - [maxSelection] is provided in single selection mode
  /// - [showSelectAll] is true in single selection mode
  const FlutterMultiDropdown({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.onSingleItemSelected,
    this.decoration = const DropdownDecoration(),
    this.placeholder = 'Select Items',
    this.selectAllText = 'Select All',
    this.prefix,
    this.suffix,
    this.initialValue,
    this.initialSingleValue,
    this.controller,
    this.showSelectedItemName = true,
    this.enableSearch = false,
    this.searchController,
    this.emptyBuilder,
    this.loadingBuilder,
    this.isEmptyData = false,
    this.showLoading = false,
    this.showSelectAll = true,
    this.autoCloseOnItemTap = false,
    this.selectionMode = DropdownSelectionMode.multiple,
    this.maxSelection,
    this.onMaxSelectionReached,
    this.itemBuilder,
    this.selectAllBuilder,
  })  : assert(
          !(selectionMode == DropdownSelectionMode.single && maxSelection != null),
          'maxSelection is not supported in single selection mode',
        ),
        assert(
          !(selectionMode == DropdownSelectionMode.single && showSelectAll),
          'showSelectAll is not supported in single selection mode',
        );

  @override
  State<FlutterMultiDropdown<T>> createState() => _FlutterMultiDropdownState<T>();
}

class _FlutterMultiDropdownState<T> extends State<FlutterMultiDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  late final ValueNotifier<bool> _isDropdownOpen = ValueNotifier(false);
  late final MultiDropdownController<T> _controller;
  late final DropdownSelectionManager<T> _selectionManager;
  late final SearchController _searchController;
  late final ValueNotifier<List<DropDownMenuItemData<T>>> _filteredItems;
  late final ValueNotifier<bool> _selectAllState = ValueNotifier(false);

  OverlayEntry? _overlayEntry;

  MultiDropdownController<T> get _effectiveController => widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupInitialSelection();
    _setupListeners();
    _updateSelectAllState();
  }

  void _initializeControllers() {
    _controller = MultiDropdownController<T>();
    _searchController = widget.searchController ?? SearchController();
    _filteredItems = ValueNotifier(_getFilteredItems());

    _selectionManager = DropdownSelectionManager<T>(
      mode: widget.selectionMode,
      maxSelection: widget.maxSelection,
      onMaxReached: widget.onMaxSelectionReached,
      controller: _effectiveController,
    );
  }

  void _setupInitialSelection() {
    if (widget.selectionMode == DropdownSelectionMode.multiple) {
      if (widget.initialValue?.isNotEmpty ?? false) {
        _effectiveController.updateSelection(widget.initialValue!);
      } else if (widget.items.any((item) => item.isSelected)) {
        final selectedIds = widget.items.where((item) => item.isSelected && item.enabled).map((item) => item.id).toList();
        _effectiveController.updateSelection(selectedIds);
      }
    } else {
      final value = widget.initialSingleValue;
      if (value != null) {
        _effectiveController.updateSelection([value]);
      } else {
        final preselected = widget.items.firstWhere(
          (item) => item.isSelected && item.enabled,
          orElse: () => DropDownMenuItemData<T>(name: '', id: '' as T),
        );
        if (preselected.id != '' as T) {
          _effectiveController.updateSelection([preselected.id]);
        }
      }
    }
  }

  void _setupListeners() {
    _effectiveController.addListener(_onControllerChanged);
    _searchController.addListener(_onSearchChanged);
    _isDropdownOpen.addListener(_onDropdownOpenChanged);
  }

  void _onDropdownOpenChanged() {
    if (_isDropdownOpen.value) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _isDropdownOpen.value = false,
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: _calculateDropdownOffset(size, screenSize, position),
              child: Material(
                elevation: widget.decoration.elevation,
                borderRadius: BorderRadius.circular(widget.decoration.borderRadius),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: screenSize.height * 0.4,
                  ),
                  decoration: widget.decoration.dropdownListDecoration ??
                      BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(widget.decoration.borderRadius),
                        border: Border.all(color: widget.decoration.borderColor),
                      ),
                  child: _buildDropdownContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Offset _calculateDropdownOffset(Size widgetSize, Size screenSize, Offset position) {
    final spaceBelow = screenSize.height - position.dy - widgetSize.height;
    final spaceAbove = position.dy;

    if (spaceBelow < 200 && spaceAbove >= 200) {
      return Offset(0, -200 - 5);
    }

    return Offset(0, widgetSize.height + 5);
  }

  void _onControllerChanged() {
    if (!mounted) return;

    _updateSelectAllState();
    _notifySelectionChanged();

    _overlayEntry?.markNeedsBuild();
  }

  void _onSearchChanged() {
    _filteredItems.value = _getFilteredItems();
    _updateSelectAllState();
  }

  List<DropDownMenuItemData<T>> _getFilteredItems() {
    final searchText = _searchController.text.trim().toLowerCase();
    if (searchText.isEmpty) return widget.items;

    return widget.items.where((item) => item.name.toLowerCase().contains(searchText)).toList();
  }

  void _updateSelectAllState() {
    if (widget.selectionMode != DropdownSelectionMode.multiple) return;

    final enabledIds = _filteredItems.value.where((item) => item.enabled).map((item) => item.id).toList();

    if (enabledIds.isEmpty) {
      _selectAllState.value = false;
      return;
    }

    if (widget.maxSelection != null) {
      final selectedCount = enabledIds.where((id) => _effectiveController.isSelected(id)).length;
      _selectAllState.value =
          selectedCount == widget.maxSelection! || (selectedCount == enabledIds.length && enabledIds.length <= widget.maxSelection!);
    } else {
      _selectAllState.value = enabledIds.every(_effectiveController.isSelected);
    }
  }

  void _notifySelectionChanged() {
    final selectedIds = _effectiveController.selectedIds;
    if (widget.selectionMode == DropdownSelectionMode.single && selectedIds.isNotEmpty) {
      widget.onSingleItemSelected?.call(selectedIds.first);
    } else {
      widget.onSelectionChanged?.call(selectedIds);
    }
  }

  void _handleItemTap(T id) {
    _selectionManager.toggleItem(id);
    _updateSelectAllState();
    if (widget.autoCloseOnItemTap) {
      _isDropdownOpen.value = false;
    }
  }

  void _handleSelectAllTap() {
    if (widget.selectionMode != DropdownSelectionMode.multiple) return;

    final enabledIds = _filteredItems.value.where((item) => item.enabled).map((item) => item.id).toList();

    _selectionManager.toggleSelectAll(enabledIds);
    _updateSelectAllState();

    if (widget.autoCloseOnItemTap) {
      _isDropdownOpen.value = false;
    }
  }

  String _getDisplayText() {
    final selectedIds = _effectiveController.selectedIds;
    if (selectedIds.isEmpty) {
      return widget.placeholder ?? 'Select Items';
    }

    if (widget.showSelectedItemName) {
      final selectedItems = widget.items.where((item) => selectedIds.contains(item.id)).toList();
      return selectedItems.map((item) => item.name).join(', ');
    } else {
      return '${selectedIds.length} items selected';
    }
  }

  TextStyle? _getTextStyle() {
    return _effectiveController.selectedIds.isEmpty ? widget.decoration.placeholderTextStyle : widget.decoration.selectedItemTextStyle;
  }

  Widget _buildDropdownContent() {
    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxHeight: 400,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Section
          if (widget.enableSearch)
            DropdownSearchField(
              controller: _searchController,
              decoration: widget.decoration.searchDecoration,
              onChanged: (value) {
                _onSearchChanged();
              },
            ),

          // Loading State
          if (widget.showLoading)
            Expanded(
              child: widget.loadingBuilder?.call(context) ??
                  Center(
                    child: CircularProgressIndicator(),
                  ),
            )

          // Empty State
          else if (widget.isEmptyData || widget.items.isEmpty)
            Expanded(
              child: Center(
                child: widget.emptyBuilder?.call(context) ?? const Text('No Data Found'),
              ),
            )

          // Content with Select All and Items
          else
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Select All Section (only for multi-select)
                  if (widget.showSelectAll && widget.selectionMode == DropdownSelectionMode.multiple)
                    ValueListenableBuilder<bool>(
                      valueListenable: _selectAllState,
                      builder: (context, isAllSelected, _) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownSelectAllTile(
                              isSelected: isAllSelected,
                              onChanged: (_) => _handleSelectAllTap(),
                              selectAllText: widget.selectAllText,
                              decoration: widget.decoration,
                              selectAllBuilder: widget.selectAllBuilder,
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      },
                    ),

                  // Items List
                  Expanded(
                    child: ValueListenableBuilder<List<DropDownMenuItemData<T>>>(
                      valueListenable: _filteredItems,
                      builder: (context, filteredItems, _) {
                        if (filteredItems.isEmpty) {
                          return Center(
                            child: widget.emptyBuilder?.call(context) ?? const Text('No matching items'),
                          );
                        }

                        return DropdownListView<T>(
                          items: filteredItems,
                          selectedIds: _effectiveController.selectedIds.toSet(),
                          onItemTap: _handleItemTap,
                          decoration: widget.decoration,
                          selectionMode: widget.selectionMode,
                          itemBuilder: widget.itemBuilder,
                          emptyBuilder: widget.emptyBuilder,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _effectiveController,
      builder: (context, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isDropdownOpen,
          builder: (context, isOpen, _) {
            return CompositedTransformTarget(
              link: _layerLink,
              child: InkWell(
                onTap: () => _isDropdownOpen.value = !isOpen,
                child: Container(
                  padding: widget.decoration.contentPadding,
                  decoration: widget.decoration.dropdownDecoration ??
                      BoxDecoration(
                        border: Border.all(color: widget.decoration.borderColor),
                        borderRadius: BorderRadius.circular(widget.decoration.borderRadius),
                        color: widget.decoration.backgroundColor,
                      ),
                  child: Row(
                    children: [
                      if (widget.prefix != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: widget.prefix,
                        ),
                      Expanded(
                        child: Text(
                          _getDisplayText(),
                          style: _getTextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (widget.suffix != null) widget.suffix!,
                      if (widget.suffix == null)
                        isOpen
                            ? widget.decoration.closeDropdownIcon ?? const Icon(Icons.close, size: 20)
                            : widget.decoration.openDropdownIcon ?? const Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant FlutterMultiDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      _effectiveController.addListener(_onControllerChanged);
    }
    if (!DropdownHelpers.listEquals(widget.items, oldWidget.items)) {
      _filteredItems.value = _getFilteredItems();
      _updateSelectAllState();
    }
    if (widget.showLoading != oldWidget.showLoading && _overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onControllerChanged);
    _searchController.removeListener(_onSearchChanged);
    _isDropdownOpen.removeListener(_onDropdownOpenChanged);
    _isDropdownOpen.dispose();
    _filteredItems.dispose();
    _selectAllState.dispose();
    _hideDropdown();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }
}
