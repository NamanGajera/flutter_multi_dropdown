import 'package:flutter/material.dart';
import 'package:flutter_multi_dropdown/flutter_multi_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Dropdown Showcase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const DropDownExample(),
    );
  }
}

class DropDownExample extends StatefulWidget {
  const DropDownExample({super.key});

  @override
  State<DropDownExample> createState() => _DropDownExampleState();
}

class _DropDownExampleState extends State<DropDownExample> {
  @override
  Widget build(BuildContext context) {
    List<DropDownMenuItemData> itemList = [
      DropDownMenuItemData(name: "Item1", id: 1),
      DropDownMenuItemData(name: "Item2", id: 2),
      DropDownMenuItemData(name: "Item3", id: 3),
      DropDownMenuItemData(name: "Item4", id: 4),
      DropDownMenuItemData(name: "Item5", id: 5),
    ];

    final MultiDropdownController dropdownController =
        MultiDropdownController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Dropdown Showcase'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 80),
        child: Column(
          children: [
            FlutterMultiDropdown(
              items: itemList,
              controller: dropdownController,
              onSelectionChanged: (selectedIds) {
                debugPrint("Selected Ids => $selectedIds");
              },
              placeholder: 'Select item',
            ),
            SizedBox(height: 10),
            FlutterMultiDropdown(
              items: itemList,
              onSelectionChanged: (selectedIds) {
                debugPrint("Selected Ids => $selectedIds");
              },
              showSelectedItemName: false,
              placeholder: 'Select item',
              decoration: DropdownDecoration(
                borderRadius: 12,
                borderColor: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            FlutterMultiDropdown(
              items: itemList,
              onSelectionChanged: (selectedIds) {
                debugPrint("Selected Ids => $selectedIds");
              },
              placeholder: 'Select item',
              showSelectedItemName: false,
              decoration: DropdownDecoration(
                dropdownIconColor: Colors.white,
                borderRadius: 12,
                backgroundColor: Colors.green,
                placeholderTextStyle: TextStyle(
                  color: Colors.white,
                ),
                selectedItemTextStyle: TextStyle(
                  color: Colors.white,
                ),
                itemTextStyle: TextStyle(
                  color: Colors.white,
                ),
                checkboxInActiveColor: Colors.white,
                checkboxActiveColor: Colors.white,
                checkColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
