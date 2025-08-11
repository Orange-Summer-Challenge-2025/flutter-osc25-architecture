# OSC Flutter Architecture Template

A scalable Flutter architecture you can follow in any project. This repo demonstrates the structure, patterns, and conventions. You can clone it or replicate the architecture in your own app.

## Highlights

- **Feature-first structure** with clear separation of concerns
- **Clean Architecture** style layers: data → domain → presentation
- **GetX** for routing, DI, and lightweight state management
- **Dio** for networking with centralized `NetworkClient`
- **Dartz** `Either` for success/failure flows
- **Shared core**: theme, logger, storage, config, and common assets

## Layer Overview

This architecture is divided into three main layers, each with a specific responsibility:

- **Data Layer**: Responsible for handling data operations such as API calls, local storage, and data transformation. It includes data sources (remote and local) and models for requests and responses.
- **Domain Layer**: Contains the business logic of the application. It acts as a bridge between the data and presentation layers. This layer includes repositories and domain-specific models.
- **Presentation Layer**: Manages the user interface and user interactions. It includes controllers for state management, screens for UI, and widgets for reusable components.

## Directory Structure

```
lib/
├── core/                      # Shared code
│   ├── app_config.dart        # Environments (Base URLs)
│   ├── data/
│   │   ├── local_storage.dart
│   │   ├── local_storage.keys.dart
│   │   └── network_client.dart
│   ├── design_system/         # Theme, extensions, design assets
│   └── utils/logger.dart
├── features/                  # Feature modules
│   ├── splash/
│   │   └── presentation/
│   │       └── screen/splash_screen.dart
│   └── authentication/
│       ├── data/
│       │   ├── datasources/remote/auth_data_source.dart
│       │   └── models/
│       │       ├── request/login_request.dart
│       │       └── response/{login_success_response.dart, login_failure_response.dart}
│       ├── domain/auth_repository.dart
│       └── presentation/
│           ├── controller/auth_controller.dart
│           ├── screens/login_screen.dart
│           └── widgets/login_form.dart
├── routing/
│   ├── router.dart            # GetX pages
│   └── routes.dart            # Route name constants
├── di.dart                    # Global dependency injection
└── main.dart                  # App entry point
```

## App Flow

- `main.dart` sets up `GetMaterialApp`, localization, routes, and `DI` bindings.
- `di.dart` registers singletons: `AppConfig`, `LocalStorage`, `NetworkClient`.
- `NetworkClient` centralizes all HTTP via `Dio`, logs requests/responses, and injects auth headers from `LocalStorage` when needed.
- `design_system/` provides a centralized location for managing the app's visual identity, including themes, extensions, and reusable design assets such as colors, typography, and spacing. This ensures consistency across the app's UI.
- Features organize UI (`presentation`), orchestration (`controller`), business logic (`domain`), and data access (`data`).

## How to Use This Architecture in Your Own Project

You do not need to clone this repo; follow the structure and steps below to add features consistently.

### 1) Create feature folders

Under `lib/features/your_feature/`:

```
lib/
├── features/your_feature/       # Feature module
│   ├── data/                    # Data layer
│   │   ├── datasources/
│   │   │   ├── remote/your_feature_remote_data_source.dart
│   │   │   └── local/your_feature_local_data_source.dart
│   │   ├── models/              # Models
│   │   │   ├── request/your_request.dart
│   │   │   └── response/
│   │   │       ├── your_success_response.dart
│   │   │       └── your_failure_response.dart
│   ├── domain/                  # Domain layer
│   │   ├── your_feature_repository.dart
│   │   └── models/your_domain_model.dart
│   ├── presentation/            # Presentation layer
│       ├── controller/your_feature_controller.dart
│       ├── screens/your_feature_screen.dart
│       └── widgets/
│           ├── widget1.dart
│           └── widget2.dart
```

### 2) Data layer

- Implement models with `fromJson/toJson`.
- Use `Get.find<NetworkClient>()` for HTTP.
- Return `Either<FailureResponse, SuccessResponse>` from data sources.

Example (remote data source):

```dart
class YourFeatureRemoteDataSource {
  final _client = Get.find<NetworkClient>();

  Future<Either<YourFailureResponse, YourSuccessResponse>> doSomething(
    Map<String, dynamic> payload,
  ) async {
    try {
      final res = await _client.postRequest(
        'api/.../your-feature',
        payload,
        requiresAuthentication: true,
      );
      if (res.statusCode == 200) {
        return Right(YourSuccessResponse.fromJson(res.data));
      }
      return Left(YourFailureResponse.fromJson(res.data));
    } catch (_) {
      return Left(YourFailureResponse(message: 'unexpected_error'));
    }
  }
}
```

### 3) Domain layer

- Keep business logic here. Delegate to the data layer.

```dart
class YourFeatureRepository {
  final YourFeatureRemoteDataSource _remote;
  YourFeatureRepository(this._remote);

  Future<Either<YourFailureResponse, YourSuccessResponse>> doSomething(
    Map<String, dynamic> payload,
  ) {
    return _remote.doSomething(payload);
  }
}
```

### 4) Presentation layer

- `GetxController` manages state and calls the repository.

```dart
class YourFeatureController extends GetxController {
  final YourFeatureRepository _repo;
  YourFeatureController(this._repo);

  final isLoading = false.obs;
  final resultMessage = ''.obs;

  Future<void> runAction(Map<String, dynamic> payload) async {
    isLoading.value = true;
    final res = await _repo.doSomething(payload);
    isLoading.value = false;

    res.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (success) => resultMessage.value = success.toString(),
    );
  }
}
```

