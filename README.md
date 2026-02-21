# Flutter Shopping App Demo

A minimal Flutter shopping app demo that uses the FakeStore API to display products and manage a simple cart. Built as a learning/demo project.

## Features

- List products fetched from an external API
- Product details view
- Add/remove items to cart with simple quantity handling
- Basic authentication screens (login/register UI)
- Responsive for mobile and web screens

## Tech stack

- Flutter
- Dart
- Dio HTTP client
- FakeStoreAPI (https://fakestoreapi.com)

## Getting started

Prerequisites:

- Flutter SDK (stable) installed. See https://flutter.dev/docs/get-started/install
- An editor (VS Code, Android Studio) and desired platform toolchains (Android/iOS/web)

Clone the repo and fetch dependencies:

```bash
git clone https://github.com/AjaxxIsHere/Flutter-shopping-app-demo.git
cd Flutter-shopping-app-demo/cart_site
flutter pub get
```

Run the app (example targets):

- Run on connected Android device or emulator:

```bash
flutter run -d android
```

- Run on Chrome (web):

```bash
flutter run -d chrome
```

## Configuration / API

This project uses the FakeStore API. The base URL is configured in the `ApiClient` class (`lib/core/api_client.dart`) — by default it points to `https://fakestoreapi.com`.

If you need to point the app to a different API or a local mock, update the `baseUrl` in `lib/core/api_client.dart`.

## Development notes

- Logging: HTTP requests and responses are logged via `Dio`'s `LogInterceptor` (useful for debugging). Be sure to disable or reduce logging for production to avoid leaking sensitive data.
- State: The app uses simple provider-based state management located in `lib/providers`.
