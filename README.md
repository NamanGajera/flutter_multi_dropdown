# Flutter Multi Dropdown 🚀

[![Pub Version](https://img.shields.io/pub/v/flutter_multi_dropdown)](https://pub.dev/packages/flutter_multi_dropdown)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A highly customizable multi-select dropdown widget for Flutter with select-all functionality, type safety, and comprehensive decoration options.

## ✨ Features

- **Multi-Selection Support** - Intuitive interface for selecting multiple items
- **Search Functionality** - Built-in search to quickly find items in large lists
- **Select All Option** - Built-in "Select All" functionality with customizable text
- **Visual Feedback** - Clear checkbox indicators for selection state
- **Type Safety** - Generic implementation works with any data type
- **Programmatic Control** - Full control via `MultiDropdownController`
- **Customizable UI** - Extensive decoration options for complete visual control

## 📸 Screenshots & Demo

<div align="center">
<img src="https://raw.githubusercontent.com/NamanGajera/flutter_multi_dropdown/main/Images/example_video.gif" width="200" alt="Example">
<img src="https://raw.githubusercontent.com/NamanGajera/flutter_multi_dropdown/main/Images/Screenshot_1.jpg" width="200" alt="Screenshot_1">
  <img src="https://raw.githubusercontent.com/NamanGajera/flutter_multi_dropdown/main/Images/Screenshot_2.jpg" width="200" alt="Simple Usage">
<img src="https://raw.githubusercontent.com/NamanGajera/flutter_multi_dropdown/main/Images/change_decoration.jpg" width="200" height="200" alt="Custom Decoration">
</div>

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_multi_dropdown: latest
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

| Property               | Description                       | Type                             | Default          |
| ---------------------- | --------------------------------- | -------------------------------- | ---------------- |
| `items`                | List of selectable items          | `List<DropDownMenuItemData<T>>`  | **Required**     |
| `onSelectionChanged`   | Callback when selection changes   | `Function(List<T>)?`             | `null`           |
| `placeholder`          | Placeholder text                  | `String?`                        | `'Select Items'` |
| `selectAllText`        | "Select All" option text          | `String?`                        | `'Select All'`   |
| `prefix`               | Widget before selected items      | `Widget?`                        | `null`           |
| `suffix`               | Widget after selected items       | `Widget?`                        | `null`           |
| `initialValue`         | Initially selected values         | `List<T>?`                       | `null`           |
| `controller`           | Programmatic control              | `MultiDropdownController<T>?`    | `null`           |
| `showSelectedItemName` | Show names vs count               | `bool`                           | `true`           |
| `showSelectAll`        | Show select all option            | `bool`                           | `true`           |
| `enableSearch`         | Enable search functionality       | `bool?`                          | `false`          |
| `isEmptyData`          | Show names vs count               | `bool`                           | `fase`           |
| `showLoading`          | Show loading indicator            | `bool`                           | `false`          |
| `loadingBuilder`       | Custom loading widget builder     | `Widget Function(BuildContext)?` | `null`           |
| `emptyBuilder`         | Custom empty state widget builder | `Widget Function(BuildContext)?` | `null`           |
| `autoCloseOnItemTap`         | control dropdown close behavior after item selection | `bool` | `false`           |

### Decoration Properties

```dart
decoration: DropdownDecoration(
  borderRadius: 10,
  borderColor: Colors.blue,
  checkboxActiveColor: Colors.blueAccent,
  // See all options below
)
```

| Property                | Description             | Type                       | Default                                              |
| ----------------------- | ----------------------- | -------------------------- | ---------------------------------------------------- |
| `borderRadius`          | Border radius           | `double`                   | `6.0`                                                |
| `borderColor`           | Border color            | `Color`                    | `Colors.grey`                                        |
| `backgroundColor`       | Background color        | `Color`                    | `Colors.white`                                       |
| `contentPadding`        | Internal padding        | `EdgeInsets`               | `EdgeInsets.symmetric(horizontal: 16, vertical: 12)` |
| `elevation`             | Dropdown elevation      | `double`                   | `4.0`                                                |
| `maxHeight`             | Max dropdown height     | `double`                   | `260`                                                |
| `checkboxActiveColor`   | Active checkbox color   | `Color?`                   | Theme primary                                        |
| `checkboxInActiveColor` | Inactive checkbox color | `Color?`                   | `Colors.black`                                       |
| `dropdownIconColor`     | Dropdown icon color     | `Color?`                   | `Colors.grey`                                        |
| `searchDecoration`      | Search filed decoration | `DropdownSearchDecoration` | `null`                                               |

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
  enableSearch: true,
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


## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
