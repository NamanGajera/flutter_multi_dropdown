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

  /// Whether to auto close dropdown on seect item
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
    _currentItems = List.from(widget.items);
  }

  void _setupInitialSelection() {
    if (widget.controller?.selectedIds.isNotEmpty ?? false) {
      _updateSelectionFromIds(widget.controller!.selectedIds);
    } else if (widget.initialValue?.isNotEmpty ?? false) {
      _updateSelectionFromIds(widget.initialValue!);
      _effectiveController.updateSelection(widget.initialValue!);
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

      _currentItems = List.from(widget.items);
      _updateSelectionFromIds(selectedIds);
    }
  }

  void _handleControllerChange() {
    if (!listEquals(_getSelectedIds(), _effectiveController.selectedIds)) {
      _updateSelectionFromIds(_effectiveController.selectedIds);
    }
  }

  List<T> _getSelectedIds() {
    return _currentItems
        .where((item) => item.isSelected)
        .map((item) => item.id)
        .toList();
  }

  void _updateSelectionFromIds(List<T> selectedIds) {
    setState(() {
      for (var item in _currentItems) {
        item.isSelected = selectedIds.contains(item.id);
      }
      _updateSelectAllState();
    });
  }

  void _updateSelectAllState() {
    setState(() {
      _selectAll = _currentItems.isEmpty
          ? false
          : _currentItems.every((item) => item.isSelected == true);
    });
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var item in _currentItems) {
        item.isSelected = _selectAll;
      }
      _notifySelectionChanged();
    });
    if (widget.autoCloseOnItemTap) {
      Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
    }
  }

  void _hideDropdown() {
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
            offset: Offset(0.0, size.height + 5.0),
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
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          side: BorderSide(
            color: widget.decoration.checkboxInActiveColor ?? Colors.black,
            width: widget.decoration.checkboxBorderWidth,
          ),
        ),
      ),
      child: CheckboxListTile(
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
    return List.generate(
      displayItems.length,
      (index) => Theme(
        data: Theme.of(context).copyWith(
          checkboxTheme: CheckboxThemeData(
            side: BorderSide(
              color: widget.decoration.checkboxInActiveColor ?? Colors.black,
              width: widget.decoration.checkboxBorderWidth,
            ),
          ),
        ),
        child: CheckboxListTile(
          title: Text(
            displayItems[index].name,
            style: widget.decoration.itemTextStyle,
          ),
          checkColor: widget.decoration.checkColor ?? const Color(0xFFFFFFFF),
          value: displayItems[index].isSelected,
          onChanged: (value) {
            displayItems[index].isSelected = value ?? false;
            _updateSelectAllState();
            _notifySelectionChanged();
            if (widget.autoCloseOnItemTap) {
              Future.delayed(const Duration(milliseconds: 50), _hideDropdown);
            }
            changeState(() {});
          },
          activeColor: widget.decoration.checkboxActiveColor,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _notifySelectionChanged() {
    final selectedIds = _getSelectedIds();
    _effectiveController.updateSelection(selectedIds);
    widget.onSelectionChanged?.call(selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
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
                          color: widget.decoration.colseDropdownIconColor,
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
    final selectedItems =
        _currentItems.where((item) => item.isSelected).toList();

    if (selectedItems.isEmpty) {
      return widget.placeholder ?? 'Select Items';
    } else if (widget.showSelectedItemName) {
      return selectedItems.map((item) => item.name).join(', ');
    } else {
      return '${selectedItems.length} items selected';
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
