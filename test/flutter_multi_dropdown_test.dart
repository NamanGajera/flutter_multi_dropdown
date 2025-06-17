import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multi_dropdown/flutter_multi_dropdown.dart';

void main() {
  group('MultiDropdownController', () {
    test('initial state is empty', () {
      final controller = MultiDropdownController<String>();
      expect(controller.selectedIds, isEmpty);
    });

    test('updateSelection updates selectedIds', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      expect(controller.selectedIds, ['1', '2']);
    });

    test('clearSelection empties selectedIds', () {
      final controller = MultiDropdownController<String>();
      controller.updateSelection(['1', '2']);
      controller.clearSelection();
      expect(controller.selectedIds, isEmpty);
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
  });

  group('FlutterMultiDropdown', () {
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

    testWidgets('shows placeholder when no items selected',
        (WidgetTester tester) async {
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

    testWidgets('shows count when showSelectedItemName is false',
        (WidgetTester tester) async {
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
      expect(find.text('Option 1'),
          findsNWidgets(2)); // One in dropdown, one in selected display
    });

    testWidgets('selects all when "Select All" is tapped',
        (WidgetTester tester) async {
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

    testWidgets('clears selection when controller clears',
        (WidgetTester tester) async {
      final controller = MultiDropdownController<String>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              controller: controller,
              initialValue: ['1', '2'],
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

    testWidgets('shows prefix and suffix widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              prefix: const Icon(Icons.person),
              suffix: const Icon(Icons.arrow_forward),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('applies custom decoration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMultiDropdown<String>(
              items: items,
              decoration: DropdownDecoration(
                borderRadius: 12.0,
                borderColor: Colors.red,
                backgroundColor: Colors.blue,
                placeholderTextStyle: const TextStyle(color: Colors.green),
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
  });
}
