# Flutter Todo App (BLoC + Offline Support)

## Features
- Task list with add, delete, complete
- Search and pull-to-refresh
- Offline caching with optimistic updates
- Sync with server when online
- BLoC architecture
- Mock authentication

## Setup Instructions
1. Clone repository
2. Run `flutter pub get`
3. Run `flutter run`

## Architecture
The app follows a layered architecture:
- Presentation: UI and BLoC
- Domain: Business logic and entities
- Data: API and local cache

BLoC handles user actions via events and emits states consumed by the UI.

## Offline Support
- Tasks are cached locally using Hive.
- When offline, operations are stored locally and marked for sync.
- When connectivity is restored, pending changes are synced with the API.

## API Integration
Uses JSONPlaceholder:
- GET /todos
- POST /todos
- PATCH /todos/{id}
- DELETE /todos/{id}

## Assumptions
- Authentication is mocked with hardcoded credentials.
- JSONPlaceholder does not persist writes; behavior is simulated.

## Challenges
- JSONPlaceholder not persisting data → handled by local cache.
- Sync conflicts → resolved by last-write-wins strategy.