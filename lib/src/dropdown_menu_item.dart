/// Represents an item in the dropdown menu with selection state.
///
/// Each item has:
/// - A display [name]
/// - A unique [id] of generic type T
/// - A selection state [isSelected]
class DropDownMenuItemData<T> {
  /// The display name of the item
  final String name;

  /// The unique identifier of the item
  final T id;

  /// Whether the item is currently selected
  bool isSelected;

  /// Creates a [DropDownMenuItemData] with the given properties
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
