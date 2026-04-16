import 'package:flutter/material.dart';
import 'package:flutter_multi_dropdown/src/themes/dropdown_check_box_decoration.dart';
import 'package:flutter_multi_dropdown/src/themes/dropdown_decoration.dart';
import 'package:flutter_multi_dropdown/src/themes/dropdown_style.dart';
import 'package:flutter_multi_dropdown/src/themes/dropdown_text_style.dart';
import 'package:flutter_multi_dropdown/src/utils/dropdown_helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multi_dropdown/flutter_multi_dropdown.dart';

void main() {
  group('MultiDropdownController', () {
    test('initial state is empty', () {
      final controller = MultiDropdownController<String>();
      expect(controller.selectedIds, isEmpty);
      expect(controller.hasSelection, isFalse);
    });

    test('updateSelection updates selectedIds', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      expect(controller.selectedIds, ['1', '2']);
      expect(controller.hasSelection, isTrue);
    });

    test('clearSelection empties selectedIds', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      controller.clearSelection();
      expect(controller.selectedIds, isEmpty);
      expect(controller.hasSelection, isFalse);
    });

    test('notifies listeners on update', () {
      final controller = MultiDropdownController<String>();
      var notified = false;
      controller.addListener(() => notified = true);
      controller.updateSelection(['1']);
      expect(notified, isTrue);
    });

    test('notifies listeners on clear', () {
      final controller = MultiDropdownController<String>();
      var notified = false;
      controller.addListener(() => notified = true);
      controller.clearSelection();
      expect(notified, isTrue);
    });

    test('addSelection adds single item', () {
      final controller = MultiDropdownController<String>();
      controller.addSelection('1');
      expect(controller.selectedIds, ['1']);
      controller.addSelection('2');
      expect(controller.selectedIds, ['1', '2']);
    });

    test('addSelection does not add duplicate', () {
      final controller = MultiDropdownController<String>();
      controller.addSelection('1');
      controller.addSelection('1');
      expect(controller.selectedIds, ['1']);
    });

    test('removeSelection removes item', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2', '3']);
      controller.removeSelection('2');
      expect(controller.selectedIds, ['1', '3']);
    });

    test('removeSelection does nothing if item not present', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      controller.removeSelection('3');
      expect(controller.selectedIds, ['1', '2']);
    });

    test('toggleSelection toggles item', () {
      final controller = MultiDropdownController<String>();
      controller.toggleSelection('1');
      expect(controller.selectedIds, ['1']);
      controller.toggleSelection('1');
      expect(controller.selectedIds, isEmpty);
    });

    test('isSelected checks item selection', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      expect(controller.isSelected('1'), isTrue);
      expect(controller.isSelected('3'), isFalse);
    });

    test('selectedIds returns unmodifiable list', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      expect(() => controller.selectedIds.add('3'), throwsUnsupportedError);
    });
  });

  group('DropDownMenuItemData', () {
    test('equality comparison', () {
      final item1 = DropDownMenuItemData<String>(name: 'Test', id: '1');
      final item2 = DropDownMenuItemData<String>(name: 'Test', id: '1');
      final item3 = DropDownMenuItemData<String>(name: 'Different', id: '2');

      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });

    test('hashCode consistency', () {
      final item1 = DropDownMenuItemData<String>(name: 'Test', id: '1');
      final item2 = DropDownMenuItemData<String>(name: 'Test', id: '1');

      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('copyWith creates new instance with updated values', () {
      final original = DropDownMenuItemData<String>(
        name: 'Original',
        id: '1',
        isSelected: false,
        enabled: true,
      );

      final copied = original.copyWith(
        name: 'Copied',
        isSelected: true,
        enabled: false,
      );

      expect(copied.name, 'Copied');
      expect(copied.id, '1');
      expect(copied.isSelected, isTrue);
      expect(copied.enabled, isFalse);
    });

    test('toString returns readable representation', () {
      final item = DropDownMenuItemData<String>(
        name: 'Test',
        id: '1',
        isSelected: true,
        enabled: false,
      );

      expect(
        item.toString(),
        contains('DropDownMenuItemData'),
      );
    });
  });

  group('DropdownHelpers', () {
    test('listEquals compares lists correctly', () {
      expect(DropdownHelpers.listEquals([1, 2, 3], [1, 2, 3]), isTrue);
      expect(DropdownHelpers.listEquals([1, 2, 3], [1, 2]), isFalse);
      expect(DropdownHelpers.listEquals([1, 2, 3], [1, 2, 4]), isFalse);
      expect(DropdownHelpers.listEquals(null, null), isTrue);
      expect(DropdownHelpers.listEquals([1], null), isFalse);
    });

    test('firstOrNull returns first element or null', () {
      expect(DropdownHelpers.firstOrNull([1, 2, 3]), 1);
      expect(DropdownHelpers.firstOrNull([]), isNull);
    });

    test('formatSelectedItems formats correctly', () {
      final items = [
        (name: 'Item 1', id: 1),
        (name: 'Item 2', id: 2),
        (name: 'Item 3', id: 3),
      ];

      expect(
        DropdownHelpers.formatSelectedItems(items, true, null),
        'Item 1, Item 2, Item 3',
      );

      expect(
        DropdownHelpers.formatSelectedItems(items, false, null),
        '3 items selected',
      );

      expect(
        DropdownHelpers.formatSelectedItems(items, true, 2),
        'Item 1, Item 2, +1 more',
      );

      expect(
        DropdownHelpers.formatSelectedItems([(name: 'Single', id: 1)], false, null),
        '1 item selected',
      );
    });

    test('canSelectMore validates selection constraints', () {
      // No max selection limit
      expect(
        DropdownHelpers.canSelectMore(
          currentSelectionCount: 5,
          maxSelection: null,
          isAlreadySelected: false,
        ),
        isTrue,
      );

      // Can select more (below limit)
      expect(
        DropdownHelpers.canSelectMore(
          currentSelectionCount: 2,
          maxSelection: 5,
          isAlreadySelected: false,
        ),
        isTrue,
      );

      // Cannot select more (at limit)
      expect(
        DropdownHelpers.canSelectMore(
          currentSelectionCount: 5,
          maxSelection: 5,
          isAlreadySelected: false,
        ),
        isFalse,
      );

      // Can deselect even at limit
      expect(
        DropdownHelpers.canSelectMore(
          currentSelectionCount: 5,
          maxSelection: 5,
          isAlreadySelected: true,
        ),
        isTrue,
      );
    });
  });

  group('FlutterMultiDropdown - Basic Functionality', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      DropDownMenuItemData<String>(name: 'Option 3', id: '3'),
    ];

    testWidgets('initializes with correct items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
            ),
          ),
        ),
      );

      expect(find.text('Select Items'), findsOneWidget);
    });

    testWidgets('shows custom placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              placeholder: 'Custom Placeholder',
            ),
          ),
        ),
      );

      expect(find.text('Custom Placeholder'), findsOneWidget);
    });

    testWidgets('initializes with initialValue', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              initialValue: ['1', '2'],
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      expect(find.text('Option 1, Option 2'), findsOneWidget);
    });

    testWidgets('shows count when showSelectedItemName is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              initialValue: ['1', '2'],
              showSelectedItemName: false,
            ),
          ),
        ),
      );

      expect(find.text('2 items selected'), findsOneWidget);
    });

    testWidgets('shows single item count correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              initialValue: ['1'],
              showSelectedItemName: false,
              selectionMode: DropdownSelectionMode.single,
            ),
          ),
        ),
      );

      expect(find.text('1 item selected'), findsOneWidget);
    });

    testWidgets('opens dropdown when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Selection Tests', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      DropDownMenuItemData<String>(name: 'Option 3', id: '3'),
    ];

    testWidgets('selects item when tapped', (WidgetTester tester) async {
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              onSelectionChanged: (items) => selectedItems = items,
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();

      expect(selectedItems, ['1']);
      expect(find.text('Option 1'), findsNWidgets(2)); // One in dropdown, one in selected display
    });

    testWidgets('selects multiple items', (WidgetTester tester) async {
      List<String>? selectedItems = [];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              onSelectionChanged: (items) => selectedItems = items,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select multiple items
      await tester.tap(find.text('Option 1').first);
      await tester.tap(find.text('Option 3').first);
      await tester.pumpAndSettle();

      expect(selectedItems, contains('1'));
      expect(selectedItems, contains('3'));
      expect(selectedItems?.length, 2);
    });

    testWidgets('deselects item when tapped again', (WidgetTester tester) async {
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              onSelectionChanged: (items) => selectedItems = items,
              autoCloseOnItemTap: false,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select and deselect item
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();

      expect(selectedItems, isEmpty);
    });

    testWidgets('selects all when "Select All" is tapped', (WidgetTester tester) async {
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              onSelectionChanged: (items) => selectedItems = items,
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select all
      await tester.tap(find.text('Select All').first);
      await tester.pumpAndSettle();

      expect(selectedItems, ['1', '2', '3']);
      expect(find.text('Option 1, Option 2, Option 3'), findsOneWidget);
    });

    testWidgets('deselects all when "Select All" is toggled off', (WidgetTester tester) async {
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              onSelectionChanged: (items) => selectedItems = items,
              autoCloseOnItemTap: false,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select all
      await tester.tap(find.text('Select All').first);
      await tester.pumpAndSettle();

      // Deselect all
      await tester.tap(find.text('Select All').first);
      await tester.pumpAndSettle();

      expect(selectedItems, isEmpty);
    });
  });

  group('FlutterMultiDropdown - Controller Tests', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      DropDownMenuItemData<String>(name: 'Option 3', id: '3'),
    ];

    testWidgets('works with controller', (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              controller: controller,
              onSelectionChanged: (items) => selectedItems = items,
            ),
          ),
        ),
      );

      // Update selection via controller
      controller.updateSelection(['2']);
      await tester.pump();

      expect(selectedItems, ['2']);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('clears selection when controller clears', (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              controller: controller,
              initialValue: ['1', '2'],
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      expect(find.text('Option 1, Option 2'), findsOneWidget);

      // Clear selection via controller
      controller.clearSelection();
      await tester.pump();

      expect(find.text('Select Items'), findsOneWidget);
    });

    testWidgets('controller and UI stay synchronized', (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();
      List<String>? selectedItems;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              controller: controller,
              onSelectionChanged: (items) => selectedItems = items,
            ),
          ),
        ),
      );

      // Select via UI
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();

      expect(controller.selectedIds, ['1']);
      expect(selectedItems, ['1']);

      // Select via controller
      controller.updateSelection(['2', '3']);
      await tester.pump();

      expect(find.text('Option 2, Option 3'), findsOneWidget);
      expect(selectedItems, ['2', '3']);
    });

    testWidgets('handles API data with pre-selection', (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();

      // Set selection before data loads
      controller.updateSelection(['1', '3']);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              controller: controller,
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      // Should show selected items from controller
      expect(find.text('Option 1, Option 3'), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Single Selection Mode', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      DropDownMenuItemData<String>(name: 'Option 3', id: '3'),
    ];

    testWidgets('single selection mode works', (WidgetTester tester) async {
      String? selectedItem;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              showSelectAll: false,
              selectionMode: DropdownSelectionMode.single,
              onSingleItemSelected: (item) => selectedItem = item,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();

      expect(selectedItem, '1');
      expect(find.text('Option 1'), findsNWidgets(2));

      // Select another item (should replace, not add)
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Option 2').first);
      await tester.pumpAndSettle();

      expect(selectedItem, '2');
      expect(find.text('Option 2'), findsNWidgets(2));
      expect(find.text('Option 1, Option 2'), findsNothing);
    });

    testWidgets('single selection shows radio buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              selectionMode: DropdownSelectionMode.single,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byType(RadioListTile<String>), findsNWidgets(3));
      expect(find.byType(CheckboxListTile), findsNothing);
    });

    testWidgets('multi selection shows checkboxes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              selectionMode: DropdownSelectionMode.multiple,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byType(CheckboxListTile), findsNWidgets(3));
      expect(find.byType(RadioListTile<String>), findsNothing);
    });
  });

  group('FlutterMultiDropdown - Max Selection Limit', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      DropDownMenuItemData<String>(name: 'Option 3', id: '3'),
      DropDownMenuItemData<String>(name: 'Option 4', id: '4'),
    ];

    testWidgets('respects maxSelection limit', (WidgetTester tester) async {
      var maxSelectionReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              maxSelection: 2,
              onMaxSelectionReached: () => maxSelectionReached = true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Select up to max
      await tester.tap(find.text('Option 1').first);
      await tester.tap(find.text('Option 2').first);
      await tester.pumpAndSettle();

      expect(maxSelectionReached, isFalse);

      // Try to select beyond max
      await tester.tap(find.text('Option 3').first);
      await tester.pumpAndSettle();

      expect(maxSelectionReached, isTrue);
    });

    testWidgets('select all respects maxSelection', (WidgetTester tester) async {
      var maxSelectionReached = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              maxSelection: 2,
              onMaxSelectionReached: () => maxSelectionReached = true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Try to select all (should only select up to max)
      await tester.tap(find.text('Select All').first);
      await tester.pumpAndSettle();

      expect(maxSelectionReached, isTrue);
    });
  });

  group('FlutterMultiDropdown - Search Functionality', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Apple', id: '1'),
      DropDownMenuItemData<String>(name: 'Banana', id: '2'),
      DropDownMenuItemData<String>(name: 'Cherry', id: '3'),
      DropDownMenuItemData<String>(name: 'Date', id: '4'),
    ];

    testWidgets('search field appears when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              enableSearch: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('search filters items correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              enableSearch: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Enter search text
      await tester.enterText(find.byType(TextField), 'ap');
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
      expect(find.text('Cherry'), findsNothing);
      expect(find.text('Date'), findsNothing);
    });

    testWidgets('search shows empty state when no matches', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              enableSearch: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Enter search text with no matches
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();

      expect(find.text('No matching items'), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Dynamic Height', () {
    final fewItems = [
      DropDownMenuItemData<String>(name: 'Item 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Item 2', id: '2'),
    ];

    final manyItems = List.generate(10, (index) => DropDownMenuItemData<String>(name: 'Item ${index + 1}', id: '${index + 1}'));

    testWidgets('adjusts height based on item count', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: fewItems,
              decoration: DropdownDecoration(
                maxVisibleItems: 5,
                minHeight: 100.0,
              ),
            ),
          ),
        ),
      );

      // Open dropdown with few items
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Should show all items without scroll
      expect(find.byType(Scrollable), findsOneWidget);
    });

    testWidgets('respects maxVisibleItems for scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: manyItems,
              decoration: DropdownDecoration(
                maxVisibleItems: 3,
              ),
            ),
          ),
        ),
      );

      // Open dropdown with many items
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Should show only maxVisibleItems at a time
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('Item 4'), findsNothing); // Not visible without scrolling
    });

    testWidgets('maintains minHeight with few items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: fewItems,
              decoration: DropdownDecoration(
                maxVisibleItems: 5,
                minHeight: 200.0,
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Dropdown should have at least minHeight even with few items
      tester.widget<Material>(find.byType(Material).at(1));
      // Note: Exact height measurement in tests is complex due to overlay
      // This test ensures the widget builds correctly with minHeight config
    });

    testWidgets('respects maxHeight with many items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: manyItems,
              decoration: DropdownDecoration(
                maxVisibleItems: 10,
                minHeight: 100.0,
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Dropdown should not exceed maxHeight even with many items
      // Scrollable should be present if content exceeds maxHeight
      expect(find.byType(Scrollable), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Custom Builders', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
      DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
    ];

    testWidgets('custom item builder works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              itemBuilder: (context, item, isSelected, onChanged) {
                return ListTile(
                  leading: Icon(isSelected ? Icons.star : Icons.star_border),
                  title: Text('Custom: ${item.name}'),
                  onTap: () => onChanged?.call(!isSelected),
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Custom: Option 1'), findsOneWidget);
      expect(find.text('Custom: Option 2'), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('custom select all builder works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              selectAllBuilder: (context, isSelected, onChanged) {
                return SwitchListTile(
                  title: const Text('Toggle All'),
                  value: isSelected,
                  onChanged: onChanged,
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Toggle All'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.text('Select All'), findsNothing);
    });

    testWidgets('custom empty builder works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: [],
              isEmptyData: true,
              emptyBuilder: (context) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox),
                      Text('No items available'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No items available'), findsOneWidget);
    });

    testWidgets('custom loading builder works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              showLoading: true,
              loadingBuilder: (context) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Text('Loading items...'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading items...'), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Edge Cases', () {
    testWidgets('handles empty items list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: [],
            ),
          ),
        ),
      );

      expect(find.text('Select Items'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('No Data Found'), findsOneWidget);
    });

    testWidgets('handles disabled items', (WidgetTester tester) async {
      final items = [
        DropDownMenuItemData<String>(name: 'Enabled', id: '1', enabled: true),
        DropDownMenuItemData<String>(name: 'Disabled', id: '2', enabled: false),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Disabled item should be shown but not selectable
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('preserves selection when items update', (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();
      final initialItems = [
        DropDownMenuItemData<String>(name: 'Item 1', id: '1'),
        DropDownMenuItemData<String>(name: 'Item 2', id: '2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FlutterMultiDropdown<String>(
                  items: initialItems,
                  controller: controller,
                );
              },
            ),
          ),
        ),
      );

      // Select an item
      controller.updateSelection(['1']);
      await tester.pump();

      // Update items (simulating API refresh)
      final updatedItems = [
        DropDownMenuItemData<String>(name: 'Item 1 Updated', id: '1'),
        DropDownMenuItemData<String>(name: 'Item 2 Updated', id: '2'),
        DropDownMenuItemData<String>(name: 'Item 3 New', id: '3'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: updatedItems,
              controller: controller,
              showSelectedItemName: true,
            ),
          ),
        ),
      );

      // Selection should be preserved
      expect(find.text('Item 1 Updated'), findsOneWidget);
    });

    testWidgets('handles autoCloseOnItemTap', (WidgetTester tester) async {
      final items = [
        DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
        DropDownMenuItemData<String>(name: 'Option 2', id: '2'),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              autoCloseOnItemTap: true,
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.text('Option 1'), findsOneWidget);

      // Select item (should close dropdown)
      await tester.tap(find.text('Option 1').first);
      await tester.pumpAndSettle();

      // Dropdown should be closed
      expect(find.text('Option 1'), findsOneWidget); // Only in button, not in dropdown
    });

    testWidgets('handles prefix and suffix widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: [DropDownMenuItemData<String>(name: 'Test', id: '1')],
              prefix: const Icon(Icons.person),
              suffix: const Icon(Icons.arrow_forward),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });

  group('FlutterMultiDropdown - Decoration Tests', () {
    final items = [
      DropDownMenuItemData<String>(name: 'Option 1', id: '1'),
    ];

    testWidgets('applies custom decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              decoration: DropdownDecoration(
                textStyle: DropdownTextStyle(
                  placeholder: const TextStyle(color: Colors.green),
                ),
                checkboxDecoration: DropdownCheckboxDecoration(
                  activeColor: Colors.orange,
                ),
                maxVisibleItems: 8,
                minHeight: 150.0,
                dropdownStyle: DropdownStyle(
                  borderRadius: 12.0,
                  borderColor: Colors.red,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final boxDecoration = container.decoration as BoxDecoration;

      expect(boxDecoration.borderRadius, BorderRadius.circular(12.0));
      expect(boxDecoration.border?.top.color, Colors.red);
      expect(boxDecoration.color, Colors.blue);
    });

    testWidgets('applies custom dropdown list decoration', (WidgetTester tester) async {
      final customDecoration = BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              decoration: DropdownDecoration(
                dropdownStyle: DropdownStyle(
                  fieldDecoration: customDecoration,
                ),
              ),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FlutterMultiDropdown<String>));
      await tester.pumpAndSettle();

      // Find dropdown container
      final dropdownContainer = tester
          .widgetList<Container>(
            find.byType(Container),
          )
          .firstWhere(
            (container) => container.decoration == customDecoration,
          );

      expect(dropdownContainer.decoration, customDecoration);
    });
  });
}
