import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
// The router depends on the domain model, business logic controllers, and UI pages
import '../backend/domain_model.dart';
import '../backend/business_logic_controllers.dart';
import 'ui_pages.dart';

// ------------------- UI Layer: Router ------------------

// Three Responsibilities:
// 1. Map route names to UI pages (Navigation Modelling)
// 2. Provide the necessary controllers to the UI pages (Dependency Injection)
// 3. Listen to model changes and rebuild the pages accordingly (State Management / Reactivity)
//
// Controllers are pretty dumb, they just perform the mutation on the model and call the onModelChanged callback. So here,
// we wire up that callback so it notifies the ValueNotifier<AppModel> of the new model, which in turn rebuilds the UI via ValueListenableBuilder.
// This way, we have the full cycle:
// - Views are stateless: The content is derived from the AppModel
// - Views are rebuilt when ValueNotifier<AppModel> changes
// - Views call controller methods on user actions
// - Controllers mutate the model and call onModelChanged
// - onModelChanged updates the ValueNotifier<AppModel>
//
// Currently, there is a single ValueNotifier<AppModel> that holds the entire application state, so all views are rebuilt on any change.
// This could be extended in teh future for more fine-grained reactivity, by only rebuilding pages that depend on the changed parts of the model.
class AppRouter {
  final ValueNotifier<AppModel> modelNotifier;
  late final GoRouter config;

  void onModelChanged(AppModel model) {
    modelNotifier.value = model;
  }

  AppRouter(this.modelNotifier) {
    config = GoRouter(
      initialLocation: '/up',
      routes: [
        GoRoute(
          path: '/up',
          builder: (_, _) => ValueListenableBuilder(
            valueListenable: modelNotifier,
            builder: (_, _, _) => CounterUpView(controller: UpController(model: modelNotifier.value, onModelChanged: onModelChanged)),
          ),
        ),
        GoRoute(
          path: '/down',
          builder: (_, _) => ValueListenableBuilder(
            valueListenable: modelNotifier,
            builder: (_, _, _) => CounterDownView(controller: DownController(model: modelNotifier.value, onModelChanged: onModelChanged)),
          ),
        ),
      ],
    );
  }
}