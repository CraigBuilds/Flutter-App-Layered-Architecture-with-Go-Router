# Scope
This document serves as a critical, living template designed to equip agents with a rapid and comprehensive understanding of the codebase's architecture, enabling efficient navigation and effective contribution from day one. Update this document as the codebase evolves. It should describe the architecture of the app with written text and ASCII diagrams. Add more sections when needed.

---

## Table of Contents

1. [File and Directory Listing](#file-and-directory-listing)
2. [Overall Architecture and Boundaries](#overall-architecture-and-boundaries)
3. [Core Design Strategy](#core-design-strategy)
4. [Data Flow](#data-flow)
5. [Backend Deep Dive](#backend-deep-dive)
6. [Pages Deep Dive](#pages-deep-dive)
7. [Widgets and Shared UI Deep Dive](#widgets-and-shared-ui-deep-dive)
8. [App Entry Point](#app-entry-point)
9. [Cross-cutting Architecture](#cross-cutting-architecture)
10. [Summary](#summary)

---

## File and Directory Listing

```
lib/
├── main.dart                           # App entry point, creates AppModel and Router
├── backend/
│   ├── domain_model.dart               # Domain layer: AppModel (immutable state)
│   └── business_logic_controllers.dart # Business logic: UpController, DownController
└── frontend/
    ├── controller_interfaces.dart      # Abstractions: IUpController, IDownController
    ├── router.dart                     # Navigation, DI, and state management: AppRouter
    ├── ui_pages.dart                   # Page views: CounterUpView, CounterDownView
    └── ui_widgets.dart                 # Reusable widgets: CenteredValue, BackForthAppBar, PlusMinusFloatingActionButton
```

**Total Files:** 7 Dart files across 3 directories (root, backend, frontend)

---

## Overall Architecture and Boundaries

This Flutter application follows a **Layered Architecture** pattern with clear separation between:

1. **Domain Layer** - Pure data models with no dependencies
2. **Business Logic Layer** - Controllers that mutate the domain model
3. **Frontend Layer** - UI components that display data and handle user interaction

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              ENTRY POINT                                     │
│                              main.dart                                       │
│                    ┌────────────────────────────┐                           │
│                    │  • Creates ValueNotifier   │                           │
│                    │  • Creates AppRouter       │                           │
│                    │  • Runs MyApp              │                           │
│                    └────────────────────────────┘                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ passes
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FRONTEND LAYER                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                          router.dart                                  │   │
│  │  AppRouter                                                            │   │
│  │  • Navigation Modelling (route → page mapping)                       │   │
│  │  • Dependency Injection (controller → page)                          │   │
│  │  • State Management (ValueNotifier reactivity)                       │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                      creates & injects controllers                           │
│                                    ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                         ui_pages.dart                                │   │
│  │  CounterUpView, CounterDownView                                      │   │
│  │  • Stateless views derived from model                                │   │
│  │  • Compose widgets into full screens                                 │   │
│  │  • Pass data/callbacks to child widgets                              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                              composes                                        │
│                                    ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        ui_widgets.dart                               │   │
│  │  CenteredValue, BackForthAppBar, PlusMinusFloatingActionButton       │   │
│  │  • "Dumb" display/interaction components                             │   │
│  │  • No knowledge of domain or controllers                             │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                   controller_interfaces.dart                         │   │
│  │  IUpController, IDownController                                      │   │
│  │  • Abstract interfaces for frontend-backend decoupling               │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                        uses interfaces │ implements
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              BACKEND LAYER                                   │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                  business_logic_controllers.dart                     │   │
│  │  UpController, DownController                                        │   │
│  │  • Implements controller interfaces                                  │   │
│  │  • Contains business logic (increment/decrement)                     │   │
│  │  • Uses callback-based state notification                            │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                         │
│                              depends on                                      │
│                                    ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                       domain_model.dart                              │   │
│  │  AppModel                                                            │   │
│  │  • Immutable state container                                         │   │
│  │  • No dependencies                                                   │   │
│  │  • copyWith pattern for updates                                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Layer Boundaries

```
                    IMPORTS / DEPENDENCIES
┌──────────────────────────────────────────────────────────────┐
│                                                               │
│    domain_model.dart  ◄─── business_logic_controllers.dart   │
│           ▲                         │                         │
│           │                         │                         │
│           │                implements                         │
│           │                         ▼                         │
│           └───────── controller_interfaces.dart              │
│                              ▲                                │
│                              │                                │
│                         depends on                            │
│                              │                                │
│           ┌──────────────────┼──────────────────┐            │
│           │                  │                  │            │
│           ▼                  ▼                  ▼            │
│      ui_pages.dart     router.dart      ui_widgets.dart      │
│           │                  │                               │
│           │                  │                               │
│           └──────────────────┼───────────────────────────────┤
│                              │                               │
│                         main.dart                            │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

**Key Boundary Rules:**
- `domain_model.dart` has **no dependencies** - pure domain representation
- `controller_interfaces.dart` only depends on domain model - defines frontend contracts
- `business_logic_controllers.dart` depends on domain + interfaces - implements contracts
- UI files (`ui_pages.dart`, `ui_widgets.dart`) depend only on interfaces, never on concrete controllers
- `router.dart` is the **integration point** - wires together controllers, pages, and state management

---

## Core Design Strategy

### Principle: Separation of Concerns via Dependency Inversion

The app employs a **Clean Architecture-inspired** approach where:

1. **Domain Layer (innermost)**: Contains pure data structures (`AppModel`) with no framework dependencies
2. **Business Logic Layer**: Controllers implement interfaces and contain mutation logic
3. **Frontend Layer**: UI components are "dumb" - they receive data and callbacks, but don't know about business logic

### Controller Interface Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                   Interface Definition                       │
│                controller_interfaces.dart                    │
│                                                              │
│   abstract class IUpController {                            │
│     void increment();                                       │
│     AppModel get model;                                     │
│   }                                                          │
└─────────────────────────────────────────────────────────────┘
          ▲                                    ▲
          │                                    │
    implements                            depends on
          │                                    │
┌─────────────────────────┐      ┌─────────────────────────────┐
│  business_logic_        │      │       ui_pages.dart          │
│  controllers.dart       │      │                              │
│                         │      │  CounterUpView requires      │
│  UpController           │      │  IUpController, not          │
│  - increment()          │      │  UpController directly       │
│  - model getter         │      │                              │
└─────────────────────────┘      └─────────────────────────────┘
```

This enables:
- **Testability**: Pages can be tested with mock controllers
- **Flexibility**: Controller implementations can change without affecting UI
- **Decoupling**: Frontend and backend can evolve independently

### State Management Strategy

The app uses **ValueNotifier + ValueListenableBuilder** for reactive state:

```
┌────────────────┐        ┌────────────────┐        ┌────────────────┐
│ ValueNotifier  │        │ Controller     │        │ ValueListenable│
│ <AppModel>     │◄───────│ onModelChanged │◄───────│ Builder        │
│                │ notify │                │ calls  │                │
│ Holds state    │        │ Mutates model  │        │ Rebuilds UI    │
└────────────────┘        └────────────────┘        └────────────────┘
```

---

## Data Flow

### Unidirectional Data Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          DATA FLOW CYCLE                                 │
│                                                                          │
│   ┌─────────────┐                                                       │
│   │ User Action │ (tap button)                                          │
│   └──────┬──────┘                                                       │
│          │                                                               │
│          ▼                                                               │
│   ┌─────────────────┐                                                   │
│   │ Widget calls    │  widget → onPlus/onMinus callback                 │
│   │ callback        │                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ Page calls      │  page → controller.increment()/decrement()        │
│   │ controller      │                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ Controller      │  controller → model.copyWith(counter: newValue)   │
│   │ mutates model   │                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ onModelChanged  │  controller → onModelChanged(newModel)            │
│   │ callback        │                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ ValueNotifier   │  router.onModelChanged → modelNotifier.value = x  │
│   │ updated         │                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ ValueListenable │  ValueListenableBuilder rebuilds with new model   │
│   │ Builder rebuilds│                                                    │
│   └────────┬────────┘                                                   │
│            │                                                             │
│            ▼                                                             │
│   ┌─────────────────┐                                                   │
│   │ UI reflects     │  Page receives new controller with updated model  │
│   │ new state       │                                                    │
│   └─────────────────┘                                                   │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Example: Increment Flow

```
User taps "+" button
       │
       ▼
PlusMinusFloatingActionButton.onPressed → onPlus()
       │
       ▼
CounterUpView passed onPlus: controller.increment
       │
       ▼
UpController.increment():
  - newValue = model.copyWith(counter: model.counter + 1)
  - onModelChanged(newValue)
       │
       ▼
AppRouter.onModelChanged(model):
  - modelNotifier.value = model
       │
       ▼
ValueListenableBuilder detects change
       │
       ▼
Rebuilds CounterUpView with new UpController(model: newModel, ...)
       │
       ▼
CenteredValue displays updated counter
```

---

## Backend Deep Dive

### File: `domain_model.dart`

**Location:** `lib/backend/domain_model.dart`

**Purpose:** Defines the application's domain state representation.

**Key Concepts:**
- **No dependencies**: This file imports nothing, ensuring complete isolation
- **Immutability**: `AppModel` is immutable; changes create new instances
- **copyWith pattern**: Standard Dart pattern for creating modified copies

**Class: AppModel**

| Property | Type | Description |
|----------|------|-------------|
| `counter` | `int` | The single piece of state representing the counter value |

| Method | Signature | Description |
|--------|-----------|-------------|
| `copyWith` | `AppModel copyWith({int? counter})` | Creates a new instance with optionally modified values |

**Domain Extensibility:**
```
Current:              Future (example):
┌────────────┐        ┌────────────────────────────┐
│ AppModel   │        │ AppModel                   │
│ - counter  │   →    │ - counter                  │
└────────────┘        │ - user: UserModel?         │
                      │ - settings: SettingsModel? │
                      └────────────────────────────┘
```

### File: `business_logic_controllers.dart`

**Location:** `lib/backend/business_logic_controllers.dart`

**Purpose:** Contains business logic for state mutations.

**Dependencies:**
- `domain_model.dart` - for `AppModel`
- `../frontend/controller_interfaces.dart` - for interface contracts

**Key Design Decisions:**
- Controllers are **single-purpose**: `UpController` only increments, `DownController` only decrements
- Controllers are **decoupled from state management**: They use a callback (`ModelChangedCallback`) rather than directly updating any state holder
- Controllers **hold a snapshot** of the model, not a reference to the ValueNotifier

**Type: ModelChangedCallback**
```dart
typedef ModelChangedCallback = void Function(AppModel model);
```

**Class: UpController**

| Property | Type | Description |
|----------|------|-------------|
| `model` | `AppModel` | Current model snapshot (from interface) |
| `onModelChanged` | `ModelChangedCallback` | Callback to notify of model changes |

| Method | Description |
|--------|-------------|
| `increment()` | Creates new model with `counter + 1`, calls `onModelChanged` |

**Class: DownController**

| Property | Type | Description |
|----------|------|-------------|
| `model` | `AppModel` | Current model snapshot (from interface) |
| `onModelChanged` | `ModelChangedCallback` | Callback to notify of model changes |

| Method | Description |
|--------|-------------|
| `decrement()` | Creates new model with `counter - 1`, calls `onModelChanged` |

**Controller Creation Flow:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONTROLLER LIFECYCLE                                  │
│                                                                          │
│  On each ValueNotifier change:                                          │
│                                                                          │
│    1. ValueListenableBuilder.builder is called                          │
│                                                                          │
│    2. New controller is created:                                        │
│       UpController(                                                      │
│         model: modelNotifier.value,        // current model snapshot    │
│         onModelChanged: onModelChanged     // callback to router        │
│       )                                                                  │
│                                                                          │
│    3. Controller is injected into Page:                                 │
│       CounterUpView(controller: newController)                          │
│                                                                          │
│  Note: Controllers are recreated on every rebuild. They are             │
│        lightweight and don't hold heavy resources.                       │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Pages Deep Dive

### File: `ui_pages.dart`

**Location:** `lib/frontend/ui_pages.dart`

**Purpose:** Defines the main screen-level widgets (views/pages) of the application.

**Dependencies:**
- `flutter/material.dart` - Flutter UI framework
- `go_router` - For navigation (`context.go`)
- `controller_interfaces.dart` - Abstract controller contracts
- `ui_widgets.dart` - Reusable widget components

**Key Design Principles:**
1. **Stateless**: Pages derive all content from the injected controller's model
2. **Composition**: Pages compose smaller widgets into full screens
3. **Data passing**: Pages extract specific data from model to pass to widgets
4. **Interface dependency**: Pages depend on `IUpController`/`IDownController`, not concrete implementations
5. **No direct theme access**: Pages delegate theme handling to child widgets

---

### Page: `CounterUpView`

**Role:** Main page for incrementing the counter value.

**State Management:**
- Receives `IUpController` via constructor injection
- Controller contains current `AppModel` snapshot
- Page is rebuilt when `ValueListenableBuilder` in router detects model changes

**Widget Composition:**

```
┌─────────────────────────────────────────────────────────────┐
│                    CounterUpView                             │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Scaffold                                                │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ appBar: BackForthAppBar                          │  │ │
│  │  │   onBack: → context.go('/down')                  │  │ │
│  │  │   onForth: → context.go('/up')                   │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ body: CenteredValue                              │  │ │
│  │  │   value: controller.model.counter                │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ floatingActionButton: PlusMinusFloatingActionBtn │  │ │
│  │  │   onPlus: controller.increment                   │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Controller Interaction:**
- **Data extraction**: `controller.model.counter` → passed to `CenteredValue`
- **Action binding**: `controller.increment` → passed to `PlusMinusFloatingActionButton.onPlus`

**Navigation:**
- Back arrow navigates to `/down` (CounterDownView)
- Forward arrow navigates to `/up` (stays on current page)

---

### Page: `CounterDownView`

**Role:** Main page for decrementing the counter value.

**State Management:**
- Receives `IDownController` via constructor injection
- Controller contains current `AppModel` snapshot
- Page is rebuilt when `ValueListenableBuilder` in router detects model changes

**Widget Composition:**

```
┌─────────────────────────────────────────────────────────────┐
│                    CounterDownView                           │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Scaffold                                                │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ appBar: BackForthAppBar                          │  │ │
│  │  │   onBack: → context.go('/up')                    │  │ │
│  │  │   onForth: → context.go('/down')                 │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ body: CenteredValue                              │  │ │
│  │  │   value: controller.model.counter                │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │ floatingActionButton: PlusMinusFloatingActionBtn │  │ │
│  │  │   onMinus: controller.decrement                  │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  │                                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Controller Interaction:**
- **Data extraction**: `controller.model.counter` → passed to `CenteredValue`
- **Action binding**: `controller.decrement` → passed to `PlusMinusFloatingActionButton.onMinus`

**Navigation:**
- Back arrow navigates to `/up` (CounterUpView)
- Forward arrow navigates to `/down` (stays on current page)

---

### Page Architecture Pattern

Both pages follow an identical structural pattern:

```
┌───────────────────────────────────────────────────────────────────────┐
│                     PAGE ARCHITECTURE PATTERN                          │
│                                                                        │
│   Input: Controller (via constructor)                                  │
│   ┌────────────────────────────────────────────────────────────────┐  │
│   │ IController controller                                          │  │
│   │   - model: AppModel (read-only state)                           │  │
│   │   - action(): void (mutation method)                            │  │
│   └────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│   Output: Scaffold with composed widgets                               │
│   ┌────────────────────────────────────────────────────────────────┐  │
│   │ return Scaffold(                                                │  │
│   │   appBar: NavigationWidget(callbacks),                          │  │
│   │   body: DisplayWidget(controller.model.data),                   │  │
│   │   floatingActionButton: ActionWidget(controller.action),        │  │
│   │ );                                                              │  │
│   └────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│   Principles:                                                          │
│   - Pass primitives/data to display widgets, not entire model         │
│   - Pass method references to action widgets, not entire controller   │
│   - Navigation is handled via go_router (context.go)                  │
│                                                                        │
└───────────────────────────────────────────────────────────────────────┘
```

---

## Widgets and Shared UI Deep Dive

### File: `ui_widgets.dart`

**Location:** `lib/frontend/ui_widgets.dart`

**Purpose:** Contains reusable, "dumb" UI components with no business logic knowledge.

**Dependencies:**
- `flutter/material.dart` - Flutter UI framework only

**Design Philosophy:**
- Widgets are **presentation-only**: display data, trigger callbacks
- **No domain knowledge**: widgets don't know about `AppModel` or controllers
- **Theme access via context**: widgets retrieve theme data from `BuildContext` as needed
- **Maximum reusability**: widgets can be used anywhere with appropriate data/callbacks

---

### Widget: `CenteredValue`

**Purpose:** Displays an integer value centered on screen.

**Component Responsibilities:**
- Render text showing the provided integer value
- Center the text within its parent

**API:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `value` | `int` | Yes | The integer value to display |

**Data Flow:**
```
CenteredValue(value: 42)
       │
       ▼
Center(child: Text('Value: 42'))
```

**Reuse Pattern:**
- Used by both `CounterUpView` and `CounterDownView`
- Can display any integer value, not coupled to counter concept

**Separation of Concerns:**
- Widget only knows about `int` - not `AppModel.counter`
- Parent page extracts `controller.model.counter` and passes as `int`

---

### Widget: `BackForthAppBar`

**Purpose:** Navigation app bar with back/forward buttons.

**Component Responsibilities:**
- Display back arrow button (navigates backward)
- Display forward arrow button (navigates forward)
- Implement `PreferredSizeWidget` for Scaffold compatibility

**API:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onBack` | `VoidCallback` | Yes | Called when back button is pressed |
| `onForth` | `VoidCallback` | Yes | Called when forward button is pressed |

**Event Flow:**
```
┌─────────────────────────────────────────────────────────────┐
│ BackForthAppBar                                              │
│                                                              │
│   [←] onBack        [→] onForth                             │
│    │                   │                                     │
│    ▼                   ▼                                     │
│  IconButton         IconButton                               │
│  onPressed:         onPressed:                               │
│  onBack             onForth                                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Reuse Pattern:**
- Generic navigation component - callbacks determine actual navigation
- Used with different routes in `CounterUpView` vs `CounterDownView`

**Widget Structure:**
```dart
AppBar(
  actions: [
    IconButton(icon: Icons.arrow_back, onPressed: onBack),
    IconButton(icon: Icons.arrow_forward, onPressed: onForth),
  ],
)
```

**Separation of Concerns:**
- Widget doesn't know about routes (`/up`, `/down`)
- Parent pages provide navigation callbacks: `() => context.go('/route')`

---

### Widget: `PlusMinusFloatingActionButton`

**Purpose:** Floating action button that can increment or decrement.

**Component Responsibilities:**
- Display a single FAB with either + or - icon
- Execute the appropriate callback when pressed
- Dynamically show + icon when `onPlus` provided, - icon when `onMinus` provided

**API:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `onPlus` | `VoidCallback?` | No | Called when + button is pressed |
| `onMinus` | `VoidCallback?` | No | Called when - button is pressed |

**Behavior Logic:**
```
┌─────────────────────────────────────────────────────────────┐
│ PlusMinusFloatingActionButton                                │
│                                                              │
│   if onPlus != null:                                        │
│     icon = Icons.add                                        │
│     onPressed = onPlus                                      │
│   else:                                                      │
│     icon = Icons.remove                                     │
│     onPressed = onMinus                                     │
│                                                              │
│   FloatingActionButton(                                      │
│     onPressed: onPlus ?? onMinus,                           │
│     child: Icon(onPlus != null ? Icons.add : Icons.remove), │
│   )                                                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**Reuse Pattern:**
- `CounterUpView`: `PlusMinusFloatingActionButton(onPlus: controller.increment)`
- `CounterDownView`: `PlusMinusFloatingActionButton(onMinus: controller.decrement)`

**Separation of Concerns:**
- Widget doesn't know about controllers or increment/decrement logic
- Simply triggers the provided callback on press
- Icon choice is API-driven (presence of `onPlus` vs `onMinus`)

---

### Widget Reuse Matrix

| Widget | CounterUpView | CounterDownView | Notes |
|--------|---------------|-----------------|-------|
| `CenteredValue` | ✓ (displays counter) | ✓ (displays counter) | Same usage |
| `BackForthAppBar` | ✓ (back→down, forth→up) | ✓ (back→up, forth→down) | Different routes |
| `PlusMinusFloatingActionButton` | ✓ (onPlus) | ✓ (onMinus) | Different callbacks |

---

## App Entry Point

### File: `main.dart`

**Location:** `lib/main.dart`

**Purpose:** Application entry point - initializes state container, router, and launches the app.

**Dependencies:**
- `flutter/material.dart` - Flutter framework
- `backend/domain_model.dart` - For `AppModel`
- `frontend/router.dart` - For `AppRouter`

**Bootstrap Sequence:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        APPLICATION BOOTSTRAP                             │
│                                                                          │
│   main() {                                                               │
│                                                                          │
│     1. Create state container:                                           │
│        ┌──────────────────────────────────────────────────────────────┐ │
│        │ valueListenable = ValueNotifier(AppModel(0))                 │ │
│        │                                                               │ │
│        │ • Initial counter value: 0                                   │ │
│        │ • ValueNotifier provides change notification                 │ │
│        └──────────────────────────────────────────────────────────────┘ │
│                               │                                          │
│                               ▼                                          │
│     2. Create router with state reference:                               │
│        ┌──────────────────────────────────────────────────────────────┐ │
│        │ router = AppRouter(valueListenable)                          │ │
│        │                                                               │ │
│        │ • Router stores reference to state notifier                  │ │
│        │ • Sets up routes and ValueListenableBuilders                 │ │
│        │ • Provides onModelChanged callback to controllers            │ │
│        └──────────────────────────────────────────────────────────────┘ │
│                               │                                          │
│                               ▼                                          │
│     3. Run app with dependencies:                                        │
│        ┌──────────────────────────────────────────────────────────────┐ │
│        │ runApp(MyApp(valueListenable, router))                       │ │
│        │                                                               │ │
│        │ • MyApp receives both state and router                       │ │
│        │ • Uses MaterialApp.router with router config                 │ │
│        └──────────────────────────────────────────────────────────────┘ │
│                                                                          │
│   }                                                                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

**Class: MyApp**

| Property | Type | Description |
|----------|------|-------------|
| `valueListenable` | `ValueNotifier<AppModel>` | Application state container |
| `router` | `AppRouter` | Navigation and DI coordinator |

**Widget Tree Root:**
```dart
MaterialApp.router(
  routerConfig: router.config,  // GoRouter configuration
)
```

**Design Notes:**
- `main()` acts as the **composition root** - creates and wires dependencies
- `MyApp` is a thin wrapper that configures `MaterialApp` with the router
- State (`ValueNotifier`) is created at the highest level, passed down via router

---

## Cross-cutting Architecture

### Dependency Injection

The application uses **manual constructor injection** without a DI framework:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DEPENDENCY INJECTION FLOW                             │
│                                                                          │
│   main.dart (Composition Root)                                          │
│      │                                                                   │
│      │ creates                                                           │
│      ▼                                                                   │
│   ValueNotifier<AppModel>  ─────────────────┐                           │
│      │                                       │                           │
│      │ passed to                             │                           │
│      ▼                                       │                           │
│   AppRouter ─────────────────────────────────┤                           │
│      │                                       │                           │
│      │ creates on each route build           │                           │
│      ▼                                       ▼                           │
│   UpController / DownController     ValueListenableBuilder              │
│      │                                       │                           │
│      │ injected into                         │ rebuilds                  │
│      ▼                                       ▼                           │
│   CounterUpView / CounterDownView ◄──────────┘                          │
│      │                                                                   │
│      │ passes data/callbacks to                                          │
│      ▼                                                                   │
│   Widgets (CenteredValue, BackForthAppBar, etc.)                        │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Navigation Architecture

Uses **go_router** for declarative navigation:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        NAVIGATION STRUCTURE                              │
│                                                                          │
│   GoRouter                                                               │
│   ├── initialLocation: '/up'                                            │
│   │                                                                      │
│   └── routes:                                                            │
│       ├── GoRoute(path: '/up')                                          │
│       │   └── builder → ValueListenableBuilder → CounterUpView          │
│       │                                                                  │
│       └── GoRoute(path: '/down')                                        │
│           └── builder → ValueListenableBuilder → CounterDownView        │
│                                                                          │
│   Navigation Methods:                                                    │
│   - context.go('/up')   - Navigate to up page                           │
│   - context.go('/down') - Navigate to down page                         │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### State Management Pattern

**ValueNotifier + ValueListenableBuilder Pattern:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     STATE MANAGEMENT PATTERN                             │
│                                                                          │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ ValueNotifier<AppModel>                                          │   │
│   │                                                                  │   │
│   │ • Single source of truth for app state                          │   │
│   │ • Created in main.dart                                           │   │
│   │ • Notifies listeners when .value changes                        │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                               │                                          │
│                     notifies on change                                   │
│                               ▼                                          │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ ValueListenableBuilder                                           │   │
│   │                                                                  │   │
│   │ • Wraps route builders in router.dart                           │   │
│   │ • Rebuilds child widget when valueListenable changes            │   │
│   │ • Creates fresh controller with current model snapshot          │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                               │                                          │
│                           rebuilds                                       │
│                               ▼                                          │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ Page (CounterUpView / CounterDownView)                          │   │
│   │                                                                  │   │
│   │ • Receives new controller instance                               │   │
│   │ • Renders UI based on controller.model                          │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│   Trade-offs:                                                            │
│   ✓ Simple, no external dependencies beyond Flutter                     │
│   ✓ Clear data flow                                                     │
│   ✗ All pages rebuild on any state change                               │
│   ✗ No fine-grained reactivity                                          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Import Graph

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        IMPORT DEPENDENCY GRAPH                           │
│                                                                          │
│                         domain_model.dart                                │
│                        (no dependencies)                                 │
│                               ▲                                          │
│              ┌────────────────┼────────────────┐                        │
│              │                │                │                        │
│   controller_interfaces    business_logic    main.dart                  │
│         .dart              _controllers.dart                            │
│              ▲                │                                          │
│              │                │ (implements)                             │
│              │                │                                          │
│              └────────────────┘                                          │
│              ▲                                                           │
│              │                                                           │
│   ┌──────────┴──────────┐                                               │
│   │                     │                                               │
│   ui_pages.dart     router.dart ◄───────── main.dart                    │
│        │                 │                                               │
│        │                 │                                               │
│        ▼                 │                                               │
│   ui_widgets.dart        │                                               │
│   (flutter only)         │                                               │
│                          │                                               │
│                          ▼                                               │
│               business_logic_controllers.dart                            │
│                          │                                               │
│                          ▼                                               │
│                   ui_pages.dart                                          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Extensibility Points

The architecture provides clear extension points:

| Extension | Where to Add | Existing Pattern to Follow |
|-----------|--------------|---------------------------|
| New domain data | `domain_model.dart` | Add properties to `AppModel`, update `copyWith` |
| New business logic | `business_logic_controllers.dart` | Create new controller implementing a new interface |
| New controller interface | `controller_interfaces.dart` | Add abstract class with required methods |
| New page | `ui_pages.dart` | Create `StatelessWidget` taking interface-typed controller |
| New route | `router.dart` | Add `GoRoute` with `ValueListenableBuilder` pattern |
| New widget | `ui_widgets.dart` | Create stateless widget with primitive props/callbacks |

---

## Summary

### Architecture Overview

This Flutter application demonstrates a **clean layered architecture** with:

1. **Clear Layer Separation**: Backend (domain + business logic) and Frontend (UI + navigation) are cleanly separated
2. **Dependency Inversion**: UI depends on interfaces, not concrete implementations
3. **Unidirectional Data Flow**: State flows down via controllers, events flow up via callbacks
4. **Single Source of Truth**: `ValueNotifier<AppModel>` holds all application state

### File Summary

| File | Layer | Responsibility |
|------|-------|----------------|
| `main.dart` | Entry Point | Bootstrap, composition root |
| `domain_model.dart` | Domain | Immutable state definition |
| `business_logic_controllers.dart` | Business Logic | State mutation logic |
| `controller_interfaces.dart` | Interface | Frontend-backend contracts |
| `router.dart` | Frontend | Navigation, DI, reactivity |
| `ui_pages.dart` | Frontend | Screen composition |
| `ui_widgets.dart` | Frontend | Reusable UI components |

### Key Design Patterns

1. **Immutable State**: `AppModel` with `copyWith` pattern
2. **Interface Segregation**: Separate interfaces for up/down controllers
3. **Callback-based Notification**: Controllers use `ModelChangedCallback`
4. **Manual Dependency Injection**: Constructor injection via router
5. **ValueNotifier Reactivity**: Built-in Flutter state management

### Benefits of This Architecture

- **Testability**: Each layer can be tested in isolation
- **Maintainability**: Clear boundaries make code easier to understand
- **Flexibility**: Implementations can change without affecting dependent code
- **Scalability**: Pattern can extend to larger applications

### Areas for Future Enhancement

1. **Fine-grained Reactivity**: Only rebuild widgets that depend on changed state
2. **Async Operations**: Add repository layer for API/database calls
3. **Error Handling**: Add error state to domain model
4. **Deep Linking**: Extend router for URL-based navigation
5. **Testing Infrastructure**: Add unit and widget tests