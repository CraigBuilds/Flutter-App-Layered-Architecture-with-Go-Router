import 'package:flutter/material.dart';
// The main app depends on the domain model and the router
import '01_domain_model.dart';
import '05_router.dart';

void main() {
  
  final valueListenable = ValueNotifier(AppModel(0));
  final router = AppRouter(valueListenable);

  runApp(MyApp(valueListenable, router));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<AppModel> valueListenable;
  final AppRouter router;
  const MyApp(this.valueListenable, this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router.config,
    );
  }
}