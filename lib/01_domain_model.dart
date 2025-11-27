//The app model does not depend on anything else (no imports needed)

class AppModel {
  final int counter;
  AppModel(this.counter);
  AppModel copyWith({int? counter}) {
    return AppModel(counter ?? this.counter);
  }
}