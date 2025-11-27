// The business logic controllers depend on the domain model and controller interfaces
import '01_domain_model.dart';
import '02_controller_interfaces.dart';

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