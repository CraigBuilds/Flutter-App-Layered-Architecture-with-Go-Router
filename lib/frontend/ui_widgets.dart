import 'package:flutter/material.dart';

// ------------------- UI Layer: Components ------------------
// Widgets are the building blocks of our UI. They should be as dumb as possible. They simply display the data they are given, and call the methods they
// are given when user interactions occur. They should not have any knowledge of the domain model or controllers.
// They can use the BuildContext to retrieve theme data as needed. It is better to do that here rather than in the parent, so that widgets have consistent
// theming across the application.

class CenteredValue extends StatelessWidget {
  final int value;
  const CenteredValue({super.key, required this.value});
  @override
  Widget build(BuildContext context) => Center(child: Text('Value: $value'));
}

class BackForthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onForth;
  const BackForthAppBar({super.key, required this.onBack, required this.onForth});

  @override
  Widget build(BuildContext context) => AppBar(
    actions: [
      IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBack,
      ),
      IconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: onForth,
      ),
    ],
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PlusMinusFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;
  const PlusMinusFloatingActionButton({super.key, this.onPlus, this.onMinus});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: onPlus ?? onMinus,
    child: Icon(onPlus != null ? Icons.add : Icons.remove),
  );
}
