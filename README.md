# flutter_app_layered_arch_with_go_router

A demonstration of a layered architecture using Flutter and GoRoute.

| Component         | Layer          |      Responsibility          | Notes                                                             | Dependencies            |
|-------------------|----------------|------------------------------|-------------------------------------------------------------------|-------------------------|
| `main function`   | Entry Point    | Bootstrap, composition root  |                                                                   | `AppModel`, `AppRouter` |
| `AppModel`        | Domain         | Immutable state definition   | Defines structure of domain data                                  | depends on nothing     |
| `Controllers`     | Business Logic | State mutation logic         | Decoupled from reactivity approach                                | `IControllers`          |
| `IControllers`    | Interface      | Frontend-backend contracts   |                                                                   | `AppModel`              |
| `AppRouter`       | Integration    | Navigation, DI, reactivity   |                                                                   | `AppModel` `Controllers` `Views` |
| `Views`           | Frontend       | Screen composition           | Stateless (model driven). Use controllers for user interaction    | `Widgets` `IControllers`  |
| `Widgets`         | Frontend       | Reusable UI components       | Dumb. Do not know about domain or controllers                     | depends on nothing       |

### Data Flow (Interaction)

- User Action (tap button)
- Widget calls callback (e.g onPlus, onMinus)
- Page Calls Controller (e.g controller.increment)
- Controller Mutate Model (e.g using model.copyWith)
- Controller triggers onModelChangedCallback
- ValueNotifier updated (the router wires the Controller onModelChangedCallback to the ValueNotifier)
- ValueListenableBuilder rebuilds (rebuilds the Pages and Controllers with the new model)
- UI reflects new state (Page receives new controller with updated model)

## Getting Started

`flutter run -d windows`