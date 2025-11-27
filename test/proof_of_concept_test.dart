import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Text buildMyWidget<B,T,W>(B _, T value, W _) {
  return Text('$value');
}

MaterialApp bootstrap(ValueNotifier valueNotifier) => MaterialApp(
  home: ValueListenableBuilder(
    valueListenable: valueNotifier,
    builder: buildMyWidget,
  ),
);

void main() {
  testWidgets('Proof of Concept Test', (WidgetTester tester) async {
    final valueNotifier = ValueNotifier(42);
    final app = bootstrap(valueNotifier);
    await tester.pumpWidget(app);
    expect(find.text('42'), findsOneWidget, reason: 'Initial value should be 42');
    valueNotifier.value = 43;
    expect(find.text('43'), findsNothing, reason: 'Value should not update until widget is pumped again');
    await tester.pump();
    expect(find.text('43'), findsOneWidget, reason: 'Value should update to 43 after pumping the widget again');
  });
}