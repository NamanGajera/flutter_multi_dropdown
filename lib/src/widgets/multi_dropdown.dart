import 'package:flutter/material.dart';
import '../core/dropdown_item.dart';
import '../core/multi_dropdown_controller.dart';
import '../themes/dropdown_decoration.dart';
import '../utils/dropdown_selection_mode.dart';
import '../utils/dropdown_helpers.dart';
import 'dropdown_search_field.dart';

/// A customizable dropdown widget for Flutter applications that supports both single and multi-select.
///
/// Features include:
/// - Single or multiple item selection modes
/// - "Select All" functionality (for multi-select only)
/// - Customizable appearance through [DropdownDecoration]
/// - Controller support for programmatic control
/// - Callbacks for selection changes
/// - Loading and empty states with custom builders
/// - Search functionality
/// - API data integration with proper selection synchronization
///
/// ## Usage
///
/// ### Basic Usage
/// ```dart
/// FlutterMultiDropdown<int>(
///   items: [
///     DropDownMenuItemData(name: 'Item 1', id: 1),
///     DropDownMenuItemData(name: 'Item 2', id: 2),
///   ],
///   onSelectionChanged: (selectedIds) {
///     print('Selected IDs: $selectedIds');
///   },
/// )
/// ```
///
/// ### With API Data
/// ```dart
/// // Initialize controller before data loads
/// final controller = MultiDropdownController<int>();
///
/// // When API data arrives
/// Future<void> loadData() async {
///   final data = await api.getItems();
///   final items = data.map((item) =>
///     DropDownMenuItemData(name: item.name, id: item.id)
///   ).toList();
///
///   // Update dropdown items
///   setState(() {
///     _items = items;
///   });
///
///   // Controller will automatically select items
///   // that were selected before data loaded
/// }
///
/// // In build method
/// FlutterMultiDropdown<int>(
///   items: _items,
///   controller: controller,
/// )
/// ```
///
/// See also:
/// - [MultiDropdownController] for programmatic control
/// - [DropdownDecoration] for styling options
/// - [DropDownMenuItemData] for item configuration
class FlutterMultiDropdown<T> extends StatefulWidget {
  /// List of items to display in the dropdown
  final List<DropDownMenuItemData<T>> items;

  /// Callback when selection changes (for multi-select mode)
  final ValueChanged<List<T>>? onSelectionChanged;

  /// Callback when single item is selected (only in single selection mode)
  final ValueChanged<T>? onSingleItemSelected;

  /// Decoration options for styling
  final DropdownDecoration decoration;

  /// Placeholder text when no items are selected
  final String? placeholder;

  /// Text for the "Select All" option (only for multi-select mode)
  final String? selectAllText;

  /// Widget to display before the selected items text
  final Widget? prefix;

  /// Widget to display after the selected items text
  final Widget? suffix;

  /// Initial selected values (for multi-select mode)
  final List<T>? initialValue;

  /// Initial single selected value (for single selection mode)
  final T? initialSingleValue;

  /// Controller for programmatic control
  final MultiDropdownController<T>? controller;

  /// Whether to show selected item names or just count
  final bool showSelectedItemName;

  /// Whether to enable search functionality
  final bool enableSearch;

  /// Custom search controller (optional)
  final SearchController? searchController;

  /// Whether to display empty state (overrides actual empty state)
  final bool isEmptyData;

  /// Whether to display loading state (overrides actual content)
  final bool showLoading;

  /// Whether to display select all (only for multi-select mode)
  final bool showSelectAll;

  /// Whether to auto close dropdown on select item
  final bool autoCloseOnItemTap;

  /// Selection mode (single or multiple)
  final DropdownSelectionMode selectionMode;

  /// Limits the number of items a user can select in the dropdown (only for multi-select mode)
  final int? maxSelection;

  /// Optional callback that triggers when the user tries to select more items than the limit
  final VoidCallback? onMaxSelectionReached;

  /// Builder function for empty state
  ///
  /// Example:
  /// ```dart
  /// emptyBuilder: (context) {
  ///   return Center(child: Text('No items available'));
  /// }
  /// ```
  final WidgetBuilder? emptyBuilder;

  /// Builder function for loading state
  ///
  /// Example:
  /// ```dart
  /// loadingBuilder: (context) {
  ///   return Center(child: CircularProgressIndicator());
  /// }
  /// ```
  final WidgetBuilder? loadingBuilder;

