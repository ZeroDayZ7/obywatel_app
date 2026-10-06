## UI & Responsiveness Guidelines

- ALL dialogs, modals, and screen layouts MUST be fully responsive and cross-platform (Android, iOS, Windows, macOS, Linux, Web).
- ALWAYS wrap modal/dialog scrollable content in `SingleChildScrollView` or use `Flexible`/`Expanded` to strictly avoid `RenderFlex overflow` issues when the virtual keyboard appears or window dimensions change.
- ALWAYS use `ConstrainedBox` with reasonable `maxWidth` / `maxHeight` or `LayoutBuilder` for desktop window compatibility (e.g. Windows).
- Ensure proper bottom view insets padding (`MediaQuery.of(context).viewInsets.bottom`) for input screens on mobile devices.

## Data Models & Build Runner

- ALWAYS use `@freezed` with `abstract class` for DTOs and domain models (Freezed v3+ syntax).
- NEVER fallback to manual `fromJson`/`toJson` classes when resolving generator errors.
- Always run `make br` to rebuild generated files (`*.freezed.dart`, `*.g.dart`).
