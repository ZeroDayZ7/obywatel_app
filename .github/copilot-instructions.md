## Data Models & Build Runner

- ALWAYS use `@freezed` with `abstract class` for DTOs and domain models (Freezed v3+ syntax).
- NEVER fallback to manual `fromJson`/`toJson` classes when resolving generator errors.
- Always run `make br` to rebuild generated files (`*.freezed.dart`, `*.g.dart`).
