# Teras POS

The platform delivers a clean and structured experience for authentication, dashboard monitoring, product management, sales transactions, transaction history, receipt preview, sales summary, report table view, CSV export simulation, application settings, and local-first business workflows.

Teras POS supports digital business operations by improving sales tracking, product visibility, transaction accuracy, stock awareness, reporting readiness, receipt preparation, operational efficiency, and overall cashier workflow experience.

---

## Key Features

| Feature             | Description                                                                                                                |
|---------------------|----------------------------------------------------------------------------------------------------------------------------|
| Splash Screen       | Displays the initial loading screen before navigating to the authentication flow or dashboard.                             |
| Authentication Flow | Supports login, registration, forgot password, and logout using a dummy/local authentication repository.                   |
| Dashboard           | Displays business overview, sales metrics, product summary, transaction shortcuts, and main POS navigation.                |
| Product Management  | Manages product list, add product, edit product, delete product, SKU validation, stock tracking, and product availability. |
| Sales Transaction   | Supports product selection, cart management, quantity validation, payment validation, and transaction creation.            |
| Transaction History | Displays sales transaction records with transaction amount, date, item count, and transaction status.                      |
| Transaction Detail  | Displays transaction items, payment summary, change amount, location metadata, and receipt preview.                        |
| Sales Report        | Provides sales summary, table view, total revenue, total transaction count, and product sales information.                 |
| Report Export       | Supports simple CSV export simulation for sales report download readiness.                                                 |
| Receipt Handling    | Provides receipt text preview and thermal-printer-ready abstraction through a simulated receipt service.                   |
| Location Metadata   | Provides GPS-ready abstraction through a simulated location service for transaction location information.                  |
| Settings            | Displays application configuration, backend mode, Firebase extension status, and application version information.          |
| Firebase Extension  | Prepares optional Firebase repository extension points without making Firebase required to run the application.            |

---

## Technology Stack

| Technology            |     Version | Purpose                                            |
|-----------------------|------------:|----------------------------------------------------|
| Flutter               |    `3.44.1` | Cross-platform mobile application framework.       |
| Dart                  |    `3.12.1` | Main programming language for Flutter development. |
| DevTools              |    `2.57.0` | Flutter development and debugging tools.           |
| Android SDK           |        `36` | Android compile and target SDK used by Flutter.    |
| Android Build Tools   |    `37.0.0` | Android SDK build tools installed locally.         |
| Android Emulator      |   `36.6.11` | Android virtual device runtime.                    |
| Java JDK              |   `17.0.19` | Java runtime used for Android build configuration. |
| Android Gradle Plugin |     `9.2.0` | Android build system plugin.                       |
| Kotlin                |    `2.3.21` | Android platform language and Gradle integration.  |
| Gradle Wrapper        |     `9.6.1` | Build automation and dependency management.        |
| JVM Target            |        `17` | Java compatibility target for Kotlin compilation.  |

---

## Project Dependencies

| Package             |   Version | Purpose                                      |
|---------------------|----------:|----------------------------------------------|
| `flutter_riverpod`  |   `3.3.2` | State management and dependency access.      |
| `go_router`         |  `17.3.0` | Declarative application routing.             |
| `flutter_lints`     |   `6.0.0` | Recommended Flutter linting rules.           |

---

## Build Configuration

The build configuration is aligned with the current Flutter, Android Gradle Plugin, Kotlin, and Gradle versions used by this project.

| File                        | Configuration                                   | Notes                                                                       |
|-----------------------------|-------------------------------------------------|-----------------------------------------------------------------------------|
| `settings.gradle.kts`       | `com.android.application` version `9.2.0`       | Android Gradle Plugin configured to version `9.2.0`.                        |
| `settings.gradle.kts`       | `org.jetbrains.kotlin.android` version `2.3.21` | Kotlin Android plugin configured to version `2.3.21`.                       |
| `gradle-wrapper.properties` | Gradle `9.6.1`                                  | Gradle wrapper uses `gradle-9.6.1-all.zip`.                                 |
| `build.gradle.kts`          | Android SDK versions                            | Uses Flutter SDK defaults: compile SDK `36`, target SDK `36`, min SDK `24`. |
| `build.gradle.kts`          | Android NDK version                             | Uses Flutter SDK default NDK `28.2.13676358`.                               |
| `build.gradle.kts`          | Java compatibility                              | Source and target compatibility configured to Java `17`.                    |
| `build.gradle.kts`          | Kotlin compiler DSL                             | Uses `compilerOptions` with JVM target `17`.                                |
| `gradle.properties`         | Flutter template Gradle flags                   | Keeps Flutter-generated Gradle configuration flags.                         |

### Kotlin Compiler DSL

The current Kotlin configuration:

```kotlin
kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
```
