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
      title: 'FlutterMultiDropdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const DropdownShowcase(),
    );
  }
}

class DropdownShowcase extends StatefulWidget {
  const DropdownShowcase({super.key});

  @override
  State<DropdownShowcase> createState() => _DropdownShowcaseState();
}

class _DropdownShowcaseState extends State<DropdownShowcase> {
  // Example 1: Countries
  final List<DropDownMenuItemData> countries = [
    DropDownMenuItemData(name: "United States", id: 1, isSelected: true),
    DropDownMenuItemData(name: "United Kingdom", id: 2),
    DropDownMenuItemData(name: "Canada", id: 3),
    DropDownMenuItemData(name: "Australia", id: 4),
    DropDownMenuItemData(name: "Germany", id: 5),
    DropDownMenuItemData(name: "France", id: 6, enabled: false),
    DropDownMenuItemData(name: "Japan", id: 7),
    DropDownMenuItemData(name: "Brazil", id: 8),
  ];

  // Example 2: Programming Languages
  final List<DropDownMenuItemData> languages = [
    DropDownMenuItemData(name: "Dart", id: 1, isSelected: true),
    DropDownMenuItemData(name: "JavaScript", id: 2),
    DropDownMenuItemData(name: "Python", id: 3, isSelected: true),
    DropDownMenuItemData(name: "Java", id: 4),
    DropDownMenuItemData(name: "C++", id: 5),
    DropDownMenuItemData(name: "Go", id: 6),
    DropDownMenuItemData(name: "Rust", id: 7),
    DropDownMenuItemData(name: "TypeScript", id: 8),
    DropDownMenuItemData(name: "Swift", id: 9),
    DropDownMenuItemData(name: "Kotlin", id: 10),
  ];

  // Example 3: Priority Tags
  final List<DropDownMenuItemData> priorities = [
    DropDownMenuItemData(name: "Critical", id: 1, isSelected: true),
    DropDownMenuItemData(name: "High", id: 2),
    DropDownMenuItemData(name: "Medium", id: 3),
    DropDownMenuItemData(name: "Low", id: 4),
    DropDownMenuItemData(name: "Info", id: 5),
  ];

  // Example 4: Departments
  final List<DropDownMenuItemData> departments = [
    DropDownMenuItemData(name: "Engineering", id: 1, isSelected: true),
    DropDownMenuItemData(name: "Marketing", id: 2),
    DropDownMenuItemData(name: "Sales", id: 3, isSelected: true),
    DropDownMenuItemData(name: "Human Resources", id: 4),
    DropDownMenuItemData(name: "Finance", id: 5),
    DropDownMenuItemData(name: "Operations", id: 6),
    DropDownMenuItemData(name: "Customer Support", id: 7),
    DropDownMenuItemData(name: "Product Management", id: 8),
  ];

  // Example 5: Features
  final List<DropDownMenuItemData> features = [
    DropDownMenuItemData(name: "Fast Performance", id: 1, isSelected: true),
    DropDownMenuItemData(name: "Beautiful UI", id: 2, isSelected: true),
    DropDownMenuItemData(name: "Secure", id: 3),
    DropDownMenuItemData(name: "Responsive", id: 4),
    DropDownMenuItemData(name: "Accessible", id: 5, enabled: false),
    DropDownMenuItemData(name: "Multilingual", id: 6),
  ];

  // Example 6: Single Selection
  final List<DropDownMenuItemData> currencies = [
    DropDownMenuItemData(name: "US Dollar (USD)", id: 1, isSelected: true),
    DropDownMenuItemData(name: "Euro (EUR)", id: 2),
    DropDownMenuItemData(name: "British Pound (GBP)", id: 3, enabled: false),
    DropDownMenuItemData(name: "Japanese Yen (JPY)", id: 4),
    DropDownMenuItemData(name: "Swiss Franc (CHF)", id: 5),
    DropDownMenuItemData(name: "Canadian Dollar (CAD)", id: 6, enabled: false),
  ];

  // Example 7: Loading & Empty States
  final List<DropDownMenuItemData> dynamicItems = [];
  bool isLoading = true;
  bool isEmpty = false;

