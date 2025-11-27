// The controller interfaces depend on the domain model
import '../backend/domain_model.dart';

// ------------------- Controller Interfaces ------------------
// The UI pages depend on these interfaces, not the concrete implementations. This completely decouples the front-end layer from the back-end layer.

abstract class IUpController {
  void increment();
  AppModel get model;
}

abstract class IDownController {
  void decrement();
  AppModel get model;
}

abstract class ISelectedNumberController {
  int get number;
}