import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final globalValueNotifier = ValueNotifier<int>(42);

Widget buildMyWidget<B,T,W>(B _, T value, W _) {
  return Text('$value');
}

void main() {
  testWidgets('Proof of Concept Test', (WidgetTester tester) async {
    final app = bootstrap();
    await tester.pumpWidget(app);
    expect(find.text('42'), findsOneWidget, reason: 'Initial value should be 42');
    globalValueNotifier.value = 43;
    expect(find.text('43'), findsNothing, reason: 'Value should not update until widget is pumped again');
    await tester.pump();
    expect(find.text('43'), findsOneWidget, reason: 'Value should update to 43 after pumping the widget again');
  });
}

MaterialApp bootstrap() => MaterialApp(
  home: ValueListenableBuilder<int>(
    valueListenable: globalValueNotifier,
    builder: buildMyWidget,
  ),
);