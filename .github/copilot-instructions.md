## UI, Responsiveness & Theme Guidelines

- ALL dialogs, modals, and screen layouts MUST be fully responsive and cross-platform (Android, iOS, Windows, macOS, Linux, Web).
- ALWAYS wrap modal/dialog scrollable content in `SingleChildScrollView` or use `Flexible`/`Expanded` to strictly avoid `RenderFlex overflow` issues when the virtual keyboard appears or window dimensions change.
- ALWAYS use `ConstrainedBox` with reasonable `maxWidth` / `maxHeight` or `LayoutBuilder` for desktop window compatibility (e.g. Windows).
- Ensure proper bottom view insets padding (`MediaQuery.of(context).viewInsets.bottom`) for input screens on mobile devices.

### Material 3 & Theme System Rules
- **NEVER use hardcoded `Colors.*` or raw `Color(0xFF...)`** directly in UI widgets (e.g., `Colors.red`, `Colors.green`, `Colors.white`, `Colors.black.withValues()`).
- ALWAYS rely on `Theme.of(context).colorScheme` or custom `ThemeExtension` tokens (e.g. `ToastTheme`) to ensure full compatibility with Light, Dark, and Matrix themes.
- **Clean Local Theme Bindings (No inline repeating):** NEVER repeat `Theme.of(context).colorScheme...` or `Theme.of(context).textTheme...` multiple times inside the widget tree. Extract local variables at the top of the `build` method:
  ```dart
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return ...
  }

## Data Models & Build Runner

- ALWAYS use `@freezed` with `abstract class` for DTOs and domain models (Freezed v3+ syntax).
- NEVER fallback to manual `fromJson`/`toJson` classes when resolving generator errors.
- Always run `make br` to rebuild generated files (`*.freezed.dart`, `*.g.dart`).
