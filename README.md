# Flutter Todo App

A Flutter Todo application demonstrating clean architecture, BLoC state management, offline-first behavior.

---

## Features

- Add, delete and toggle tasks
- Offline support with optimistic updates
- Automatic sync when internet is restored
- Rounded card UI
- Leading avatar with task initial
- Swipe to delete tasks
- Status indicator badge for completed / pending tasks
- Pending sync indicator for offline changes
- Pull to refresh
- Mock login with persistent session
- Logout with snackbar feedback
- Clean layered architecture
- Unit tests for core logic

---

## Setup Instructions
1. Clone repository
2. Run `flutter pub get`
3. Run `flutter run`

---

## Architecture

The project follows a layered architecture with clear separation of concerns:

### Presentation (UI + BLoC)
Responsible for user interface and state management. Widgets dispatch events to BLoC and rebuild based on emitted states.

### Domain (Entities + Repositories)
Contains business entities and abstract contracts. This layer is independent of frameworks and external services.

### Data (Remote API + Local cache)
Implements the repository contracts using concrete data sources such as REST APIs and local storage.

### Core (Infrastructure services)
Provides cross-cutting technical services such as networking, connectivity monitoring, persistence, and authentication helpers.

---

## Offline Strategy

- All tasks are cached locally using Hive.
- When offline, tasks are stored locally with a `pendingSync` flag.
- When connectivity is restored, pending tasks are synced automatically.
- Local and remote tasks are merged to prevent data loss.

---

## API

Uses the public JSONPlaceholder API:

- GET /todos
- POST /todos
- PATCH /todos/{id}
- DELETE /todos/{id}

Note: JSONPlaceholder does not persist writes.

---

## Authentication

Mock login credentials:

- Username: admin
- Password: 1234

Login state is persisted using SharedPreferences so the user remains logged in across app restarts.

---

## Testing

Includes unit tests for:

- TaskBloc event-to-state behavior
- Repository online/offline logic

Run tests using:

```bash
flutter test
