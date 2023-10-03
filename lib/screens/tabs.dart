import 'package:flutter/material.dart';
import 'package:mealsapp/data/dummy_data.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/screens/categories.dart';
import 'package:mealsapp/screens/filters.dart';
import 'package:mealsapp/screens/meals.dart';
import 'package:mealsapp/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() {
    return _TabsScreen();
  }
}

class _TabsScreen extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFiters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExsisting = _favoriteMeals.contains(meal);
    setState(() {
      if (isExsisting) {
        _favoriteMeals.remove(meal);
        _showInfoMessage('Meal is no longer a favorite!');
      } else {
        _favoriteMeals.add(meal);
        _showInfoMessage('Marked as a favorite!');
      }
    });
  }

  void _selectPage(index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => FilterScreen(currentFilters: _selectedFiters),
        ),
      );
      setState(() {
        _selectedFiters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFiters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFiters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFiters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFiters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availabelMeals: availableMeals,
    );

    var _activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      _activePageTitle = "Your Favorites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Category",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          )
        ],
      ),
    );
  }
}
