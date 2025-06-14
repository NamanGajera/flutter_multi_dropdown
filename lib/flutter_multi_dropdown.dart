import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultiDropdownController<T> extends ChangeNotifier {
  List<T> _selectedIds = [];
  List<T> get selectedIds => _selectedIds;

  void updateSelection(List<T> ids) {
    _selectedIds = List.from(ids);
    notifyListeners();
  }

  void clearSelection() {
    _selectedIds.clear();
    notifyListeners();
  }
}

class FlutterMultiDropdown<T> extends StatefulWidget {
  final List<DropDownMenuItemData<T>> items;
  final Function(List<T>)? onSelectionChanged;
  final DropdownDecoration decoration;
  final String? placeholder;
  final String? selectAllText;
  final Widget? prefix;
  final Widget? suffix;
  final List<T>? initialValue;
  final MultiDropdownController<T>? controller;
  final bool showSelectedItemName;

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

  MultiDropdownController<T> get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = MultiDropdownController<T>();
    _currentItems = List.from(widget.items);

    _effectiveController.addListener(_handleControllerChange);

    // Initialize selection from controller or initialValue
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

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      _effectiveController.addListener(_handleControllerChange);
    }

    // Only update items if they've actually changed
    if (!listEquals(widget.items, oldWidget.items)) {
      // Preserve selection state when items change
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
    Future.delayed(Duration(milliseconds: 50), _hideDropdown);
  }

  void _toggleItem(int index, bool? value) {
    setState(() {
      _currentItems[index].isSelected = value ?? false;
      _updateSelectAllState();
      _notifySelectionChanged();
    });
    Future.delayed(Duration(milliseconds: 50), _hideDropdown);
  }

  void _hideDropdown() {
    _removeOverlay();
    setState(() => _isDropdownOpen = false);
  }

  void _showDropdown() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
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
                borderRadius: BorderRadius.circular(
                  widget.decoration.borderRadius,
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Container(
                    decoration: widget.decoration.dropdownListDecoration ??
                        BoxDecoration(
                          color: widget.decoration.backgroundColor,
                          border: Border.all(
                            color: widget.decoration.borderColor,
                          ),
                          borderRadius: BorderRadius.circular(
                            widget.decoration.borderRadius,
                          ),
                        ),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    side: BorderSide(
                                      color: widget.decoration
                                              .checkboxInActiveColor ??
                                          Colors.black,
                                      width:
                                          widget.decoration.checkboxBorderWidth,
                                    ),
                                  ),
                                ),
                                child: CheckboxListTile(
                                  title: Text(
                                    widget.selectAllText ?? 'Select All',
                                    style: widget.decoration.itemTextStyle,
                                  ),
                                  checkColor: widget.decoration.checkColor ??
                                      Color(0xFFFFFFFF),
                                  value: _selectAll,
                                  onChanged: (value) {
                                    _toggleSelectAll(value);
                                    setState(() {});
                                  },
                                  activeColor:
                                      widget.decoration.checkboxActiveColor,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              const Divider(height: 1),
                              ...List.generate(
                                _currentItems.length,
                                (index) => Theme(
                                  data: Theme.of(context).copyWith(
                                    checkboxTheme: CheckboxThemeData(
                                      side: BorderSide(
                                        color: widget.decoration
                                                .checkboxInActiveColor ??
                                            Colors.black,
                                        width: widget
                                            .decoration.checkboxBorderWidth,
                                      ),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text(
                                      _currentItems[index].name,
                                      style: widget.decoration.itemTextStyle,
                                    ),
                                    checkColor: widget.decoration.checkColor ??
                                        Color(0xFFFFFFFF),
                                    value: _currentItems[index].isSelected,
                                    onChanged: (value) {
                                      _toggleItem(index, value);
                                      setState(() {});
                                    },
                                    activeColor:
                                        widget.decoration.checkboxActiveColor,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                ),
                              ),
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
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownOpen = true);
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
    final selectedItems =
        _currentItems.where((item) => item.isSelected).toList();
    String displayText;

    if (selectedItems.isEmpty) {
      displayText = widget.placeholder ?? 'Select Items';
    } else if (widget.showSelectedItemName) {
      displayText = selectedItems.map((item) => item.name).join(', ');
    } else {
      displayText = '${selectedItems.length} items selected';
    }

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
                  displayText,
                  style: selectedItems.isEmpty
                      ? widget.decoration.placeholderTextStyle
                      : widget.decoration.selectedItemTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (widget.suffix != null) widget.suffix!,
              if (widget.suffix == null)
                widget.decoration.dropdownIcon ??
                    Icon(
                      _isDropdownOpen
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: widget.decoration.dropdownIconColor,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_handleControllerChange);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _removeOverlay();
    super.dispose();
  }
}

class DropdownDecoration {
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final EdgeInsets contentPadding;
  final double elevation;
  final double maxHeight;
  final TextStyle? placeholderTextStyle;
  final TextStyle? selectedItemTextStyle;
  final TextStyle? itemTextStyle;
  final Color? checkboxActiveColor;
  final Color? checkboxInActiveColor;
  final Color? checkColor;
  final double checkboxBorderWidth;
  final Color? dropdownIconColor;
  final Widget? dropdownIcon;
  final BoxDecoration? dropdownDecoration;
  final BoxDecoration? dropdownListDecoration;
  final List<BoxShadow>? boxShadow;

  const DropdownDecoration({
    this.borderRadius = 6.0,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    this.elevation = 4.0,
    this.maxHeight = 260,
    this.placeholderTextStyle = const TextStyle(
      color: Color(0XFF828282),
      fontSize: 14,
    ),
    this.selectedItemTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.itemTextStyle,
    this.checkboxActiveColor,
    this.checkboxInActiveColor,
    this.dropdownIconColor = Colors.grey,
    this.checkColor,
    this.dropdownIcon,
    this.dropdownDecoration,
    this.dropdownListDecoration,
    this.boxShadow,
    this.checkboxBorderWidth = 1.5,
  });
}

class DropDownMenuItemData<T> {
  final String name;
  final T id;
  bool isSelected;

  DropDownMenuItemData({
    required this.name,
    required this.id,
    this.isSelected = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownMenuItemData &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
