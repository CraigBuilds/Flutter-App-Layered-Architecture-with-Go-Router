import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_layered_architecture_with_go_router/frontend/ui_pages.dart';
import 'package:flutter_app_layered_architecture_with_go_router/frontend/controller_interfaces.dart';
import 'package:flutter_app_layered_architecture_with_go_router/backend/domain_model.dart';


/// The mock controller owns the valueNotifier for state management and reactivity.
/// The real controllers are dumb, and just call the onModelChanged callback when they mutate the model.
/// The reactivity in the real app is handled in the router, where the ValueNotifier is updated when the controller calls onModelChanged.
class MockController implements IUpController, IDownController {
  
  final valueNotifier = ValueNotifier<AppModel>(AppModel(42));
  
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

void main() {
  testWidgets('CounterUpView smoke test', (WidgetTester tester) async {
    final controller = MockController();
    await tester.pumpWidget(CounterUpView(controller: controller));
    expect(find.text('42'), findsOneWidget);
    controller.increment();
    await tester.pump();
    expect(find.text('43'), findsOneWidget);
  });
}
