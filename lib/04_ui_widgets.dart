import 'package:flutter/material.dart';

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
