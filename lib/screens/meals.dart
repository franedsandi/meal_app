import 'package:flutter/material.dart';
import 'package:meal_app/screens/meal_details.dart';
import 'package:meal_app/widgets/meal_item.dart';
import '../models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
    /*  required this.onToggleFavorite, */
  });

  final String? title;
  final List<Meal> meals;
  /* final void Function(Meal meal) onToggleFavorite; */

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
/*           onToggleFavorite: onToggleFavorite, */
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (ctx, meal) {
          selectMeal(context, meal);
        },
      ),
    );

    if (meals.isEmpty) {
      content = Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Oh... nothing here',
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Try selection a diferent category!',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
        ]),
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
