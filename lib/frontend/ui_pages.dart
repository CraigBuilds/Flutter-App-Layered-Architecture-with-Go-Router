import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //for context.go
// The UI pages depend on the controller interfaces and UI widgets
import 'controller_interfaces.dart';
import 'ui_widgets.dart';

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
  Widget build(BuildContext ctx) => Scaffold(
    body: CenteredValue(value: controller.model.counter, onValueTapped: () => ctx.push('/details/${controller.model.counter}')),
    floatingActionButton: PlusMinusFloatingActionButton(onPlus: controller.increment),
    appBar: NavigationAppBar(currentURL: ctx.location, onMinus: () => ctx.push('/down'), onBack: () => ctx.canPop() ? ctx.pop() : null),
  );
}

class CounterDownView extends StatelessWidget {
  final IDownController controller;
  const CounterDownView({super.key, required this.controller});

  @override
  Widget build(BuildContext ctx) => Scaffold(
    body: CenteredValue(value: controller.model.counter, onValueTapped: () => ctx.push('/details/${controller.model.counter}')), 
    floatingActionButton: PlusMinusFloatingActionButton(onMinus: controller.decrement),
    appBar: NavigationAppBar(currentURL: ctx.location, onPlus: () => ctx.push('/up'), onBack: () => ctx.canPop() ? ctx.pop() : null),
  );
}


///Tells you a fact about a number. This is an example of a page that requires an input parameter (the number to show details for).
class NumberDetailsView extends StatelessWidget {
  final ISelectedNumberController controller;
  const NumberDetailsView({super.key, required this.controller});

  @override
  Widget build(BuildContext ctx) => Scaffold(
    appBar: NavigationAppBar(currentURL: ctx.location, onPlus: () => ctx.push('/up'), onMinus: () => ctx.push('/down'), onBack: () => ctx.pop()),
    body: GiantCenteredValue(value: controller.number),
  );
}



// Extension method to get the current location from the BuildContext
extension AnotherGoRouterHelper on BuildContext {
  String get location => GoRouter.of(this).state.matchedLocation;
}