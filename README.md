# Taskly Todo (Flutter MVC + GetX)

Premium-style Todo app starter using MVC separation, GetX and a centralized REST API layer.

## Setup
1. Run `flutter pub get`.
2. Run `flutter run`.

## Fake.REST API
Base URL:
`https://api.fake.rest/189bf93b-4d78-4f00-86ac-76d87cfccbd1`

- GET `task/list` — fetch tasks
- POST `task/add` — create a task
- POST `task/update` — update a task
- POST `task/delete` — delete a task

This Fake.REST example uses POST for add, update and delete, as described in the linked DEV.to article. The response templates are configured by the Fake.REST endpoint owner, so the service accepts common `data`, `task`, `tasks` and `result` response wrappers.

## Authentication
The Fake.REST endpoints in the article do not include login/signup. These screens use local demo validation only; they do not create real accounts or authenticate users.

## Structure
- `config`: centralized colors, theme, endpoints, constants and assets.
- `data/models`: request/response models.
- `data/services`: centralized ApiCaller and TodoApiService.
- `controllers`: GetX state and actions.
- `views`: screens and reusable widgets.
