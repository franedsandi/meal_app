import 'package:flutter/material.dart';
import 'package:meal_app/data/dummy_data.dart';
import 'package:meal_app/screens/meals.dart';
import '../widgets/category_grid_item.dart';
import '../models/category.dart';
import '../models/meal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.avaliableMeals,
  });

  final List<Meal> avaliableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  /* late tells dart that the animation will be used in future but not yet when the class is created tecnicaly */
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound:
          1, /* the values can changes depending on your animation idea */
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose(); /* helps deleting the animation memory  */
  }

/* the context does not exist in stateless  widget , we need to build it*/
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.avaliableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        child: GridView(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () {
                  _selectCategory(context, category);
                },
              )
          ],
        ),
        builder: (context, child) => SlideTransition(
              position: Tween(
                begin: const Offset(0, -0.3),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.bounceOut,
              )),
              child: child,
            )
        /*  Padding(
          padding: EdgeInsets.only(
            top: 100 - _animationController.value * 100,
          ),
          child: child), */
        );
  }
}
