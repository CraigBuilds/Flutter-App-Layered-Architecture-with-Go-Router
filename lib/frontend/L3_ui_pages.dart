import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //for context.go
// The UI pages depend on the controller interfaces and UI widgets
import 'L1_controller_interfaces.dart';
import 'L4_ui_widgets.dart';

// ------------------- UI Layer: Views ------------------
// Pages are the main screens of our application.
// They are injected with a controller containing the latest model data, and methods to handle user interactions.
// They are completely stateless, and the content is derived only from the domain model.
// They use controllers to handle user interactions.
// They only depend on controller interfaces, not concrete implementations.
// They are responsible for declaratively composing smaller widgets together to form the full screen UI.
// They pass the appropriate data from the domain model into it's display widgets, and it passes appropriate controller methods into the interaction widgets.
// It should not pass the entire model or controller down to child widgets, only the data and methods that those child widgets need. Pages are the only Widgets
// that have access to the model or controller objects. This keeps the widgets "dumb" and decoupled. They simply display the data they are given, and call the
// methods they are given when user interactions occur.
// Pages should not use reference theme data directly. The child widgets should use the context to retrieve theme data as needed. 

class CounterUpView extends StatelessWidget {
  final IUpController controller;
  const CounterUpView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CenteredValue(value: controller.model.counter),
    floatingActionButton: PlusMinusFloatingActionButton(onPlus: controller.increment),
    appBar: BackForthAppBar(onBack: () => context.go('/down'), onForth: () => context.go('/up') ),
  );
}

class CounterDownView extends StatelessWidget {
  final IDownController controller;
  const CounterDownView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CenteredValue(value: controller.model.counter),
    floatingActionButton: PlusMinusFloatingActionButton(onMinus: controller.decrement),
    appBar: BackForthAppBar(onBack: () => context.go('/up'), onForth: () => context.go('/down')),
  );
}