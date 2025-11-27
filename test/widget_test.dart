import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_layered_architecture_with_go_router/frontend/ui_pages.dart';
import 'package:flutter_app_layered_architecture_with_go_router/frontend/controller_interfaces.dart';
import 'package:flutter_app_layered_architecture_with_go_router/backend/domain_model.dart';

final globalValueNotifier = ValueNotifier<AppModel>(AppModel(42));

void main() {
  testWidgets('CounterUpView smoke test', (WidgetTester tester) async {
    final controller = MockController();
    final view = build(CounterUpView(controller: controller));
    await tester.pumpWidget(view);
  });
}

/// Wraps the given child widget with the minimal functionality needed to test UI pages:
Widget build(Widget child) {
  //Wrap the child in a ValueListenableBuilder so it is rebuilt whenever the global valueNotifier changes
  final reactiveChild = ValueListenableBuilder(valueListenable: globalValueNotifier, builder: (_, _, _) => child);
  //Wrap the reactive child in a GoRouter so it's build context contains a GoRouter object (required because UI pages use context.go)
  final routableChild = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => reactiveChild,
      ),
    ],
  );
  //Wrap the routable child in a MaterialApp so it has the necessary Material dependencies (Scaffold, AppBar, Theme.of, Navigator, MediaQuery, MaterialLocalizations, etc)
  return MaterialApp.router(
   routerConfig: routableChild,
  );
}

/// The mock controller uses the global valueNotifier for state management and reactivity.
/// The real controllers are dumb, and just call the onModelChanged callback when they mutate the model.
/// The reactivity in the real app is handled in the router, where the ValueNotifier is updated when the controller calls onModelChanged.
class MockController implements IUpController, IDownController {
    
  @override
  AppModel get model => globalValueNotifier.value;

  @override
  void increment() {
    globalValueNotifier.value = AppModel(model.counter + 1);
  }

  @override
  void decrement() {
    globalValueNotifier.value = AppModel(model.counter - 1);
  }
}