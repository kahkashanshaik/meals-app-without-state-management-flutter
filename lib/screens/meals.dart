import 'package:flutter/material.dart';
import 'package:mealsapp/models/meal.dart';
import 'package:mealsapp/widgets/meal_item.dart';
import 'package:mealsapp/screens/meal_details.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onToggleFavorite});

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  void _selectedMeal(BuildContext context, Meal mealItem) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailsScreen(
        mealItem: mealItem,
        onToggleFavorite: onToggleFavorite,
      ),
    ));
  }

  @override
  Widget build(context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(" Uh, oh.... Nothing Here ",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground)),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Try selecting different category",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          )
        ],
      ),
    );
    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) => MealItem(
          mealItem: meals[index],
          selectedMeal: (meal) {
            _selectedMeal(context, meal);
          },
        ),
      );
    }
    if (title == null) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
