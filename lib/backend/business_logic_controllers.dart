// The business logic controllers depend on the domain model and controller interfaces
import 'domain_model.dart';
import '../frontend/controller_interfaces.dart';

// ------------------- 02: Business Logic Layer (Controllers) ------------------
// Mutations to the domain model are done here, not in the domain layer (below) or the UI layer (above).
// The controllers are decoupled from any specific state management approach. They use a onModelChanged callback which can be wired up to any state management solution.
// We can separate controllers for different use cases (e.g incrementing vs decrementing), so that UI components only have access to the functionality they need.

typedef ModelChangedCallback = void Function(AppModel model);

class UpController implements IUpController {
  
  @override
  final AppModel model;
  final ModelChangedCallback onModelChanged;

  UpController({required this.model, required this.onModelChanged});

  @override
  void increment() {
    final newValue = model.copyWith(counter: model.counter + 1);
    onModelChanged(newValue);
  }
}

class DownController implements IDownController {
  
  @override
  final AppModel model;
  final ModelChangedCallback onModelChanged;

  DownController({required this.model, required this.onModelChanged});

  @override
  void decrement() {
    final newValue = model.copyWith(counter: model.counter - 1);
    onModelChanged(newValue);
  }
}