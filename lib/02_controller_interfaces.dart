// The controller interfaces depend on the domain model
import '01_domain_model.dart';

abstract class IUpController {
  void increment();
  AppModel get model;
}

abstract class IDownController {
  void decrement();
  AppModel get model;
}