import 'package:flutter/material.dart';
import 'package:mealsapp/data/dummy_data.dart';
import 'package:mealsapp/models/category.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/screens/meals.dart';
import 'package:mealsapp/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggleFavorite,
      required this.availabelMeals});

  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> availabelMeals;

  void _selectedCategory(BuildContext context, Category category) {
    final filteredMeals = availabelMeals
        .where((element) => element.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggleFavorite: onToggleFavorite),
    )); // Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20),
      children: [
        // availableCategories.map((category) => CategoryGridItem(category: category)).toList(),
        for (final cateogry in availableCategories)
          CategoryGridItem(
            category: cateogry,
            onSelectedCategory: () {
              _selectedCategory(context, cateogry);
            },
          )
      ],
    );
  }
}
