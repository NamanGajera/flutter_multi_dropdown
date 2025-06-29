import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_dropdown/src/dropdown_search_field.dart';
import 'dropdown_decoration.dart';
import 'dropdown_menu_item.dart';
import 'multi_dropdown_controller.dart';

/// A customizable multi-select dropdown widget for Flutter applications.
///
/// Features include:
/// - Multiple item selection
/// - "Select All" functionality
/// - Customizable appearance
/// - Controller support for programmatic control
/// - Callbacks for selection changes
/// - Loading and empty states
/// - Search functionality
class FlutterMultiDropdown<T> extends StatefulWidget {
  /// List of items to display in the dropdown
  final List<DropDownMenuItemData<T>> items;

  /// Callback when selection changes
  final Function(List<T>)? onSelectionChanged;

  /// Decoration options for styling
  final DropdownDecoration decoration;

  /// Placeholder text when no items are selected
  final String? placeholder;

  /// Text for the "Select All" option
  final String? selectAllText;

  /// Widget to display before the selected items text
  final Widget? prefix;

  /// Widget to display after the selected items text
  final Widget? suffix;

  /// Initial selected values
  final List<T>? initialValue;

  /// Controller for programmatic control
  final MultiDropdownController<T>? controller;

  /// Whether to show selected item names or just count
  final bool showSelectedItemName;

  /// Whether to enable search functionality
  final bool enableSearch;

  /// Whether to display empty state (overrides actual empty state)
  final bool isEmptyData;

  /// Whether to display loading state (overrides actual content)
  final bool showLoading;

  /// Whether to display select all
  final bool showSelectAll;

  /// Whether to auto close dropdown on select item
  final bool autoCloseOnItemTap;

  /// Builder function for empty state
  ///
  /// Example:
  /// ```dart
  /// emptyBuilder: (context) {
  ///   return Center(child: Text('No items available'));
  /// }
  /// ```
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Builder function for loading state
  ///
  /// Example:
  /// ```dart
  /// loadingBuilder: (context) {
  ///   return Center(child: CircularProgressIndicator());
  /// }
  /// ```
  final Widget Function(BuildContext context)? loadingBuilder;

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
    Function(bool)? onChanged,
  )? itemBuilder;

  /// Builder function for custom select all widget
  ///
  /// Example:
  /// ```dart
  /// selectAllBuilder: (context, item, isSelected, onChanged) {
  ///   return Row(
  ///
  ///     onTap: () => onChanged(!isSelected),
  ///   );
  /// }
  /// ```
  final Widget Function(
    BuildContext context,
    bool selectAll,
    Function(bool)? onChanged,
  )? selectAllBuilder;

  /// Creates a [FlutterMultiDropdown] widget
  const FlutterMultiDropdown({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.decoration = const DropdownDecoration(),
    this.placeholder = 'Select Items',
    this.selectAllText = 'Select All',
    this.prefix,
    this.suffix,
    this.initialValue,
    this.controller,
    this.showSelectedItemName = true,
    this.enableSearch = false,
    this.emptyBuilder,
    this.loadingBuilder,
    this.isEmptyData = false,
    this.showLoading = false,
    this.showSelectAll = true,
    this.autoCloseOnItemTap = false,
    this.itemBuilder,
    this.selectAllBuilder,
  });

  @override
  State<FlutterMultiDropdown<T>> createState() =>
      _FlutterMultiDropdownState<T>();
}

