import 'package:flutter/material.dart';
import '../providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_app/screens/filters.dart';
import 'package:meal_app/screens/meals.dart';
import './categories.dart';
import '../widgets/main_drawer.dart';
import '../providers/favorites_provider.dart';
import '../providers/filters_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

/*   final List<Meal> _favoriteMeals = []; */
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  /* void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal); */

/*   void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        /* default time 4 s */
        content: Text(message),
      ),
    );
  }
/* 
    if (isExis */ting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('This meal is no longer in your favotite meals list!');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('This meal is now in your favotite meals list!');
    }
  } */

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop;
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        /* ?? = if is null */
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meal = ref.watch(mealsProvider);
    final avaliableMeals = meal.where(
      (meal) {
        if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
          return false;
        }
        if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
          return false;
        }
        if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
          return false;
        }
        if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
          return false;
        }
        return true;
      },
    ).toList();
    Widget activePage = CategoriesScreen(
      /*  onToggleFavorite: _toggleMealFavoriteStatus, */
      avaliableMeals: avaliableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
        /* onToggleFavorite: _toggleMealFavoriteStatus, */
      );
      activePageTitle = 'Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