- Screens and widgets consume controller state.

```dart
class YourFeatureScreen extends StatelessWidget {
  const YourFeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(
      YourFeatureController(
        YourFeatureRepository(YourFeatureRemoteDataSource()),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Your Feature')),
      body: const Center(child: Text('Build UI using controller state')),
    );
  }
}
```

### 5) Routing

- Add a route in `routing/routes.dart`:

```dart
abstract final class Routes {
  static const yourFeature = '/your-feature';
}
```

- Register page in `routing/router.dart`:

```dart
final routes = [
  GetPage(name: Routes.yourFeature, page: () => const YourFeatureScreen()),
];
```

- Optional: Use a Binding per route for cleaner DI:

```dart
class YourFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(YourFeatureController(YourFeatureRepository(YourFeatureRemoteDataSource())));
  }
}
```

Then:

```dart
GetPage(
  name: Routes.yourFeature,
  page: () => const YourFeatureScreen(),
  binding: YourFeatureBinding(),
)
```

## Configuration & Environments

- `lib/core/app_config.dart` defines `DevConfiguration` and `ProdConfiguration` with `baseUrl`.
- `lib/di.dart` registers the active `AppConfig`. Switch to `ProdConfiguration` for production.

## Networking

- `lib/core/data/network_client.dart` wraps `Dio` with:
  - Base URL from `AppConfig`
  - Timeouts and common headers
  - Logging via `AppLogger`
  - Optional `Authorization` header when `requiresAuthentication` is true, fetching token from `LocalStorage` with `StringKey.tokenKey`.

## Local Storage

- `lib/core/data/local_storage.dart` wraps `SharedPreferences` for simple persistence.
- Set a token key in `lib/core/data/local_storage.keys.dart` (e.g. `StringKey.tokenKey = 'authToken';`).

## Logging

- `lib/core/utils/logger.dart` exposes `AppLogger.debug|info|warning|error|fatal`.

## Internationalization

Follow these steps to set up internationalization in your Flutter app:

1. **Add ARB Files**:

   - Create ARB files for each language under `lib/l10n/arb/`.
   - Example: `app_en.arb` for English, `app_es.arb` for Spanish.
   - Define key-value pairs for localized strings in each ARB file.

2. **Generate Localization Code**:

   - Run the Flutter localization tool to generate Dart localization files:
     ```bash
     flutter gen-l10n
     ```
   - This will create a `AppLocalizations` class in `lib/l10n/`.

3. **Configure `main.dart`**:

   - Add localization delegates and supported locales:

     ```dart
     import 'package:flutter_localizations/flutter_localizations.dart';
     import 'package:your_app/l10n/app_localizations.dart';

     void main() {
       runApp(MyApp());
     }

     class MyApp extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return MaterialApp(
           localizationsDelegates: [
             AppLocalizations.delegate,
             GlobalMaterialLocalizations.delegate,
             GlobalWidgetsLocalizations.delegate,
             GlobalCupertinoLocalizations.delegate,
           ],
           supportedLocales: [
             const Locale('en', ''), // English
             const Locale('es', ''), // Spanish
           ],
           home: MyHomePage(),
         );
       }
     }
     ```

4. **Access Localized Strings**:

   - Use the `AppLocalizations` class to access localized strings in your widgets:

     ```dart
     import 'package:your_app/l10n/app_localizations.dart';

     class MyHomePage extends StatelessWidget {
       @override
       Widget build(BuildContext context) {
         return Scaffold(
           appBar: AppBar(
             title: Text(AppLocalizations.of(context)!.title),
           ),
           body: Center(
             child: Text(AppLocalizations.of(context)!.welcomeMessage),
           ),
         );
       }
     }
     ```

5. **Test Localization**:
   - Change the device language or use the `locale` property in `MaterialApp` to test different languages:
     ```dart
     locale: const Locale('es', ''), // Spanish
     ```

## Splash

- Minimal splash in `features/splash/presentation/screen/splash_screen.dart` that navigates to login after a delay. Replace with your own logic (e.g., token check).

## Dependencies

Key packages used:

- get
- dio
- logger
- dartz
- shared_preferences

Check `pubspec.yaml` for exact versions.

## Conventions

- Keep feature modules self-contained.
- Prefer `Either` for error handling.
- Keep UI dumb; move orchestration to controllers and domain into repositories.
- Place cross-cutting concerns in `lib/core/`.

## Naming Conventions

Follow these naming conventions to maintain consistency across the project:

### Folder and File Naming

- **Data Layer**:

  - Folder names: Use lowercase (e.g., `datasources`, `models`).
  - File names: Use lowercase with underscores (e.g., `auth_data_source.dart`, `login_request.dart`).

- **Domain Layer**:

  - File names: Use lowercase with underscores (e.g., `auth_repository.dart`, `user_domain_model.dart`).

- **Presentation Layer**:
  - Folder names: Use lowercase with underscores (e.g., `controllers`, `screens`, `widgets`).
  - File names: Use lowercase with underscores (e.g., `auth_controller.dart`, `login_screen.dart`, `login_form.dart`).

### Variable Naming

- Use `camelCase` for variable and method names (e.g., `userName`, `fetchData`).
- Use `PascalCase` for class names (e.g., `AuthController`, `LoginRequest`).
- Use `SCREAMING_SNAKE_CASE` for constants (e.g., `API_BASE_URL`).

### General Guidelines

- Keep names descriptive and concise.
- Avoid abbreviations unless they are widely understood (e.g., `URL`, `ID`).
- Use singular names for classes and files unless the content is inherently plural (e.g., `User`, `UsersList`).
