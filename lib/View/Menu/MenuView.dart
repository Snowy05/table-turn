import 'package:flutter/material.dart';
import '../../Controller/MenuItemsServices.dart';
import '../../Model/menuItemModel.dart';
import 'MenuItemCard.dart';
import 'MenuItemCardOpen.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final List<String> _filters = [
    'All',
    'Vegetarian',
    'Food',
    'Drinks',
    'Dessert',
  ];
  String _selectedFilter = 'All';
  final MenuItemsService _menuService = MenuItemsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add a mock menu item
          final mockItem = MenuItemModel(
            uid: DateTime.now().millisecondsSinceEpoch.toString(),
            name: 'Mock Item',
            description: 'A delicious mock menu item.',
            price: 9.99,
            imageUrl:
                'assets/images/mock_food.png', // Update this to your asset path
            category: ['Drink'],
            isAvailable: true,
            calories: '350',
            menuTags: ['Dessert'],
            dietaryTags: ['Drink'],
          );
          await _menuService.addMenuItem(mockItem);
          setState(() {});
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Mock Menu Item',
      ),
      body: Column(
        children: [
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
                //fFiltering logic
                if (_selectedFilter != 'All') {
                  //simple filtering based on what the selected filter is, it checks the relevant fields of the menu
                  // item to see if it matches the filtern
                  if (_selectedFilter == 'Vegetarian') {
                    items = items
                        .where(
                          (item) => item.dietaryTags.contains('Vegetarian'),
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
                  }
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
