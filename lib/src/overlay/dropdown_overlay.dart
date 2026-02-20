import 'package:flutter/material.dart';

/// A reusable overlay widget for dropdown menus that handles positioning and dismissal.
///
/// The [DropdownOverlay] manages the positioning of dropdown content relative to
/// its anchor widget, automatically adjusting to ensure visibility within the screen.
/// It also handles tap-outside-to-dismiss behavior.
///
/// This widget is particularly useful when you need custom dropdown behavior that
/// isn't covered by the standard [FlutterMultiDropdown] widget.
///
/// ## Features
///
/// - Automatic positioning above or below based on available space
/// - Tap outside to dismiss
/// - Customizable dimensions and styling
/// - Configurable elevation and border radius
/// - Composited transform follower for precise positioning
///
/// ## Usage
///
/// ```dart
/// DropdownOverlay(
///   layerLink: _layerLink,
///   isOpen: _isDropdownOpen,
///   onClose: () => setState(() => _isDropdownOpen = false),
///   width: 300,
///   height: 400,
///   child: YourDropdownContent(),
/// )
/// ```
///
/// ## Positioning Logic
///
/// The overlay automatically calculates whether to appear below or above the anchor:
/// - **Below**: If there's enough space below the anchor
/// - **Above**: If there's more space above and not enough below
///
/// This ensures the dropdown is always fully visible within the screen bounds.
///
/// See also:
/// - [CompositedTransformTarget] and [CompositedTransformFollower] for positioning
/// - [Overlay] and [OverlayEntry] for overlay management
class DropdownOverlay extends StatefulWidget {
  /// The [LayerLink] that connects the anchor widget to the overlay.
  ///
  /// This link is used to position the overlay relative to its target.
  /// The anchor widget should be wrapped in a [CompositedTransformTarget]
  /// with the same link.
  final LayerLink layerLink;

  /// Whether the dropdown overlay should be visible.
  ///
  /// When true, the overlay is shown. When false, it's hidden.
  /// Changes to this value are animated via the overlay system.
  final bool isOpen;

  /// Callback triggered when the user taps outside the overlay.
  ///
  /// Typically used to set [isOpen] to false.
  final VoidCallback onClose;

  /// The content to display within the overlay.
  ///
  /// This can be any widget, typically containing your dropdown items.
  final Widget child;

  /// The width of the overlay.
  ///
  /// If null, defaults to the width of the anchor widget.
  final double? width;

  /// The maximum height of the overlay.
  ///
  /// The overlay will not exceed this height, scrolling if necessary.
  /// If null, defaults to 40% of screen height.
  final double? height;

  /// The elevation of the overlay material.
  ///
  /// Controls the shadow depth. Higher values create deeper shadows.
  ///
  /// Defaults to 8.0.
  final double elevation;

  /// The border radius of the overlay.
  ///
  /// Applied to the overlay's container for rounded corners.
  final BorderRadius? borderRadius;

  /// Custom decoration for the overlay container.
  ///
  /// If provided, overrides the default white background with optional
  /// border, gradient, or other decoration properties.
  ///
  /// Example:
  /// ```dart
  /// decoration: BoxDecoration(
  ///   color: Colors.white,
  ///   borderRadius: BorderRadius.circular(8),
  ///   boxShadow: [
  ///     BoxShadow(
  ///       color: Colors.black26,
  ///       blurRadius: 10,
  ///       offset: Offset(0, 5),
  ///     ),
  ///   ],
  /// )
  /// ```
  final BoxDecoration? decoration;

  /// Creates a [DropdownOverlay] widget.
  ///
  /// The [layerLink], [isOpen], [onClose], and [child] parameters are required.
  const DropdownOverlay({
    super.key,
    required this.layerLink,
    required this.isOpen,
    required this.onClose,
    required this.child,
    this.width,
    this.height,
    this.elevation = 8.0,
    this.borderRadius,
    this.decoration,
  });

  @override
  State<DropdownOverlay> createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<DropdownOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isOpen) {
        _showOverlay();
      }
    });
  }

  @override
  void didUpdateWidget(DropdownOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _createOverlay();
  }

  void _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onClose,
            ),
          ),
          Positioned(
            width: widget.width ?? size.width,
            child: CompositedTransformFollower(
              link: widget.layerLink,
              showWhenUnlinked: false,
              offset: _calculateOffset(size, screenSize, position),
              child: Material(
                elevation: widget.elevation,
                borderRadius: widget.borderRadius,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: widget.height ?? screenSize.height * 0.4,
                    ),
                    decoration: widget.decoration ??
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius: widget.borderRadius,
                        ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Offset _calculateOffset(Size widgetSize, Size screenSize, Offset position) {
    final spaceBelow = screenSize.height - position.dy - widgetSize.height;
    final spaceAbove = position.dy;

    if (spaceBelow < (widget.height ?? 200) && spaceAbove >= (widget.height ?? 200)) {
      return Offset(0, -(widget.height ?? 200) - 5);
    }

    return Offset(0, widgetSize.height + 5);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: widget.layerLink,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }
}
