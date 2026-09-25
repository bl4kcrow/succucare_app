# Repository instructions

## Toolchain and verification

- Use FVM, not a global SDK. `.fvmrc` pins Flutter 3.47.2 (Dart 3.13.2); bootstrap with `fvm flutter pub get`. The resolved graph requires Dart 3.13+, while `pubspec.yaml` still declares `^3.8.0`.
- Generated `lib/**/*.g.dart` and `lib/**/*.freezed.dart` files are checked in. After changing Riverpod, Freezed, or JSON annotations, run `fvm dart run build_runner build --delete-conflicting-outputs`; do not hand-edit generated files.
- Verify in this order: `fvm flutter analyze`, then `fvm flutter test`. Focus one file/case with `fvm flutter test test/path/to/file_test.dart --plain-name "test name"`.
- The checked-in baseline is not green: analysis reports a legacy analyzer-plugin warning for `custom_lint` and unused `_SecondaryPhotos`; all three cases in `test/features/succus/home_screen_test.dart` fail. That test has no provider overrides and expects search/category/Care behavior that the current UI does not implement, so do not infer current behavior from it.

## Runtime and architecture

- `lib/main.dart:11` is the sole Dart app entrypoint: it loads `.env`, initializes the development Firebase app, then runs `ProviderScope`; `MainApp` watches the generated router.
- Features live in `lib/features/auth` and `lib/features/garden`; shared routing, theme, environment, and utilities live in `lib/core`. Feature state and dependency injection use generated Riverpod providers; the router separately uses a local `ValueNotifier` for auth redirects. The imported `.agents/skills` library is generic guidance and does not describe this architecture.
- `lib/core/routes/app_router.dart:14` owns auth redirects and the Garden/Scan/Alerts shell. `/edit-plant` casts `state.extra` to `Plant`, so callers must pass a `Plant` and the route is not deep-link safe.
- Garden loading is paginated Firestore, not reactive: `users/{uid}/plants`, newest first, 10 documents per query. Plant photos are separate Firebase Storage objects.

## Firebase and platforms

- Create `.env` from `.env.template`; startup requires every `*_DEV` value because the dev environment is always selected. Android builds also require `android/app/google-services.json`. `.env` and local Firebase config are ignored; never commit real values.
- Runtime always imports `lib/firebase_options_dev.dart` and `Environment.dev()`; `Environment.prod()` is currently unused. The ignored local `firebase.json` tells FlutterFire to output `lib/firebase_options.dart`, so update its output target and `lib/main.dart` together if reconfiguring.
- Only the Auth emulator is configured, and startup emulator calls are commented out. No local Firestore/Storage rules or indexes are checked in; running against those services otherwise requires the dev Firebase project.
- Android's namespace is `com.bl4kcrow.succucare`; the second activity under `com/bl4kcrow/succucare_app/` is not the launcher. Release builds use the debug signing key and are not production-signed.
- Do not assume web support from the `web/` directory: reachable garden code imports `dart:io`, and desktop Firebase options throw.
