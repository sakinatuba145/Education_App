---
name: Dart 3.8 / Flutter 3.32 Gotchas
description: Build errors specific to Dart 3.8 environment in this project
---

## isScrollControlled in showDialog
`isScrollControlled` is NOT a parameter for `showDialog()`. It is only for `showModalBottomSheet()`.
Using it in showDialog causes a compilation error.

**How to apply:** When building scrollable dialog content, wrap with `SingleChildScrollView` inside the dialog content instead.

## const constructors
When adding routes in `main.dart`, only use `const` keyword on widgets that have `const` constructors defined.
`WelcomeScreen`, `DashboardScreen`, `ForgotPasswordScreen` in this project do NOT have const constructors — remove `const` keyword for those.
