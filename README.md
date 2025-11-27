# flutter_app_layered_arch_with_go_router

A demonstration of a layered architecture using Flutter and GoRoute.

| Component | Layer | Responsibility | Notes | Dependencies |
|------|-------|----------------|
| `main function`   | Entry Point    | Bootstrap, composition root  |                                                                   | `AppModel`, `AppRouter` |
| `AppModel`        | Domain         | Immutable state definition   | Defines structure of domain data                                  | depends on nothing     |
| `Controllers`     | Business Logic | State mutation logic         | Decoupled from reactivity approach                                | `IControllers`          |
| `IControllers`    | Interface      | Frontend-backend contracts   |                                                                   | `AppModel`              |
| `AppRouter`       | Integration    | Navigation, DI, reactivity   |                                                                   | `AppModel` `Controllers` `Views` |
| `Views`           | Frontend       | Screen composition           | Stateless (model driven). Use controllers for user interaction    | `Widgets` `IControllers`  |
| `Widgets`         | Frontend       | Reusable UI components       | Dumb. Do not know about domain or controllers                     | depends on nothing       |

## Getting Started

`flutter run -d windows`