  // Example 8: Skills
  final List<DropDownMenuItemData> skills = [
    DropDownMenuItemData(name: "Flutter Development", id: 1),
    DropDownMenuItemData(name: "UI/UX Design", id: 2),
    DropDownMenuItemData(name: "Backend Development", id: 3),
    DropDownMenuItemData(name: "DevOps", id: 4, enabled: false),
    DropDownMenuItemData(name: "Database Management", id: 5),
    DropDownMenuItemData(name: "Cloud Architecture", id: 6),
    DropDownMenuItemData(name: "Mobile Testing", id: 7),
  ];

  // Controllers
  final MultiDropdownController countriesController = MultiDropdownController();
  final MultiDropdownController languagesController = MultiDropdownController();
  final MultiDropdownController prioritiesController = MultiDropdownController();
  final MultiDropdownController departmentsController = MultiDropdownController();
  final MultiDropdownController featuresController = MultiDropdownController();
  final MultiDropdownController currenciesController = MultiDropdownController();
  final MultiDropdownController dynamicController = MultiDropdownController();
  final MultiDropdownController skillsController = MultiDropdownController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        isEmpty = false;
      });
    });
  }

  String getCountryFlag(String country) {
    final flags = {
      "United States": "🇺🇸",
      "United Kingdom": "🇬🇧",
      "Canada": "🇨🇦",
      "Australia": "🇦🇺",
      "Germany": "🇩🇪",
      "France": "🇫🇷",
      "Japan": "🇯🇵",
      "Brazil": "🇧🇷",
    };
    return flags[country] ?? "🌍";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              toolbarHeight: 15,
              title: const Text(
                '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: false,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Example 1
                  _ExampleSection(
                    label: 'Custom Item Builder',
                    description: 'Fully customizable item appearance',
                    child: FlutterMultiDropdown(
                      items: countries,
                      controller: countriesController,
                      itemBuilder: (context, item, isSelected, onChanged) {
                        return InkWell(
                          onTap: item.enabled ? () => onChanged!(!isSelected) : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                      width: 2,
                                    ),
                                    color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
                                  ),
                                  child: isSelected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                                const SizedBox(width: 12),
                                Text(getCountryFlag(item.name), style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      color: item.enabled ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (!item.enabled) const Icon(Icons.lock_outline, size: 16, color: Color(0xFF94A3B8)),
                              ],
                            ),
                          ),
                        );
                      },
                      selectAllBuilder: (context, selectAll, onChanged) {
                        return InkWell(
                          onTap: () => onChanged!(!selectAll),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectAll ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                                      width: 2,
                                    ),
                                    color: selectAll ? const Color(0xFF0F172A) : Colors.transparent,
                                  ),
                                  child: selectAll ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                ),
                                const SizedBox(width: 12),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Select All",
                                    style: TextStyle(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      decoration: const DropdownDecoration(
                        dropdownStyle: DropdownStyle(
                          backgroundColor: Colors.white,
                          borderRadius: 12,
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        maxVisibleItems: 5,
                      ),
                      placeholder: 'Select countries',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 2
                  _ExampleSection(
                    label: 'Search & Select All',
                    description: 'Search with select all functionality',
                    child: FlutterMultiDropdown(
                      items: languages,
                      controller: languagesController,
                      enableSearch: true,
                      showSelectAll: true,
                      decoration: const DropdownDecoration(
                        dropdownStyle: DropdownStyle(
                          backgroundColor: Colors.white,
                          borderRadius: 12,
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        searchDecoration: DropdownSearchDecoration(
                          backgroundColor: Color(0xFFF8FAFC),
                          borderColor: Color(0xFFE2E8F0),
                          hintText: 'Search languages',
                        ),
                        checkboxDecoration: DropdownCheckboxDecoration(
                          activeColor: Color(0xFF0F172A),
                        ),
                      ),
                      placeholder: 'Select languages',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 3
                  _ExampleSection(
                    label: 'Max Selection Limit',
                    description: 'Limit selections with callback',
                    child: FlutterMultiDropdown(
                      items: priorities,
                      controller: prioritiesController,
                      maxSelection: 3,
                      onMaxSelectionReached: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum 3 items allowed'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      decoration: const DropdownDecoration(
                        dropdownStyle: DropdownStyle(
                          backgroundColor: Colors.white,
                          borderRadius: 12,
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        checkboxDecoration: DropdownCheckboxDecoration(
                          activeColor: Color(0xFF0F172A),
                        ),
                      ),
                      placeholder: 'Select up to 3 priorities',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 4
                  _ExampleSection(
                    label: 'Compact View',
                    description: 'Display count instead of names',
                    child: FlutterMultiDropdown(
                      items: departments,
                      controller: departmentsController,
                      showSelectedItemName: false,
                      enableSearch: true,
                      decoration: const DropdownDecoration(
                        dropdownStyle: DropdownStyle(
                          backgroundColor: Colors.white,
                          borderRadius: 12,
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        searchDecoration: DropdownSearchDecoration(
                          backgroundColor: Color(0xFFF8FAFC),
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        checkboxDecoration: DropdownCheckboxDecoration(
                          activeColor: Color(0xFF0F172A),
                        ),
                      ),
                      placeholder: 'Select departments',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 6
                  _ExampleSection(
                    label: 'Single Selection',
                    description: 'Behave like a normal dropdown',
                    child: FlutterMultiDropdown(
                      items: currencies,
                      controller: currenciesController,
                      selectionMode: DropdownSelectionMode.single,
                      initialSingleValue: currencies.first.id,
                      autoCloseOnItemTap: true,
                      onSingleItemSelected: (selectedId) {
                        debugPrint("Selected Id: $selectedId");
                      },
                      showSelectAll: false,
                      decoration: const DropdownDecoration(
                        dropdownStyle: DropdownStyle(
                          backgroundColor: Colors.white,
                          borderRadius: 12,
                          borderColor: Color(0xFFE2E8F0),
                        ),
                        checkboxDecoration: DropdownCheckboxDecoration(
                          activeColor: Color(0xFF0F172A),
                        ),
                      ),
                      placeholder: 'Select currency',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 7
                  _ExampleSection(
                    label: 'Loading & Empty States',
                    description: 'Enhanced state builders with animations',
                    child: Column(
                      children: [
                        FlutterMultiDropdown(
                          items: dynamicItems,
                          controller: dynamicController,
                          showLoading: isLoading,
                          isEmptyData: isEmpty,
                          loadingBuilder: (context) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Loading items...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please wait a moment',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          emptyBuilder: (context) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.inbox_outlined,
                                    size: 32,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'No items found',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters or check back later',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: const DropdownDecoration(
                            dropdownStyle: DropdownStyle(
                              backgroundColor: Colors.white,
                              borderRadius: 12,
                              borderColor: Color(0xFFE2E8F0),
                            ),
                            minHeight: 260,
                          ),
                          placeholder: 'Select items',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                    isEmpty = false;
                                  });
                                  Future.delayed(const Duration(seconds: 2), () {
                                    setState(() => isLoading = false);
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Loading'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    isLoading = false;
                                    isEmpty = !isEmpty;
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(isEmpty ? 'Show' : 'Empty'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Example 8
                  _ExampleSection(
                    label: 'Programmatic Control',
                    description: 'Control via controller methods',
                    child: Column(
                      children: [
                        FlutterMultiDropdown(
                          items: skills,
                          controller: skillsController,
                          decoration: const DropdownDecoration(
                            dropdownStyle: DropdownStyle(
                              backgroundColor: Colors.white,
                              borderRadius: 12,
                              borderColor: Color(0xFFE2E8F0),
                            ),
                            checkboxDecoration: DropdownCheckboxDecoration(
                              activeColor: Color(0xFF0F172A),
                            ),
                          ),
                          placeholder: 'Select skills',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => skillsController.updateSelection([1, 2]),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Frontend'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => skillsController.updateSelection([3, 5, 6]),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Backend'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => skillsController.clearSelection(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Clear'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleSection extends StatelessWidget {
  final String label;
  final String description;
  final Widget child;

  const _ExampleSection({
    required this.label,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