class _FlutterMultiDropdownState<T> extends State<FlutterMultiDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;
  bool _selectAll = false;
  late MultiDropdownController<T> _internalController;
  late List<DropDownMenuItemData<T>> _currentItems;
  final List<DropDownMenuItemData<T>> _selectedItems = [];
  final SearchController _searchController = SearchController();

  MultiDropdownController<T> get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _initializeItems();
    _setupInitialSelection();
  }

  void _initializeController() {
    _internalController = MultiDropdownController<T>();
    _effectiveController.addListener(_handleControllerChange);
  }

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

  void _setupInitialSelection() {
    if (widget.controller?.selectedIds.isNotEmpty ?? false) {
      _updateSelectionFromIds(widget.controller!.selectedIds);
    } else if (widget.initialValue?.isNotEmpty ?? false) {
      _updateSelectionFromIds(widget.initialValue!);
      _effectiveController.updateSelection(widget.initialValue!);
    } else {
      // Handle items that come pre-selected (isSelected: true)
      final preSelectedItems = _currentItems
          .where(
              (item) => item.isSelected && item.enabled) // Only enabled items
          .toList();
      if (preSelectedItems.isNotEmpty) {
        final selectedIds = preSelectedItems.map((item) => item.id).toList();
        _updateSelectionFromIds(selectedIds);
        _effectiveController.updateSelection(selectedIds);
      }
    }
    _updateSelectAllState();
  }

  @override
  void didUpdateWidget(covariant FlutterMultiDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllerListener(oldWidget);
    _updateItemsIfChanged(oldWidget);
  }

  void _updateControllerListener(FlutterMultiDropdown<T> oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _effectiveController.addListener(_handleControllerChange);
    }
  }

  void _updateItemsIfChanged(FlutterMultiDropdown<T> oldWidget) {
    if (!listEquals(widget.items, oldWidget.items)) {
      final selectedIds = _currentItems
          .where((item) => item.isSelected)
          .map((item) => item.id)
          .toList();

      _currentItems = widget.items
          .map((item) => DropDownMenuItemData<T>(
                name: item.name,
                id: item.id,
                isSelected: selectedIds.contains(item.id),
                enabled: item.enabled,
              ))
          .toList();
    }
  }

  void _handleControllerChange() {
    if (!listEquals(_getSelectedIds(), _effectiveController.selectedIds)) {
      _updateSelectionFromIds(_effectiveController.selectedIds);
    }
  }

  List<T> _getSelectedIds() {
    return _currentItems
        .where((item) => item.isSelected && item.enabled) // Only enabled items
        .map((item) => item.id)
        .toList();
  }

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
        final item = _currentItems.firstWhere((item) => item.id == id);
        if (item.enabled) {
          // Only add enabled items to selection
          item.isSelected = true;
          _selectedItems.add(item);
        }
      }
      _updateSelectAllState();
    });
  }

  void _updateSelectAllState() {
    setState(() {
      final enabledItems = _currentItems.where((item) => item.enabled);
      _selectAll = enabledItems.isEmpty
          ? false
          : enabledItems.every((item) => item.isSelected == true);
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var item in _currentItems) {
        if (item.enabled) {
          // Only toggle enabled items
          item.isSelected = _selectAll;
        }
      }
      // Update selected items list
      _selectedItems.clear();
      if (_selectAll) {
        _selectedItems.addAll(
            _currentItems.where((item) => item.enabled && item.isSelected));
      } else {
        _selectedItems.addAll(
            _currentItems.where((item) => !item.enabled && item.isSelected));
      }
    });
    if (widget.autoCloseOnItemTap) {
      Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
    }
  }

  void _hideDropdown() {
    _notifySelectionChanged();
    _removeOverlay();
    setState(() => _isDropdownOpen = false);
  }

  void _showDropdown() {
    _removeOverlay();
    _createAndShowOverlay();
  }

  void _createAndShowOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildDropdownOverlay(context, size),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
  }

  Widget _buildDropdownOverlay(BuildContext context, Size size) {
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
          height: widget.decoration.maxHeight,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: _calculateDropdownOffset(size),
            child: Material(
              elevation: widget.decoration.elevation,
              borderRadius:
                  BorderRadius.circular(widget.decoration.borderRadius),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: Container(
                  decoration: widget.decoration.dropdownListDecoration ??
                      BoxDecoration(
                        color: widget.decoration.backgroundColor,
                        border:
                            Border.all(color: widget.decoration.borderColor),
                        borderRadius: BorderRadius.circular(
                          widget.decoration.borderRadius,
                        ),
                      ),
                  child: StatefulBuilder(
                    builder: (context, changeState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.enableSearch)
                              _buildSearchField(changeState),
                            if (widget.showSelectAll)
                              _buildSelectAllOption(context, changeState),
                            if (widget.showSelectAll) const Divider(height: 1),
                            if (widget.showLoading) _buildLoadingState(context),
                            if (_currentItems.isEmpty || widget.isEmptyData)
                              _buildEmptyState(context),
                            if (_currentItems.isNotEmpty && !widget.isEmptyData)
                              ..._buildItemList(context, changeState),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Offset _calculateDropdownOffset(Size size) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final dropdownHeight = widget.decoration.maxHeight;

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

  Widget _buildSearchField(void Function(void Function()) changeState) {
    return DropdownSearchField(
      controller: _searchController,
      onChanged: (value) {
        changeState(() {});
      },
      decoration: widget.decoration.searchDecoration,
    );
  }

  Widget _buildSelectAllOption(
      BuildContext context, void Function(void Function()) changeState) {
    if (widget.selectAllBuilder != null) {
      return widget.selectAllBuilder!(
        context,
        _selectAll,
        (value) {
          if (!widget.isEmptyData && !widget.showLoading) {
            _toggleSelectAll(value);
            changeState(() {});
          }
        },
      );
    }
    return Theme(
      data: Theme.of(context).copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        checkboxTheme: CheckboxThemeData(
          side: BorderSide(
            color: widget.decoration.checkboxInActiveColor ?? Colors.black,
            width: widget.decoration.checkboxBorderWidth,
          ),
        ),
      ),
      child: CheckboxListTile(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        title: Text(
          widget.selectAllText ?? 'Select All',
          style: widget.decoration.itemTextStyle,
        ),
        checkColor: widget.decoration.checkColor ?? const Color(0xFFFFFFFF),
        value: _selectAll,
        onChanged: (value) {
          if (!widget.isEmptyData && !widget.showLoading) {
            _toggleSelectAll(value);
            changeState(() {});
          }
        },
        activeColor: widget.decoration.checkboxActiveColor,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return widget.loadingBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('Loading...'),
        );
  }

  Widget _buildEmptyState(BuildContext context) {
    return widget.emptyBuilder?.call(context) ??
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('No Data Found'),
        );
  }

  List<Widget> _buildItemList(
      BuildContext context, void Function(void Function()) changeState) {
    // Filter items based on search text
    final displayItems = _searchController.text.trim().isEmpty
        ? _currentItems
        : _currentItems
            .where((item) => item.name
                .toLowerCase()
                .contains(_searchController.text.trim().toLowerCase()))
            .toList();

    return List.generate(displayItems.length, (index) {
      final item = displayItems[index];
      final isSelected = item.isSelected;
      final isEnabled = item.enabled;

      if (widget.itemBuilder != null) {
        return widget.itemBuilder!(
          context,
          item,
          isSelected,
          isEnabled
              ? (value) {
                  _handleItemSelection(item, value, changeState);
                }
              : null,
        );
      }

      // Default item builder
      return Theme(
        data: Theme.of(context).copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          checkboxTheme: CheckboxThemeData(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(
              color: widget.decoration.checkboxInActiveColor ?? Colors.black,
              width: widget.decoration.checkboxBorderWidth,
            ),
          ),
        ),
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: CheckboxListTile(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            title: Text(
              item.name,
              style: widget.decoration.itemTextStyle?.copyWith(
                color: isEnabled
                    ? (widget.decoration.itemTextStyle?.color ?? Colors.black)
                    : Colors.grey,
              ),
            ),
            checkColor: widget.decoration.checkColor ?? const Color(0xFFFFFFFF),
            value: isSelected,
            onChanged: isEnabled
                ? (value) {
                    _handleItemSelection(item, value ?? false, changeState);
                  }
                : null,
            activeColor: widget.decoration.checkboxActiveColor,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      );
    });
  }

  void _handleItemSelection(DropDownMenuItemData<T> item, bool value,
      void Function(void Function()) changeState) {
    if (!item.enabled) {
      return; // Don't allow selection changes for disabled items
    }

    changeState(() {
      item.isSelected = value;
      if (item.isSelected) {
        if (!_selectedItems.any((selected) => selected.id == item.id)) {
          _selectedItems.add(item);
        }
      } else {
        _selectedItems.removeWhere((selected) => selected.id == item.id);
      }
      _updateSelectAllState();
    });

    if (widget.autoCloseOnItemTap) {
      Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

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
                borderRadius: BorderRadius.circular(
                  widget.decoration.borderRadius,
                ),
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
                          size: widget.decoration.closeDropdownIconSize,
                        )
                    : widget.decoration.openDropdownIcon ??
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.decoration.openDropdownIconColor,
                          size: widget.decoration.openDropdownIconSize,
                        ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (_selectedItems.isEmpty) {
      return widget.placeholder ?? 'Select Items';
    } else if (widget.showSelectedItemName) {
      // Use the _selectedItems list directly which maintains selection order
      return _selectedItems.map((item) => item.name).join(', ');
    } else {
      return '${_selectedItems.length} items selected';
    }
  }

  TextStyle? _getTextStyle() {
    final selectedItems =
        _currentItems.where((item) => item.isSelected).toList();
    return selectedItems.isEmpty
        ? widget.decoration.placeholderTextStyle
        : widget.decoration.selectedItemTextStyle;
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _removeOverlay();
    _searchController.dispose();
    super.dispose();
  }
}