  /// Builder function for custom item widgets
  ///
  /// Example:
  /// ```dart
  /// itemBuilder: (context, item, isSelected, onChanged) {
  ///   return ListTile(
  ///     leading: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank),
  ///     title: Text(item.name),
  ///     onTap: () => onChanged(!isSelected),
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    DropDownMenuItemData<T> item,
    bool isSelected,
    ValueChanged<bool?>? onChanged,
  )? itemBuilder;

  /// Builder function for custom select all widget (only for multi-select mode)
  ///
  /// Example:
  /// ```dart
  /// selectAllBuilder: (context, isSelected, onChanged) {
  ///   return CheckboxListTile(
  ///     title: Text('Select All'),
  ///     value: isSelected,
  ///     onChanged: onChanged,
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    bool isSelected,
    ValueChanged<bool?>? onChanged,
  )? selectAllBuilder;

  /// Creates a [FlutterMultiDropdown] widget
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
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  bool _selectAll = false;
  late MultiDropdownController<T> _internalController;
  late List<DropDownMenuItemData<T>> _currentItems;
  final List<DropDownMenuItemData<T>> _selectedItems = [];
  late SearchController _searchController;

  /// Gets the effective controller (external or internal)
  MultiDropdownController<T> get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _initializeSearchController();
    _initializeItems();
    _setupInitialSelection();
  }

  /// Initializes the controller (external or internal)
  void _initializeController() {
    _internalController = MultiDropdownController<T>();
    _effectiveController.addListener(_handleControllerChange);
  }

  /// Initializes the search controller
  void _initializeSearchController() {
    _searchController = widget.searchController ?? SearchController();
  }

  /// Initializes the items list from widget items
  void _initializeItems() {
    _currentItems = widget.items
        .map((item) => DropDownMenuItemData<T>(
              name: item.name,
              id: item.id,
              isSelected: item.isSelected,
              enabled: item.enabled,
            ))
        .toList();
  }

  /// Sets up initial selection based on controller, initial values, or pre-selected items
  void _setupInitialSelection() {
    if (widget.selectionMode == DropdownSelectionMode.multiple) {
      // Multi-select initialization
      if (widget.controller?.selectedIds.isNotEmpty ?? false) {
        _updateSelectionFromIds(widget.controller!.selectedIds);
      } else if (widget.initialValue?.isNotEmpty ?? false) {
        _updateSelectionFromIds(widget.initialValue!);
        _effectiveController.updateSelection(widget.initialValue!);
      } else {
        // Handle items that come pre-selected (isSelected: true)
        final preSelectedItems = _currentItems
            .where((item) => item.isSelected && item.enabled) // Only enabled items
            .toList();
        if (preSelectedItems.isNotEmpty) {
          final selectedIds = preSelectedItems.map((item) => item.id).toList();
          _updateSelectionFromIds(selectedIds);
          _effectiveController.updateSelection(selectedIds);
        }
      }
      _updateSelectAllState();
    } else {
      // Single-select initialization
      if (widget.controller?.selectedIds.isNotEmpty ?? false) {
        final id = widget.controller!.selectedIds.first;
        _selectSingleItem(id);
      } else if (widget.initialSingleValue != null) {
        _selectSingleItem(widget.initialSingleValue as T);
        _effectiveController.updateSelection([widget.initialSingleValue as T]);
      } else {
        // Handle items that come pre-selected (isSelected: true)
        final preSelectedItem = _currentItems.firstWhere(
          (item) => item.isSelected && item.enabled,
          orElse: () => DropDownMenuItemData<T>(
            name: '',
            id: _currentItems.isNotEmpty ? _currentItems.first.id : (null as T),
            isSelected: false,
            enabled: false,
          ),
        );
        if (preSelectedItem.enabled) {
          _selectSingleItem(preSelectedItem.id);
          _effectiveController.updateSelection([preSelectedItem.id]);
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant FlutterMultiDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllerListener(oldWidget);
    _updateItemsIfChanged(oldWidget);

    if (widget.showLoading != oldWidget.showLoading && _overlayEntry != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
  }

  /// Updates controller listener when widget controller changes
  void _updateControllerListener(FlutterMultiDropdown<T> oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _effectiveController.addListener(_handleControllerChange);
    }
  }

  /// Updates items list when widget items change (e.g., from API)
  void _updateItemsIfChanged(FlutterMultiDropdown<T> oldWidget) {
    if (!DropdownHelpers.listEquals(widget.items, oldWidget.items)) {
      _syncItemsWithController();
    }
  }

  /// Synchronizes dropdown items with controller selections
  /// This fixes the API data + pre-selection issue
  void _syncItemsWithController() {
    final selectedIds = _effectiveController.selectedIds;

    // Update current items while preserving selections from controller
    _currentItems = widget.items.map((item) {
      final isSelected = selectedIds.contains(item.id);
      return item.copyWith(isSelected: isSelected);
    }).toList();

    // Update UI if needed
    if (mounted) {
      setState(() {
        _selectedItems.clear();
        _selectedItems.addAll(_currentItems.where((item) => item.isSelected && item.enabled));
        _updateSelectAllState();
      });
    }
  }

  /// Handles controller changes (when selection is updated programmatically)
  void _handleControllerChange() {
    if (widget.selectionMode == DropdownSelectionMode.multiple) {
      if (!DropdownHelpers.listEquals(_getSelectedIds(), _effectiveController.selectedIds)) {
        _updateSelectionFromIds(_effectiveController.selectedIds);
      }
    } else {
      // Single selection mode
      final currentSelectedId = DropdownHelpers.firstOrNull(_getSelectedIds());
      final controllerSelectedId = DropdownHelpers.firstOrNull(_effectiveController.selectedIds);

      if (currentSelectedId != controllerSelectedId) {
        if (controllerSelectedId != null) {
          _selectSingleItem(controllerSelectedId);
        } else {
          // Clear selection if controller has empty selection
          _clearSingleSelection();
        }
      }
    }
  }

  /// Gets the list of selected item IDs
  List<T> _getSelectedIds() {
    return _currentItems
        .where((item) => item.isSelected && item.enabled) // Only enabled items
        .map((item) => item.id)
        .toList();
  }

  /// Updates selection based on a list of IDs
  void _updateSelectionFromIds(List<T> selectedIds) {
    setState(() {
      for (var item in _currentItems) {
        // Only update selection if item is enabled or already selected
        if (item.enabled || selectedIds.contains(item.id)) {
          item.isSelected = selectedIds.contains(item.id);
        }
      }
      _selectedItems.clear();
      // Add items in the order they appear in selectedIds (for initial values)
      for (var id in selectedIds) {
        final item = _currentItems.firstWhere(
          (item) => item.id == id,
          orElse: () => DropDownMenuItemData<T>(
            name: '',
            id: id,
            isSelected: false,
            enabled: false,
          ),
        );
        if (item.enabled) {
          // Only add enabled items to selection
          item.isSelected = true;
          _selectedItems.add(item);
        }
      }
      _updateSelectAllState();
    });
  }

  /// Selects a single item by ID
  void _selectSingleItem(T id) {
    setState(() {
      // Clear all selections first
      for (var item in _currentItems) {
        item.isSelected = false;
      }

      // Select the specified item if it exists and is enabled
      final itemIndex = _currentItems.indexWhere((item) => item.id == id);
      if (itemIndex != -1) {
        final item = _currentItems[itemIndex];
        if (item.enabled) {
          item.isSelected = true;
          _selectedItems.clear();
          _selectedItems.add(item);
        } else {
          _selectedItems.clear();
        }
      } else {
        _selectedItems.clear();
      }
    });
  }

  /// Clears single selection
  void _clearSingleSelection() {
    setState(() {
      for (var item in _currentItems) {
        item.isSelected = false;
      }
      _selectedItems.clear();
    });
  }

  /// Updates the select all checkbox state
  void _updateSelectAllState() {
    // Only update select all for multi-select mode
    if (widget.selectionMode != DropdownSelectionMode.multiple) return;

    setState(() {
      final enabledItems = _currentItems.where((item) => item.enabled);

      if (enabledItems.isEmpty) {
        _selectAll = false;
        return;
      }

      if (widget.maxSelection != null) {
        final selectedCount = enabledItems.where((item) => item.isSelected).length;
        final maxSelectCount = widget.maxSelection!;

        _selectAll = enabledItems.every((item) => item.isSelected == true) || (selectedCount == maxSelectCount && maxSelectCount > 0);
      } else {
        _selectAll = enabledItems.every((item) => item.isSelected == true);
      }
    });
  }

  /// Toggles the select all checkbox
  void _toggleSelectAll(bool? value) {
    if (widget.selectionMode != DropdownSelectionMode.multiple) return;

    setState(() {
      final enabledItems = _currentItems.where((item) => item.enabled);
      final availableToSelect = enabledItems.where((item) => !item.isSelected).toList();

      if (value == true && widget.maxSelection != null) {
        final currentSelectedCount = enabledItems.where((item) => item.isSelected).length;

        if (currentSelectedCount >= widget.maxSelection!) {
          widget.onMaxSelectionReached?.call();
          return;
        }

        final canSelectCount = widget.maxSelection! - currentSelectedCount;

        for (int i = 0; i < canSelectCount && i < availableToSelect.length; i++) {
          availableToSelect[i].isSelected = true;
          if (!_selectedItems.contains(availableToSelect[i])) {
            _selectedItems.add(availableToSelect[i]);
          }
        }

        _updateSelectAllState();
        return;
      }

      _selectAll = value ?? false;
      for (var item in _currentItems) {
        if (item.enabled) {
          item.isSelected = _selectAll;
        }
      }

      _selectedItems.clear();
      if (_selectAll) {
        _selectedItems.addAll(_currentItems.where((item) => item.enabled && item.isSelected));
      } else {
        _selectedItems.addAll(_currentItems.where((item) => !item.enabled && item.isSelected));
      }
    });

    if (widget.autoCloseOnItemTap) {
      Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
    }
  }

  /// Hides the dropdown overlay
  void _hideDropdown() {
    _notifySelectionChanged();
    _removeOverlay();
    setState(() => _isDropdownOpen = false);
  }

  /// Shows the dropdown overlay
  void _showDropdown() {
    _removeOverlay();
    _createAndShowOverlay();
  }

  /// Creates and shows the overlay
  void _createAndShowOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildDropdownOverlay(context, size),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  /// Builds the dropdown overlay widget
  Widget _buildDropdownOverlay(BuildContext context, Size size) {
    final dropdownHeight = _calculateDropdownHeight();

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _hideDropdown,
          ),
        ),
        Positioned(
          width: size.width,
          height: dropdownHeight, // Use dynamic height
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: _calculateDropdownOffset(size, dropdownHeight), // Pass height
            child: Material(
              elevation: widget.decoration.elevation,
              borderRadius: BorderRadius.circular(widget.decoration.borderRadius),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  decoration: widget.decoration.dropdownListDecoration ??
                      BoxDecoration(
                        color: widget.decoration.backgroundColor,
                        border: Border.all(color: widget.decoration.borderColor),
                        borderRadius: BorderRadius.circular(widget.decoration.borderRadius),
                      ),
                  child: _buildDropdownContent(dropdownHeight), // New method
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the dropdown content with proper constraints
  Widget _buildDropdownContent(double dropdownHeight) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: dropdownHeight,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.enableSearch) _buildSearchField((_) {}),
            if (widget.showSelectAll && widget.selectionMode == DropdownSelectionMode.multiple) _buildSelectAllOption(context, (_) {}),
            if (widget.showSelectAll && widget.selectionMode == DropdownSelectionMode.multiple) const Divider(height: 1),
            if (widget.showLoading) _buildLoadingState(context),
            if ((_currentItems.isEmpty || widget.isEmptyData) && !widget.showLoading) _buildEmptyState(context),
            if (_currentItems.isNotEmpty && !widget.isEmptyData && !widget.showLoading) ..._buildItemList(context, (_) {}),
          ],
        ),
      ),
    );
  }

  /// Calculates the dropdown offset position
  Offset _calculateDropdownOffset(Size size, double dropdownHeight) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if there's enough space below the widget
    final spaceBelow = screenHeight - position.dy - size.height;
    final spaceAbove = position.dy;

    // If there's not enough space below but enough above, open upwards
    if (spaceBelow < dropdownHeight && spaceAbove >= dropdownHeight) {
      return Offset(0.0, -dropdownHeight - 5.0);
    }

    // Default: open downwards
    return Offset(0.0, size.height + 5.0);
  }

  /// Calculates the dynamic height for the dropdown overlay
  double _calculateDropdownHeight() {
    final displayItemCount = _getDisplayItemCount();

    return DropdownHelpers.calculateDropdownHeight(
      itemCount: displayItemCount,
      maxVisibleItems: widget.decoration.maxVisibleItems,
      itemHeight: widget.decoration.itemHeight,
      minHeight: widget.decoration.minHeight,
      hasSearch: widget.enableSearch,
      hasSelectAll: widget.showSelectAll && widget.selectionMode == DropdownSelectionMode.multiple,
      isLoading: widget.showLoading,
      isEmpty: _currentItems.isEmpty || widget.isEmptyData,
    );
  }

  /// Gets the count of items to display (considering search filter)
  int _getDisplayItemCount() {
    if (_searchController.text.trim().isEmpty) {
      return _currentItems.length;
    }

    return _currentItems.where((item) => item.name.toLowerCase().contains(_searchController.text.trim().toLowerCase())).length;
  }

  /// Builds the search field widget
  Widget _buildSearchField(void Function(void Function()) setState) {
    return DropdownSearchField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: widget.decoration.searchDecoration,
    );
  }

  /// Builds the select all option widget
  Widget _buildSelectAllOption(BuildContext context, void Function(void Function()) setState) {
    if (widget.selectAllBuilder != null) {
      return SizedBox(
        height: widget.decoration.itemHeight,
        child: widget.selectAllBuilder!(
          context,
          _selectAll,
          (value) {
            if (!widget.isEmptyData && !widget.showLoading) {
              _toggleSelectAll(value);
              setState(() {});
            }
          },
        ),
      );
    }

    return SizedBox(
      height: widget.decoration.itemHeight,
      child: Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          checkboxTheme: CheckboxThemeData(
            side: BorderSide(
              color: widget.decoration.checkboxInActiveColor ?? const Color(0xFF757575),
              width: widget.decoration.checkboxBorderWidth,
            ),
          ),
        ),
        child: CheckboxListTile(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          dense: true,
          title: Text(
            widget.selectAllText ?? 'Select All',
            style: widget.decoration.itemTextStyle,
          ),
          checkColor: widget.decoration.checkColor ?? const Color(0xFFFFFFFF),
          value: _selectAll,
          onChanged: (value) {
            if (!widget.isEmptyData && !widget.showLoading) {
              _toggleSelectAll(value);
              setState(() {});
            }
          },
          activeColor: widget.decoration.checkboxActiveColor,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  /// Builds the loading state widget
  Widget _buildLoadingState(BuildContext context) {
    return widget.loadingBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(child: CircularProgressIndicator()),
        );
  }

  /// Builds the empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return widget.emptyBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Center(child: Text('No Data Found')),
        );
  }

  /// Builds the list of item widgets
  List<Widget> _buildItemList(BuildContext context, void Function(void Function()) setState) {
    // Filter items based on search text
    final displayItems = _searchController.text.trim().isEmpty
        ? _currentItems
        : _currentItems.where((item) => item.name.toLowerCase().contains(_searchController.text.trim().toLowerCase())).toList();

    if (displayItems.isEmpty) {
      return [_buildEmptyState(context)];
    }

    return List.generate(displayItems.length, (index) {
      final item = displayItems[index];
      final isSelected = item.isSelected;
      final isEnabled = item.enabled;

      if (widget.itemBuilder != null) {
        return SizedBox(
          height: widget.decoration.itemHeight,
          child: widget.itemBuilder!(
            context,
            item,
            isSelected,
            isEnabled
                ? (value) {
                    _handleItemSelection(item, value ?? false, setState);
                  }
                : null,
          ),
        );
      }

      // Default item builder with consistent height
      return SizedBox(
        height: widget.decoration.itemHeight,
        child: Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.5,
            child: widget.selectionMode == DropdownSelectionMode.single
                ? RadioListTile<T>(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    dense: true,
                    title: Text(
                      item.name,
                      style: widget.decoration.itemTextStyle?.copyWith(
                        color: isEnabled ? (widget.decoration.itemTextStyle?.color ?? Colors.black) : Colors.grey,
                      ),
                    ),
                    value: item.id,
                    groupValue: DropdownHelpers.firstOrNull(_getSelectedIds()),
                    onChanged: isEnabled
                        ? (value) {
                            _handleItemSelection(item, value != null, setState);
                          }
                        : null,
                    activeColor: widget.decoration.checkboxActiveColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  )
                : CheckboxListTile(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    dense: true,
                    title: Text(
                      item.name,
                      style: widget.decoration.itemTextStyle?.copyWith(
                        color: isEnabled ? (widget.decoration.itemTextStyle?.color ?? Colors.black) : Colors.grey,
                      ),
                    ),
                    checkColor: widget.decoration.checkColor ?? const Color(0xFFFFFFFF),
                    value: isSelected,
                    onChanged: isEnabled
                        ? (value) {
                            _handleItemSelection(item, value ?? false, setState);
                          }
                        : null,
                    activeColor: widget.decoration.checkboxActiveColor,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
          ),
        ),
      );
    });
  }

  /// Handles item selection/deselection
  void _handleItemSelection(DropDownMenuItemData<T> item, bool value, void Function(void Function()) setState) {
    if (!item.enabled) {
      return;
    }

    setState(() {
      if (widget.selectionMode == DropdownSelectionMode.multiple) {
        // Multi-select logic
        if (value && widget.maxSelection != null) {
          final selectedCount = _currentItems.where((i) => i.isSelected && i.enabled).length;

          if (selectedCount >= widget.maxSelection! && !item.isSelected) {
            widget.onMaxSelectionReached?.call();
            return;
          }
        }

        item.isSelected = value;
        if (item.isSelected) {
          if (!_selectedItems.any((selected) => selected.id == item.id)) {
            _selectedItems.add(item);
          }
        } else {
          _selectedItems.removeWhere((selected) => selected.id == item.id);
        }
        _updateSelectAllState();
      } else {
        // Single-select logic
        if (value) {
          // Select this item and deselect all others
          for (var otherItem in _currentItems) {
            otherItem.isSelected = false;
          }
          item.isSelected = true;
          _selectedItems.clear();
          _selectedItems.add(item);

          // Call single item selected callback
          widget.onSingleItemSelected?.call(item.id);
        } else {
          // Don't allow deselecting in single mode unless autoCloseOnItemTap is false
          // (Allow tapping the same item to deselect it when not auto-closing)
          if (!widget.autoCloseOnItemTap && item.isSelected) {
            item.isSelected = false;
            _selectedItems.clear();
          } else {
            // Re-select the item to maintain single selection
            item.isSelected = true;
          }
        }
      }
    });

    if (widget.autoCloseOnItemTap) {
      Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
    }
  }

  /// Removes the overlay entry
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Notifies listeners about selection changes
  void _notifySelectionChanged() {
    final selectedIds = _selectedItems
        .where((item) => item.enabled) // Only include enabled items
        .map((item) => item.id)
        .toList();
    _effectiveController.updateSelection(selectedIds);
    widget.onSelectionChanged?.call(selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        onTap: _isDropdownOpen ? _hideDropdown : _showDropdown,
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
              if (widget.suffix == null) ...[
                _isDropdownOpen
                    ? widget.decoration.closeDropdownIcon ??
                        Icon(
                          Icons.close,
                          color: widget.decoration.closeDropdownIconColor,
                          size: widget.decoration.closeDropdownIconSize ?? 20,
                        )
                    : widget.decoration.openDropdownIcon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.decoration.openDropdownIconColor,
                          size: widget.decoration.openDropdownIconSize ?? 20,
                        ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the display text for the dropdown button
  String _getDisplayText() {
    if (_selectedItems.isEmpty) {
      return widget.placeholder ?? 'Select Items';
    } else if (widget.showSelectedItemName) {
      // Use the _selectedItems list directly which maintains selection order
      return _selectedItems.map((item) => item.name).join(', ');
    } else {
      return widget.selectionMode == DropdownSelectionMode.single
          ? '${_selectedItems.length} item selected'
          : '${_selectedItems.length} items selected';
    }
  }

  /// Gets the text style for the dropdown button
  TextStyle? _getTextStyle() {
    return _selectedItems.isEmpty ? widget.decoration.placeholderTextStyle : widget.decoration.selectedItemTextStyle;
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _removeOverlay();
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }
}
