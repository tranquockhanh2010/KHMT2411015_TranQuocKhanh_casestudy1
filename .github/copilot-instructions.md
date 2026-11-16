# Copilot instructions for andev

## Project overview

This is a Flutter mobile expense-management app (`andev`) using Dart 3.13.2. The visible product is a Vietnamese-language Material UI for a personal expense tracker. Transaction screens are backed by the local SQLite database; keep the database/model/service flow consistent when adding features.

## Build, test, and analysis commands

Run commands from the repository root:

```text
flutter pub get
flutter analyze
flutter test
```

Run one test file:

```text
flutter test test/widget_test.dart
```

Run one named test:

```text
flutter test test/widget_test.dart --plain-name "opens expense page from dashboard add button"
```

`flutter_lints` is enabled through `analysis_options.yaml`. Analyzer output currently includes informational naming/deprecation findings; do not hide new diagnostics, and preserve the existing lint configuration unless the change specifically requires it.

## Architecture and data flow

- `lib/main.dart` creates `ExpenseManagerApp`, whose `MaterialApp` opens `DashboardScreen`.
- `lib/screens/dashboardScreen.dart` is the main shell. It renders the balance/summary/recent-transaction dashboard and pushes the transaction, statistics, and profile screens from its bottom navigation. The floating action button pushes `AddTransactionScreen`.
- `lib/screens/Expense_Page.dart` contains the shared stateful `TransactionForm` plus `AddTransactionScreen` and `EditTransactionScreen` wrappers. The form owns its input state, date picker, category/type selection, and currently only shows a save snackbar.
- `lib/screens/transactions_screen.dart` renders a local sample list, filters it by income/expense, and opens `FilterScreen` for the filter result. Tapping an item opens the currently placeholder-style edit form.
- `lib/screens/statistics_screen.dart` renders fixed category totals and a custom-painted donut chart. `profile_screen.dart` is a static profile/settings list. `welcome_screen.dart` is a separate welcome flow that can replace the route with the dashboard, but `main.dart` does not currently use it.
- `lib/models/transaction.dart` defines the persistence-facing `Transaction` value object and `toMap`/`fromMap` conversion.
- `lib/database/database_helper.dart` is a singleton `sqflite` helper. It creates/migrates `expense.db` version 2 with a `transactions` table (`id`, `title`, `amount`, `date`, `category`, `is_income`, `note`) and exposes CRUD methods. Schema changes require increasing the version and adding an explicit migration.
- `lib/services/transaction_service.dart` is the shared boundary for loading, saving, updating, deleting, filtering, and calculating income/expense totals. Screens should use it rather than duplicating SQL or filter predicates.
- `TransactionsScreen`, `DashboardScreen`, and `StatisticsScreen` load persisted transactions and refresh after add/edit/delete navigation returns `true`. `FilterScreen` returns a `TransactionFilter` containing type, category, and date range.

## Repository-specific conventions

- User-facing copy is Vietnamese, while the app/package and most Dart identifiers are English. Keep new UI text consistent with the existing Vietnamese labels.
- Screens are plain Flutter widgets with local state; use `StatelessWidget` for static views and `StatefulWidget` only where a screen owns interactive state. Navigation is done with `MaterialPageRoute` and `Navigator.push`/`pushReplacement`.
- The existing screen imports are relative (`'Expense_Page.dart'`, `'filter_screen.dart'`), while the application entry point and tests use package imports (`package:andev/...`). Follow the local pattern when editing a file.
- UI styling is defined inline with shared color literals such as blue `Color(0xFF2878E8)`, dark text `Color(0xFF18243A)`, green income, and red expense. Preserve these visual semantics when adding or modifying screens.
- Transaction records should use the `Transaction` model and `TransactionService`; do not introduce new screen-local sample collections for application behavior.
- Database access is centralized through `DatabaseHelper.instance`, normally reached through `TransactionService`; use parameterized CRUD methods and keep SQL/schema changes in the helper.
- The registered asset is `assets/image/logo.png`; asset additions or path changes must also be reflected in `pubspec.yaml`.
- Tests include widget coverage in `test/widget_test.dart` and model/service filtering coverage in `test/transaction_test.dart`. Add focused tests when changing persistence, navigation, filtering, or calculations.
