import 'package:flutter/material.dart';
import '../../Controller/MenuItemsServices.dart';
import '../../Model/menuItemModel.dart';
import 'MenuItemCard.dart';
import 'MenuItemCardOpen.dart';
import 'package:tableturn_project0/View/Menu/menu_seed_items.dart';
import '../../Model/Options/menuOptions.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  // For secondary tag filtering
  final Set<String> _selectedTags = {};

  List<String> get _availableTags {
    // Show tags based on main filter
    if (_selectedFilter == 'Vegetarian') {
      return dietaryTags;
    } else if (_selectedFilter == 'Drinks') {
      return menuTags;
    } else if (_selectedFilter == 'Food') {
      return menuTags;
    } else if (_selectedFilter == 'Dessert') {
      return menuTags;
    }
    // For 'All' or other, show all tags
    return {...dietaryTags, ...menuTags}.toList();
  }

  final List<String> _filters = [
    'All',
    'Vegetarian',
    'Food',
    'Drinks',
    'Sides',
    'Dessert',
  ];
  String _selectedFilter = 'All';
  final MenuItemsService _menuService = MenuItemsService();

  Future<void> seedMenuItems() async {
    for (final item in menuSeedItems) {
      await _menuService.addMenuItem(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await seedMenuItems();
        },
        child: const Icon(Icons.add),
        tooltip: 'Seed Menu Items',
      ),
      body: Column(
        children: [
          // Main filter bar
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                      _selectedTags.clear(); // Clear tags on main filter change
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Secondary tag filter bar
          if (_availableTags.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _availableTags.length,
                itemBuilder: (context, index) {
                  final tag = _availableTags[index];
                  final isSelected = _selectedTags.contains(tag);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_selectedTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedTags.clear();
                  });
                },
                child: const Text('Clear Tags'),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<MenuItemModel>>(
              future: _menuService.fetchMenuItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load menu items'));
                }
                var items = snapshot.data ?? [];
                // Main filter logic
                if (_selectedFilter != 'All') {
                  if (_selectedFilter == 'Vegetarian') {
                    items = items
                        .where(
                          (item) => item.dietaryTags.contains('Vegetarian' ),
                        )
                        .toList();
                  } else if (_selectedFilter == 'Food') {
                    items = items
                        .where((item) => item.category.contains('Food'))
                        .toList();
                  } else if (_selectedFilter == 'Drinks') {
                    items = items
                        .where((item) => item.category.contains('Drink'))
                        .toList();
                  } else if (_selectedFilter == 'Dessert') {
                    items = items
                        .where((item) => item.menuTags.contains('Dessert'))
                        .toList();
                  } else if (_selectedFilter == 'Sides') {
                    items = items
                        .where((item) => item.category.contains('Side'))
                        .toList();
                  }
                }
                // Secondary tag filter logic (multi-tag, AND logic)
                if (_selectedTags.isNotEmpty) {
                  items = items.where((item) {
                    final allTags = <String>{
                      ...item.dietaryTags,
                      ...item.menuTags,
                    };
                    return _selectedTags.every((tag) => allTags.contains(tag));
                  }).toList();
                }
                if (items.isEmpty) {
                  return const Center(child: Text('No menu items found'));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate:
                        //used a fixed cross axis count of 2 to show 2 items per row
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    //item count is the length of the filtered items list
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return MenuItemCard(
                        item: item,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => MenuItemCardOpen(item: item),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
