import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; //for context.go

// The UI pages depend on the controller interfaces and UI widgets
import '02_controller_interfaces.dart';
import '04_ui_widgets.dart';

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