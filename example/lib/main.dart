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
  // Different item lists for each example
  final List<DropDownMenuItemData> fruitsItems = [
    DropDownMenuItemData(name: "Apple", id: 1),
    DropDownMenuItemData(name: "Banana", id: 2),
    DropDownMenuItemData(name: "Orange", id: 3),
    DropDownMenuItemData(name: "Mango", id: 4, isSelected: true),
    DropDownMenuItemData(name: "Grapes", id: 5, enabled: false),
  ];

  final List<DropDownMenuItemData> techItems = [
    DropDownMenuItemData(name: "Flutter", id: 1, isSelected: true),
    DropDownMenuItemData(name: "React Native", id: 2),
    DropDownMenuItemData(name: "Swift", id: 3),
    DropDownMenuItemData(name: "Kotlin", id: 4),
    DropDownMenuItemData(name: "Xamarin", id: 5, enabled: false),
    DropDownMenuItemData(name: "Ionic", id: 6),
    DropDownMenuItemData(name: "PhoneGap", id: 7),
  ];

  final List<DropDownMenuItemData> colorItems = [
    DropDownMenuItemData(name: "Red", id: 1, enabled: false),
    DropDownMenuItemData(name: "Blue", id: 2, isSelected: true),
    DropDownMenuItemData(name: "Green", id: 3),
    DropDownMenuItemData(name: "Yellow", id: 4),
    DropDownMenuItemData(name: "Purple", id: 5),
    DropDownMenuItemData(name: "Orange", id: 6),
  ];

  final List<DropDownMenuItemData> categoryItems = [
    DropDownMenuItemData(name: "Electronics", id: 1),
    DropDownMenuItemData(name: "Clothing", id: 2),
    DropDownMenuItemData(name: "Books", id: 3, isSelected: true),
    DropDownMenuItemData(name: "Home & Garden", id: 4),
    DropDownMenuItemData(name: "Sports", id: 5),
  ];

  final List<DropDownMenuItemData> skillItems = [
    DropDownMenuItemData(name: "Problem Solving", id: 1, isSelected: true),
    DropDownMenuItemData(name: "Communication", id: 2),
    DropDownMenuItemData(name: "Leadership", id: 3),
    DropDownMenuItemData(name: "Time Management", id: 4, enabled: false),
    DropDownMenuItemData(name: "Creativity", id: 5),
    DropDownMenuItemData(name: "Teamwork", id: 6, isSelected: true),
  ];

  // Different controllers for each example
  final MultiDropdownController fruitsController = MultiDropdownController();
  final MultiDropdownController techController = MultiDropdownController();
  final MultiDropdownController colorController = MultiDropdownController();
  final MultiDropdownController categoryController = MultiDropdownController();
  final MultiDropdownController skillController = MultiDropdownController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Multi Dropdown Showcase',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Example 1: Basic Fruits Selection
            _buildExampleCard(
              title: "Select Your Favorite Fruits",
              subtitle: "Basic selection with custom styling",
              child: FlutterMultiDropdown(
                items: fruitsItems,
                controller: fruitsController,
                itemBuilder: (context, item, isSelected, onChanged) {
                  return InkWell(
                    onTap: () => onChanged!(!isSelected),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isSelected ? Colors.green : Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                color:
                                    item.enabled ? Colors.black87 : Colors.grey,
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (!item.enabled)
                            Icon(Icons.lock_outline,
                                size: 16, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                  );
                },
                selectAllBuilder: (context, selectAll, onChanged) {
                  return InkWell(
                    onTap: () => onChanged!(!selectAll),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            selectAll
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: selectAll ? Colors.green : Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Select All",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onSelectionChanged: (selectedIds) {
                  debugPrint("Selected Fruits: $selectedIds");
                },
                decoration: DropdownDecoration(
                  backgroundColor: Colors.white,
                  borderRadius: 12,
                  borderColor: Colors.grey[300]!,
                  maxHeight: 250,
                ),
                placeholder: 'Choose fruits...',
              ),
            ),

            const SizedBox(height: 24),

            // Example 2: Tech Stack with Search
            _buildExampleCard(
              title: "Choose Your Tech Stack",
              subtitle: "With search functionality and select all",
              child: FlutterMultiDropdown(
                items: techItems,
                controller: techController,
                onSelectionChanged: (selectedIds) {
                  debugPrint("Selected Technologies: $selectedIds");
                },
                enableSearch: true,
                showSelectAll: true,
                decoration: DropdownDecoration(
                  backgroundColor: Colors.white,
                  borderRadius: 12,
                  borderColor: Colors.blue[200]!,
                  searchDecoration: DropdownSearchDecoration(
                    backgroundColor: Colors.blue[50],
                    borderColor: Colors.blue[200]!,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  maxHeight: 300,
                ),
                placeholder: 'Search technologies...',
              ),
            ),

            const SizedBox(height: 24),

            // Example 3: Color Selection (Compact)
            _buildExampleCard(
              title: "Pick Colors",
              subtitle: "Compact view showing only count",
              child: FlutterMultiDropdown(
                items: colorItems,
                controller: colorController,
                onSelectionChanged: (selectedIds) {
                  debugPrint("Selected Colors: $selectedIds");
                },
                showSelectedItemName: false,
                enableSearch: true,
                decoration: DropdownDecoration(
                  backgroundColor: Colors.white,
                  borderRadius: 12,
                  borderColor: Colors.green[300]!,
                  searchDecoration: DropdownSearchDecoration(
                    backgroundColor: Colors.green[50],
                    borderColor: Colors.green[200]!,
                  ),
                  maxHeight: 250,
                ),
                placeholder: 'Select colors...',
              ),
            ),

            const SizedBox(height: 24),

            // Example 4: Dark Theme Categories
            _buildExampleCard(
              title: "Product Categories",
              subtitle: "Dark theme styling",
              child: FlutterMultiDropdown(
                items: categoryItems,
                controller: categoryController,
                onSelectionChanged: (selectedIds) {
                  debugPrint("Selected Categories: $selectedIds");
                },
                placeholder: 'Browse categories...',
                decoration: DropdownDecoration(
                  backgroundColor: Colors.grey[800]!,
                  borderRadius: 12,
                  borderColor: Colors.grey[600]!,
                  openDropdownIconColor: Colors.white,
                  closeDropdownIconColor: Colors.white,
                  placeholderTextStyle: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                  selectedItemTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  itemTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  checkboxActiveColor: Colors.blue[400]!,
                  checkboxInActiveColor: Colors.grey[400]!,
                  checkColor: Colors.white,
                  maxHeight: 250,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example 5: Skills with Controls
            _buildExampleCard(
              title: "Your Skills",
              subtitle: "With programmatic controls",
              child: Column(
                children: [
                  FlutterMultiDropdown(
                    items: skillItems,
                    controller: skillController,
                    onSelectionChanged: (selectedIds) {
                      debugPrint("Selected Skills: $selectedIds");
                    },
                    decoration: DropdownDecoration(
                      backgroundColor: Colors.white,
                      borderRadius: 12,
                      borderColor: Colors.purple[300]!,
                      maxHeight: 250,
                    ),
                    placeholder: 'Select your skills...',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            skillController.updateSelection([1, 2, 6]);
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Select Core'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100],
                            foregroundColor: Colors.purple[700],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            skillController.clearSelection();
                          },
                          icon: const Icon(Icons.clear, size: 18),
                          label: const Text('Clear All'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red[600],
                            side: BorderSide(color: Colors.red[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}
