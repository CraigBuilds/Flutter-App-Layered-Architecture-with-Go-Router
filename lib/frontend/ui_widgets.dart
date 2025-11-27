import 'package:flutter/material.dart';

// ------------------- UI Layer: Components ------------------
// Widgets are the building blocks of our UI. They should be as dumb as possible. They simply display the data they are given, and call the methods they
// are given when user interactions occur. They should not have any knowledge of the domain model or controllers.
// They can use the BuildContext to retrieve theme data as needed. It is better to do that here rather than in the parent, so that widgets have consistent
// theming across the application.

class CenteredValue extends StatelessWidget {
  final int value;
  final VoidCallback? onValueTapped;
  const CenteredValue({super.key, required this.value, this.onValueTapped});
  @override
  Widget build(BuildContext _) => Center(
    child: ElevatedButton(
      onPressed: onValueTapped,
      child: Text('Value: $value')
    )
  );
}

class GiantCenteredValue extends StatelessWidget {
  final int value;
  const GiantCenteredValue({super.key, required this.value});
  @override
  Widget build(BuildContext _) => Center(
    child: Text('$value', style: const TextStyle(fontSize: 100))
  );
}

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentURL;
  final VoidCallback? onBack;
  final VoidCallback? onPlus;
  final VoidCallback? onMinus;
  const NavigationAppBar({super.key, required this.currentURL, this.onBack, this.onPlus, this.onMinus});
  @override
  Widget build(BuildContext _) => AppBar(
    title: Text(currentURL),
    leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
    actions: [
      if (onPlus != null)
        IconButton(icon: const Icon(Icons.add), onPressed: onPlus),
      if (onMinus != null)
        IconButton(icon: const Icon(Icons.remove), onPressed: onMinus),
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
  Widget build(BuildContext _) => FloatingActionButton(
    onPressed: onPlus ?? onMinus,
    child: Icon(onPlus != null ? Icons.add : Icons.remove),
  );
}
