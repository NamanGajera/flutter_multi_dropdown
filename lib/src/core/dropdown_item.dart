/// A generic model class to represent an item in a custom dropdown menu.
///
/// This class encapsulates all properties needed for a dropdown item,
/// including its display name, unique identifier, and selection state.
///
/// Example:
/// ```dart
/// DropDownMenuItemData<int>(
///   name: 'Item 1',
///   id: 1,
///   isSelected: false,
///   enabled: true,
/// )
/// ```
class DropDownMenuItemData<T> {
  /// The display name of the dropdown item shown to the user.
  final String name;

  /// The unique identifier or value associated with this item.
  ///
  /// This can be of any type depending on your use case (e.g., `int`, `String`, etc.).
  final T id;

  /// Whether this item is currently selected.
  ///
  /// Defaults to `false`.
  bool isSelected;

  /// Whether this item is enabled (can be interacted with).
  ///
  /// If `false`, the item will typically be shown as disabled in the UI.
  /// Defaults to `true`.
  bool enabled;

  /// Creates a new instance of [DropDownMenuItemData].
  ///
  /// The [name] and [id] are required. Optionally, you can specify the initial
  /// [isSelected] and [enabled] state.
  DropDownMenuItemData({
    required this.name,
    required this.id,
    this.isSelected = false,
    this.enabled = true,
  });

  /// Creates a copy of this item with updated properties.
  ///
  /// Useful for immutability patterns and state updates.
  DropDownMenuItemData<T> copyWith({
    String? name,
    T? id,
    bool? isSelected,
    bool? enabled,
  }) {
    return DropDownMenuItemData<T>(
      name: name ?? this.name,
      id: id ?? this.id,
      isSelected: isSelected ?? this.isSelected,
      enabled: enabled ?? this.enabled,
    );
  }

  /// Compares two [DropDownMenuItemData] objects for equality.
  ///
  /// Returns `true` if all properties ([name], [id], [isSelected], and [enabled]) are equal.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropDownMenuItemData<T> &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          isSelected == other.isSelected &&
          enabled == other.enabled;

  /// Returns a hash code based on the properties of the object.
  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ isSelected.hashCode ^ enabled.hashCode;

  @override
  String toString() {
    return 'DropDownMenuItemData{name: $name, id: $id, isSelected: $isSelected, enabled: $enabled}';
  }
}
