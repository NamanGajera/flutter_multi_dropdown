# Flutter Multi Dropdown 🚀

[![Pub Version](https://img.shields.io/pub/v/flutter_multi_dropdown)](https://pub.dev/packages/flutter_multi_dropdown)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A highly customizable multi-select dropdown widget for Flutter with select-all functionality, type safety, and comprehensive decoration options.

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_multi_dropdown: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## 🎮 Basic Usage

```dart
import 'package:flutter_multi_dropdown/flutter_multi_dropdown.dart';

// Simple usage with controller
final MultiDropdownController dropdownController = MultiDropdownController();

FlutterMultiDropdown<int>(
  controller: dropdownController,
  items: const [
    DropDownMenuItemData(name: 'Option 1', id: 1),
    DropDownMenuItemData(name: 'Option 2', id: 2),
    DropDownMenuItemData(name: 'Option 3', id: 3),
  ],
  onSelectionChanged: (selectedItems) {
    print('Selected items: $selectedItems');
  },
)
```

## ⚙️ Configuration

### Widget Properties

| Property               | Description                     | Type                            | Default          |
| ---------------------- | ------------------------------- | ------------------------------- | ---------------- |
| `items`                | List of selectable items        | `List<DropDownMenuItemData<T>>` | **Required**     |
| `onSelectionChanged`   | Callback when selection changes | `Function(List<T>)?`            | `null`           |
| `placeholder`          | Placeholder text                | `String?`                       | `'Select Items'` |
| `selectAllText`        | "Select All" option text        | `String?`                       | `'Select All'`   |
| `prefix`               | Widget before selected items    | `Widget?`                       | `null`           |
| `suffix`               | Widget after selected items     | `Widget?`                       | `null`           |
| `initialValue`         | Initially selected values       | `List<T>?`                      | `null`           |
| `controller`           | Programmatic control            | `MultiDropdownController<T>?`   | `null`           |
| `showSelectedItemName` | Show names vs count             | `bool`                          | `true`           |

### Decoration Properties

```dart
decoration: DropdownDecoration(
  borderRadius: 10,
  borderColor: Colors.blue,
  checkboxActiveColor: Colors.blueAccent,
  // See all options below
)
```

| Property                | Description             | Type         | Default                                              |
| ----------------------- | ----------------------- | ------------ | ---------------------------------------------------- |
| `borderRadius`          | Border radius           | `double`     | `6.0`                                                |
| `borderColor`           | Border color            | `Color`      | `Colors.grey`                                        |
| `backgroundColor`       | Background color        | `Color`      | `Colors.white`                                       |
| `contentPadding`        | Internal padding        | `EdgeInsets` | `EdgeInsets.symmetric(horizontal: 16, vertical: 12)` |
| `elevation`             | Dropdown elevation      | `double`     | `4.0`                                                |
| `maxHeight`             | Max dropdown height     | `double`     | `260`                                                |
| `checkboxActiveColor`   | Active checkbox color   | `Color?`     | Theme primary                                        |
| `checkboxInActiveColor` | Inactive checkbox color | `Color?`     | `Colors.black`                                       |
| `dropdownIconColor`     | Dropdown icon color     | `Color?`     | `Colors.grey`                                        |

## 🎛️ Controller Methods

```dart
// Get current selections
List<int> selected = controller.selectedIds;

// Update selections programmatically
controller.updateSelection([1, 2, 3]);

// Clear all selections
controller.clearSelection();
```

## 🎨 Complete Example

```dart
FlutterMultiDropdown<String>(
  items: const [
    DropDownMenuItemData(name: 'Apple', id: 'fruit_apple'),
    DropDownMenuItemData(name: 'Banana', id: 'fruit_banana'),
    DropDownMenuItemData(name: 'Orange', id: 'fruit_orange'),
  ],
  decoration: DropdownDecoration(
    borderRadius: 12,
    borderColor: Colors.blue.shade300,
    checkboxActiveColor: Colors.blue,
    maxHeight: 300,
    itemTextStyle: const TextStyle(fontWeight: FontWeight.w500),
  ),
  prefix: const Icon(Icons.person),
  selectAllText: 'Select All Fruits',
  onSelectionChanged: (selected) {
    debugPrint('Selected fruits: $selected');
  },
)
```

## ✨ Features

- **Multi-Selection Support** - Intuitive interface for selecting multiple items
- **Select All Option** - Built-in "Select All" functionality with customizable text
- **Visual Feedback** - Clear checkbox indicators for selection state
- **Type Safety** - Generic implementation works with any data type
- **Programmatic Control** - Full control via `MultiDropdownController`
- **Customizable UI** - Extensive decoration options for complete visual control

## 📸 Screenshots

<div align="center">
  <img src="https://github.com/NamanGajera/flutter_multi_dropdown/blob/main/Images/select_all.jpg" width="200" alt="Select All">
  <img src="https://github.com/NamanGajera/flutter_multi_dropdown/blob/main/Images/show_selected_item_count.jpg" width="200" alt="Item Count">
  <img src="https://github.com/NamanGajera/flutter_multi_dropdown/blob/main/Images/simple_use_dropdown.jpg" width="200" alt="Simple Usage">
  <img src="https://github.com/NamanGajera/flutter_multi_dropdown/blob/main/Images/change_decoration.jpg" width="200" height = "200" alt="Custom Decoration">
</div>

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
