//The app model does not depend on anything else (no imports needed)

// ------------------- 01: Domain Layer ------------------
// The data used to define the state of the application (defines how the UI looks at any point in time)
// It is a modeled after a domain area (e.g robotics, banking, fitness, etc) and can use structures that best represent that domain.
// In this example, we have a simple counter application, so the domain model is just a single integer value.
// The domain layer does not contain business logic or UI logic. It simply defines the data structures that represent the state of the application.
// The model is immutable, so any changes produce a new instance of the model.
// copyWith is a common pattern in Dart/Flutter to create a new instance of the model with some properties changed.

class AppModel {
  final int counter;
  AppModel(this.counter);
  AppModel copyWith({int? counter}) {
    return AppModel(counter ?? this.counter);
  }
}