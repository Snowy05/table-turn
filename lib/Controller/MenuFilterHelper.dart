import '../../Model/menuItemModel.dart';
import '../../Model/Options/menuOptions.dart';

///helper class to manage menu filtering logic based on selected filters and tags.
/// this class provides methods to determine available tags for a given filter and to apply both main and secondary filters to a list of menu items.
///he filtering logic is designed to be robust against whitespace and case variations in tags, and it also considers matches in item names and descriptions for a more comprehensive filtering experience.
class MenuFilterHelper {
  /// Returns the available tags for the current filter.
  static List<String> availableTags(String selectedFilter) {
    if (selectedFilter == 'Vegan') {
      return dietaryTags
          .where(
            (tag) =>
                tag != 'Vegan' && tag != 'Vegetarian' && tag != 'Pescatarian',
          )
          .toList();
    } else if (selectedFilter == 'Vegetarian') {
      return dietaryTags
          .where(
            (tag) =>
                tag != 'Vegetarian' && tag != 'Vegan' && tag != 'Pescatarian',
          )
          .toList();
    } else if (selectedFilter == 'Pescatarian') {
      return dietaryTags
          .where(
            (tag) =>
                tag != 'Pescatarian' && tag != 'Vegan' && tag != 'Vegetarian',
          )
          .toList();
    } else if (selectedFilter == 'Drinks') {
      return [
            'Non-Alcoholic',
            'Low-Sugar',
            'Low ABV',
            'High ABV',
            'Alcohol',
            'No Sugar',
            'No Alcohol',
          ]
          .where((tag) => dietaryTags.contains(tag) || menuTags.contains(tag))
          .toList();
    } else if (selectedFilter == 'Food') {
      return menuTags
          .where((tag) => tag != 'Low ABV' && tag != 'High ABV')
          .toList();
    } else if (selectedFilter == 'Dessert') {
      return menuTags
          .where((tag) => tag == 'Dessert' || tag == 'Classic' || tag == 'New')
          .toList();
    }
    return {...dietaryTags, ...menuTags}.toList();
  }

  /// Applies the main filter to the menu items.
  static List<MenuItemModel> applyMainFilter(
    List<MenuItemModel> items,
    String selectedFilter,
  ) {
    if (selectedFilter == 'All') return items;
    if (selectedFilter == 'Vegetarian') {
      return items
          .where((item) => item.dietaryTags.contains('Vegetarian'))
          .toList();
    } else if (selectedFilter == 'Food') {
      return items.where((item) => item.category.contains('Food')).toList();
    } else if (selectedFilter == 'Drinks') {
      return items.where((item) => item.category.contains('Drink')).toList();
    } else if (selectedFilter == 'Dessert') {
      return items.where((item) => item.menuTags.contains('Dessert')).toList();
    } else if (selectedFilter == 'Sides') {
      return items.where((item) => item.category.contains('Side')).toList();
    }
    return items;
  }

  ///ppplies secondary tag filtering (multi-tag, AND logic, robust to whitespace/case)
  static List<MenuItemModel> applyTagFilter(
    List<MenuItemModel> items,
    Set<String> selectedTags,
  ) {
    if (selectedTags.isEmpty) return items;
    return items.where((item) {
      return selectedTags.every((tag) {
        final tagLower = tag.trim().toLowerCase();
        final matchesDietary = item.dietaryTags.any(
          (t) => t.trim().toLowerCase() == tagLower,
        );
        final matchesMenu = item.menuTags.any(
          (t) => t.trim().toLowerCase() == tagLower,
        );
        final matchesCategory = item.category.any(
          (t) => t.trim().toLowerCase() == tagLower,
        );
        final matchesName = item.name.toLowerCase().contains(tagLower);
        final matchesDescription = item.description.toLowerCase().contains(
          tagLower,
        );
        return matchesDietary ||
            matchesMenu ||
            matchesCategory ||
            matchesName ||
            matchesDescription;
      });
    }).toList();
  }
}
