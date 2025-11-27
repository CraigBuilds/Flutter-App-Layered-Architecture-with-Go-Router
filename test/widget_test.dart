import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_layered_architecture_with_go_router/frontend/ui_pages.dart';
import 'package:flutter_app_layered_architecture_with_go_router/frontend/controller_interfaces.dart';
import 'package:flutter_app_layered_architecture_with_go_router/backend/domain_model.dart';

CounterUpView buildMyWidget(MockController controller) {
  return CounterUpView(controller: controller);
}

ValueListenableBuilder _bootstrap(MockController controller) => ValueListenableBuilder(
  valueListenable: controller.valueNotifier,
  builder: (_,_,_) => buildMyWidget(controller),
);

MaterialApp bootstrapApp(MockController controller) => MaterialApp(
  home: _bootstrap(controller),
);

MaterialApp bootstrapRouter(MockController controller) => MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_,_) => _bootstrap(controller),
      ),
    ]
  )
);

void main() {
  testWidgets('CounterUpView smoke test', (WidgetTester tester) async {
    final controller = MockController(ValueNotifier<AppModel>(AppModel(42)));
    final app = bootstrapRouter(controller);
    await tester.pumpWidget(app);
    expect(find.text('Value: 42'), findsOneWidget);
    controller.increment();
    await tester.pump();
    expect(find.text('Value: 43'), findsOneWidget);
  });
}

/// The mock controller uses the valueNotifier for state management and reactivity.
/// The real controllers are dumb, and just call the onModelChanged callback when they mutate the model.
/// The reactivity in the real app is handled in the router, where the ValueNotifier is updated when the controller calls onModelChanged.
class MockController implements IUpController, IDownController {
    
  final ValueNotifier<AppModel> valueNotifier;
  MockController(this.valueNotifier);

  @override
  AppModel get model => valueNotifier.value;

  @override
  void increment() {
    valueNotifier.value = AppModel(model.counter + 1);
  }

  @override
  void decrement() {
    valueNotifier.value = AppModel(model.counter - 1);
  }
}