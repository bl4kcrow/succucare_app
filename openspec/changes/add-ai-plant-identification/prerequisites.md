# Console-side prerequisites

Two steps must be completed in the Firebase console for the `succucare-db-dev` project before an
identification request can succeed against the real backend. Both are console-side work and neither is
expressible in this repository.

## 1. Enable AI Logic

In the Firebase console for the development project, open **Build → AI Logic** and complete the
"Get started" flow, then pick the Gemini Developer API (`googleAI`) as the provider. Without this the
backend fails every request with `ServiceApiNotEnabled`, which surfaces to the user as
"Service is busy. Try again."

## 2. Register App Check

In the Firebase console for the same project, open **Build → App Check**, then under **APIs** register
at least one provider so client requests are authorized:

- **Android**: register the Play Integrity provider. `lib/main.dart` additionally activates
  `AndroidProvider.debugProvider` so a development build on an emulator or an unsigned APK — which
  Play Integrity rejects — can still obtain a token.
- **iOS**: register the App Attest provider, with the Debug provider used for development builds.

## Effect of skipping either step

The app continues to start and the add form remains fully usable: an identification failure is
reported through the existing `SnackBar` path and the user can still type the plant in by hand. With
`AI_PROVIDER` unset, no identification request is ever attempted.

Note that App Check enforcement is what rejects the request, so a device build without a registered
provider fails on first use rather than at build time. `firebase_app_check` therefore lands with this
feature rather than after it.