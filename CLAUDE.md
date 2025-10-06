# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter teacher application with the following key characteristics:

**Current Version**: Flutter pubspec 1.1.0+1 | Android versionCode 19, versionName "2.9"

- **Architecture**: Feature-driven architecture with clean architecture principles in domain/data layers
- **State Management**: Primarily GetX (Get package) with minimal flutter_bloc usage in legacy screens
- **Routing**: GetX-based routing system with AppRoutes class
- **Localization**: Multi-language support (English, Arabic) with localization delegates
- **API**: Dio-based API service (ApiService class)
- **Navigation**: Bottom bar navigation with GetMaterialApp
- **Themes**: Custom Material3 theme with light/dark mode support
- **Internationalization**: RTL/LTR support based on language selection

## Key Dependencies

- **flutter_bloc**: ^9.0.0 (state management)
- **bloc**: ^9.0.0 (core bloc functionality)
- **dio**: ^5.8.0+1 (HTTP client)
- **get**: ^4.7.2 (navigation and utilities)
- **intl**: ^0.20.2 (internationalization)
- **shared_preferences**: ^2.5.3 (local storage)
- **build_runner**: ^2.4.14 (code generation)
- **url_launcher**: ^6.2.5 (external links)
- **permission_handler**: ^11.3.1 (device permissions)

## Project Structure

```
lib/
├── screens/              # Feature-based UI organization (PRIMARY)
├── domain/               # Domain layer (entities, use cases, models)
├── data/                 # Data layer (repositories, data sources)
├── services/             # Application services (API, app services)
├── models/               # Data models
├── navigation/           # GetX-based routing
├── localization/         # GetX translation system
├── themes/               # UI theming
├── utils/                # Utility functions
├── base/                 # Base classes and utilities
├── enums/                # Application enums
├── exceptions/           # Custom exceptions
└── widgets/              # Reusable UI components
```

## Common Development Commands

### Build & Run
- **Run development app**: `flutter run`
- **Run release build**: `flutter run --release`
- **Build APK**: `flutter build apk`
- **Build app bundle**: `flutter build appbundle`
- **Build iOS**: `flutter build ios`

### Testing
- **Run tests**: `flutter test`
- **Run single test file**: `flutter test test/widget_test.dart`
- **Run specific test**: `flutter test --name "test_name"`
- **Run tests with coverage**: `flutter test --coverage`

### Linting & Analysis
- **Run analyzer**: `flutter analyze`
- **Check for outdated packages**: `flutter pub outdated`
- **Update packages**: `flutter pub upgrade`
- **Run lint**: `flutter pub run flutter_lints`

### Code Generation
- **Generate code**: `flutter pub run build_runner build --delete-conflicting-outputs`
- **Generate code in watch mode**: `flutter pub run build_runner watch --delete-conflicting-outputs`
- **Clean generated code**: `dart run build_runner clean`

### Internationalization
- **Update localization files**: `flutter pub run intl_translation:extract_to_arb --output-dir=lib/localization/arb lib/localization/app_translation.dart`
- **Generate localization files**: `flutter pub run intl_translation:generate_from_arb --output-dir=lib/localization/generated lib/localization/app_translation.dart lib/localization/arb/intl_*.arb`

### Device & Platform Specific
- **Check device list**: `flutter devices`
- **Run on specific device**: `flutter run -d <device-id>`

### Dependency Management
- **Get dependencies**: `flutter pub get`
- **Add dependency**: `flutter pub add package_name`
- **Remove dependency**: `flutter pub remove package_name`

### Clean & Rebuild
- **Clean build**: `flutter clean`
- **Clean and rebuild**: `flutter clean && flutter pub get && flutter run`
- **Clean cache**: `flutter pub cache clean`

## Key Files & Configuration

### Core Configuration
- **pubspec.yaml**: Main package configuration with dependencies
- **analysis_options.yaml**: Dart analyzer and lint rules (uses flutter_lints)
- **android/app/build.gradle**: Android-specific build configuration
- **ios/Runner.xcworkspace**: iOS Xcode workspace

### Application Entry Points
- **lib/main.dart**: Main application with GetMaterialApp and theme configuration
- **lib/navigation/app_routes.dart**: Route constants
- **lib/navigation/app_routes_screens.dart**: Route definitions and page transitions

### State Management & Architecture
- **lib/services/api_service.dart**: Dio-based API service with manual token management
- **lib/screens/*/[Feature]Controller.dart**: GetX controllers for state management
- **lib/domain/usecases/**: Use case implementations following clean architecture
- **lib/data/repositories/**: Repository pattern implementations
- **lib/domain/base_use_case.dart**: Base use case with error handling pattern
- **lib/base/AppResult.dart**: Result wrapper for error handling

### UI & Theming
- **lib/themes/app_colors.dart**: App color palette and constants
- **lib/presentation/app_message_dialogs.dart**: Common dialog utilities
- **lib/utils/app_localization_utils.dart**: Localization utilities

### Localization
- **lib/localization/app_translation.dart**: Translation keys and setup
- **lib/domain/models/app_locale_model.dart**: Locale model for settings
- **lib/utils/app_localization_utils.dart**: Localization utilities

## Architecture Guidelines

### Clean Architecture Principles
1. **Domain Layer**: Contains business logic and entities, completely independent of Flutter
2. **Data Layer**: Handles data sources (API, local storage, etc.) and repositories
3. **Presentation Layer**: Handles UI, screens, widgets, and state management

### State Management Patterns
- **Primary**: GetX Controllers extending `GetxController`
  - Use `Rx<Type>` for reactive variables
  - Use `.obs` for primitive reactive types
  - Access with `.value` for updates
- **App Settings**: ValueListenableBuilder with app setting notifiers
- **Legacy Screens**: Some screens use flutter_bloc (being migrated to GetX)
- **Navigation**: GetX `Get.to()`, `Get.toNamed()` for route management

### Code Style
- Follow Dart style guide (dart.dev/style-guide)
- Use Material 3 design system
- Follow existing patterns in the codebase
- Prefer named routes with GetX
- Use ValueListenableBuilder for reactive updates
- Implement RTL/LTR support where applicable

### Testing Strategy
- Widget tests for UI components
- Unit tests for use cases and business logic
- Integration tests for critical workflows
- Mock API services for testing

### Error Handling
- Use try-catch blocks with specific exception handling
- Show user-friendly error messages
- Log errors using LogUtils
- Use custom exception types from exceptions directory

### Performance Considerations
- Use const widgets where possible
- Implement efficient list views with ListView.builder
- Use async/await properly for API calls
- Implement loading states and error states
- Use visibility detector to optimize rendering

## Common Tasks & Patterns

### Adding a New Feature (Current Pattern)
1. Create screen in `lib/screens/[feature_name]/`
2. Create GetX controller: `[Feature]Controller extends GetxController`
3. Add domain models in `lib/domain/models/`
4. Implement use case in `lib/domain/usecases/`
5. Add API endpoints in `lib/services/api_service.dart`
6. Add routes to `lib/navigation/app_routes.dart` and `app_routes_screens.dart`
7. Update localization in `lib/localization/localArabic.dart` and `localeEnglish.dart`

### Working with Localization (GetX Pattern)
1. Add translations in `lib/localization/localArabic.dart` and `lib/localization/localeEnglish.dart`
2. Use `.tr` extension for translated strings: `'text'.tr`
3. No ARB file generation needed - uses GetX translation system
4. Language switching handled through GetX locale management

### GetX State Management Pattern
```dart
class FeatureController extends GetxController {
  Rx<DataModel> data = Rx(DataModel());
  RxBool isLoading = false.obs;

  void updateData() {
    data.value = newData; // Triggers UI rebuild
  }
}

// In UI
Obx(() => controller.isLoading.value ? Loading() : Content())
```

### Adding a New API Endpoint
1. Add endpoint to `ApiService` class in `lib/services/api_service.dart`
2. Create request/response models in appropriate directories
3. Implement use case for the API call
4. Use GetX controller for state management (not bloc/cubit)

### Working with Themes
- Use theme colors from `AppColors` class
- Follow Material 3 design principles
- Support both RTL and LTR layouts
- Use responsive design patterns

## Platform Specific Considerations

### Android
- Min SDK: See android/app/build.gradle
- Target SDK: See android/app/build.gradle
- Uses Gradle build system
- Signing configuration in android/app/build.gradle

### iOS
- Xcode workspace in ios/Runner.xcworkspace
- Uses CocoaPods for dependencies
- Signing configuration in Xcode
- Localization in InfoPlist.strings

### Cross-Platform
- Uses Flutter's platform detection
- Handles platform-specific UI differences
- Uses conditional imports for platform-specific code
- Tests on both platforms regularly

## Debugging & Development Tips

### Debugging Tools
- **flutter_native_contact_picker**: For contact picking
- **flutter_alice**: For HTTP debugging
- **talker_dio_logger**: For API request/response logging
- **shake**: For device shake-to-report issues
- **package_info_plus**: For app version information

### Hot Reload
- Use `flutter run` for development with hot reload
- Use `r` key in terminal to trigger hot reload
- Use `R` key for hot restart
- Use `v` key to open DevTools

### Performance Profiling
- Use Flutter DevTools for performance analysis
- Check widget rebuilds with `debugPrintRebuildDirtyWidgets`
- Monitor frame rendering times
- Use memory profiler to check for leaks

## Deployment & Release

### Pre-Release Checklist
1. Run `flutter analyze` to check for code issues
2. Run `flutter test` to ensure tests pass
3. Update version in pubspec.yaml
4. Update Android versionCode and versionName in android/app/build.gradle
5. Update iOS version in Xcode
6. Test on multiple devices and screen sizes
7. Test RTL and LTR layouts
8. Test dark mode if implemented

### Release Build Commands
- **Android**: `flutter build appbundle` (Google Play) or `flutter build apk` (direct distribution)
- **iOS**: `flutter build ios` followed by Xcode archiving
- **Web**: `flutter build web` for web deployment

### App Store & Play Store
- Follow respective store submission guidelines
- Include proper screenshots and metadata
- Ensure accessibility compliance
- Include proper privacy policies

## Troubleshooting

### Common Issues
- **Dependency conflicts**: Run `flutter pub cache repair` and `flutter pub get`
- **Code generation issues**: Run `flutter pub run build_runner build --delete-conflicting-outputs`
- **Android build issues**: Run `cd android && ./gradlew clean` then `flutter clean && flutter pub get`
- **iOS build issues**: Run `cd ios && pod install --repo-update`
- **Localization issues**: Ensure ARB files are properly formatted and generated

### Network & API Issues
- Check API endpoints in `ApiService`
- Verify Dio configuration and interceptors
- Check for proper error handling
- Use `flutter_alice` to inspect HTTP traffic
- Ensure proper CORS configuration for web

### UI Issues
- Check widget tree hierarchy
- Verify proper constraints and layouts
- Check theme configuration
- Test on different screen sizes and orientations
- Verify RTL/LTR support

### Performance Issues
- Use `Profile` mode to analyze performance
- Check for excessive widget rebuilds
- Optimize image loading and caching
- Implement lazy loading for lists
- Minimize expensive operations in build methods

## Security Best Practices

### Data Security
- Store sensitive data in secure storage (avoid SharedPreferences)
- Encrypt sensitive data in transit (use HTTPS)
- Implement proper authentication and authorization
- Use secure API endpoints
- Implement proper session management

### Code Security
- Avoid logging sensitive data
- Use parameterized queries to prevent injection attacks
- Validate user input properly
- Implement proper error handling that doesn't expose sensitive information
- Keep dependencies updated

### Network Security
- Use HTTPS for all API calls
- Implement proper SSL pinning if needed
- Validate SSL certificates
- Implement proper request timeouts
- Use Dio interceptors for request/response modification

## Documentation & Resources

### Flutter Documentation
- [Flutter Official Documentation](https://docs.flutter.dev)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter API Reference](https://api.flutter.dev)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)

### Package Documentation
- [flutter_bloc Documentation](https://bloclibrary.dev)
- [Dio Documentation](https://pub.dev/packages/dio)
- [GetX Documentation](https://pub.dev/packages/get)
- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)

### Design Resources
- [Material Design Guidelines](https://m3.material.io)
- [Flutter Material 3 Documentation](https://docs.flutter.dev/ui/material)
- [Flutter Layout Documentation](https://docs.flutter.dev/ui/layout)
- [Flutter Animation Documentation](https://docs.flutter.dev/ui/animations)

### Testing Resources
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [flutter_test Documentation](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)
- [Mockito for Dart](https://pub.dev/packages/mockito)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)

### Performance Resources
- [Flutter Performance Documentation](https://docs.flutter.dev/perf)
- [Flutter Profiler](https://docs.flutter.dev/tools/devtools/performance)
- [Flutter Widgets Inspector](https://docs.flutter.dev/tools/devtools/widget-inspector)
- [Flutter Memory Profiler](https://docs.flutter.dev/tools/devtools/memory)

## Version Control

### Git Workflow
- Use feature branches for new development
- Follow conventional commit messages
- Include proper PR descriptions
- Test changes before merging
- Use `git pull --rebase` to keep history clean

### Branching Strategy
- **main**: Production-ready code
- **develop**: Development branch (if applicable)
- **feature/feature-name**: Feature branches
- **hotfix/hotfix-name**: Emergency fixes

### Commit Message Format
- Use conventional commits: `<type>(<scope>): <subject>`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep commit messages concise but descriptive
- Reference issues/tickets in commit messages

## Support & Community

### Community Resources
- [Flutter Discord](https://flutter.dev/community)
- [Flutter Reddit](https://www.reddit.com/r/FlutterDev/)
- [Stack Overflow (flutter)](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Flutter Issues](https://github.com/flutter/flutter/issues)

### Package Support
- [Pub.dev Packages](https://pub.dev)
- [Flutter Packages GitHub](https://github.com/flutter/packages)
- [Dart Packages GitHub](https://github.com/dart-lang)

### Documentation Tools
- [DartDoc](https://pub.dev/dartdoc)
- [Flutter Docs Generation](https://github.com/dart-lang/dartdoc)
- [Flutter Code Generation](https://docs.flutter.dev/tools/formatting)

## Project Specific Notes

### Current Features
- User authentication (login/signup)
- Student and teacher management
- Group management with creation/editing
- Session management and tracking
- Student reporting and analytics
- Multi-language support (English/Arabic)
- RTL/LTR layout support
- Bottom bar navigation system
- Custom theming and design system
- Contact picker integration
- URL launching capabilities
- Permission handling
- Screenshot and sharing functionality

### Technical Debt & Improvements
- Consider implementing more comprehensive testing coverage
- Consider adding CI/CD pipeline
- Consider implementing more robust error handling
- Consider adding accessibility features
- Consider implementing proper state persistence
- Consider adding analytics integration
- Consider implementing offline support
- Consider adding dark mode support

### Future Roadmap
- Expand reporting and analytics features
- Implement more advanced student/teacher management
- Add additional platform support (web, desktop)
- Improve performance and optimization
- Add more accessibility features
- Implement advanced notification system
- Add collaboration features
- Expand internationalization support

## Emergency Contacts & Resources

### Development Issues
- **Build failures**: Check flutter clean && flutter pub get
- **Runtime crashes**: Check logs, use DevTools, check device compatibility
- **API issues**: Verify API endpoints, check network connectivity, use debugging tools
- **UI issues**: Verify widget constraints, check layout hierarchy, test on different devices
- **Performance issues**: Use profiling tools, check for memory leaks, optimize expensive operations

### Security Issues
- **Data breaches**: Implement encryption, secure storage, proper authentication
- **Authentication failures**: Check token management, session handling, API endpoints
- **Network security**: Use HTTPS, validate certificates, implement proper SSL handling
- **Dependency vulnerabilities**: Regularly update dependencies, use security scanning tools
- **User data protection**: Implement proper data handling policies, comply with privacy regulations

### Support Channels
- Flutter community forums
- Package-specific issue trackers
- Stack Overflow for general questions
- GitHub issues for specific problems
- Internal team communication channels

This document should be updated as the project evolves and new patterns or conventions are established.