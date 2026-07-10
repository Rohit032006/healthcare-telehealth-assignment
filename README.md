# Healthcare — Doctor Video-Consult Module

A small Flutter tele-health app: doctor login, a patient appointment screen, mandatory
WebRTC video calling, and session notes. Built inside an existing Flutter starter project,
reusing its GetX + go_router + GetIt + GetStorage architecture and themed widgets.

## 1. Tech stack

| Concern | Library |
|---|---|
| State management | GetX (`get`) — reactive controllers (`.obs`/`Obx`) |
| Navigation | `go_router` |
| Dependency injection | `get_it` (repo interfaces registered as lazy singletons) |
| Local storage | `get_storage` |
| Networking | `dio` (present in the base project; not used by this assignment — see "What is mocked") |
| **Video calling** | **`flutter_webrtc`** for the actual peer-to-peer audio/video |
| **Signaling** | **Firebase Cloud Firestore** (used only to exchange SDP offer/answer + ICE candidates — no media ever passes through Firestore) |
| Permissions | `permission_handler` (camera/mic runtime requests) |

## 2. Requirement → screen map

| Requirement | Where |
|---|---|
| Doctor login (email/password + validation) | `lib/features/auth/` → `LoginScreen` |
| Doctor dashboard after login | `lib/features/appointment/view/dashboard_screen.dart` |
| Appointment details + Confirmed/Unconfirmed/Cancelled | `lib/features/appointment/view/appointment_screen.dart` |
| Cancel Appointment button (when Unconfirmed) | Same screen, `CommonBottomSheet` confirmation |
| Start Video Call button (when Confirmed) | Same screen → `lib/features/video_call/` |
| WebRTC video call (local/remote video, mic/camera toggle, end call) | `lib/features/video_call/view/video_call_screen.dart` |
| Add / view session notes | `lib/features/session_notes/` |

## 3. Setup & running

A Firebase project (**"helathcare"**, Android app `com.helathcare`) is already wired in
for this submission — `android/app/google-services.json` and `lib/firebase_options.dart`
are committed, and **Cloud Firestore is enabled in test mode**, so the app runs out of the
box:

1. `flutter pub get`
2. Run the app: `flutter run -t lib/main_dev.dart` (or `main_qa` / `main_prod` / any of
   the other env entrypoints — they only differ by which `.env` file loads; none of that
   config is used by this assignment's mocked features).

The Android `applicationId`/`namespace` was changed to `com.helathcare` to match the
package name already registered on the Firebase app.

To point this at your **own** Firebase project instead (e.g. for longer-term use beyond
this assignment):
```
dart pub global activate flutterfire_cli
flutterfire configure
```
This regenerates `lib/firebase_options.dart` and drops a fresh `google-services.json` /
`GoogleService-Info.plist` for your project. If `lib/firebase_options.dart` is ever
missing or misconfigured, the app fails fast on launch with a clear
`DefaultFirebaseOptions has not been configured...` error rather than silently pointing
at a broken project.

### Mock login credentials

```
Email:    doctor@healthcare.com
Password: Doctor@123
```

(Defined in `lib/utils/constants/mock_data.dart`.)

## 4. WebRTC / signaling architecture

`flutter_webrtc` handles the actual `RTCPeerConnection`, camera/mic capture, and media
tracks. Firestore is used only as a signaling channel — one document per appointment,
with the appointment ID doubling as the room code (this assignment has exactly one mocked
appointment, so no separate "join by code" UI was needed):

```
calls/{appointmentId}
  status: waiting | active | ended
  offer:  { sdp, type }        // written by the caller
  answer: { sdp, type }        // written by the callee
  offerCandidates/{autoId}     // caller's ICE candidates
  answerCandidates/{autoId}    // callee's ICE candidates
```

**Caller/callee resolution** happens automatically via a Firestore transaction
(`VideoCallRepo.joinOrCreateRoom`): whichever instance taps "Start Video Call" first
creates the room and becomes the caller; the second becomes the callee. A stale room from
a previous test call is detected (both `offer` and `answer` already present) and reset.

**Sequence**: caller creates an `RTCPeerConnection` (STUN only —
`stun.l.google.com:19302`) → `createOffer` → writes `offer` → listens for `answer` →
`setRemoteDescription`. Callee reads `offer` → `setRemoteDescription` → `createAnswer` →
writes `answer`. Both sides stream their own ICE candidates into their subcollection and
listen to the other's. Ending the call marks the room `ended`, closes the peer connection
and both `MediaStream`s, and cancels the Firestore listeners.

## 5. How to test video calling

1. Run the app on **two devices/emulators** (or one emulator + one physical device).
2. Log in with the same mock credentials on both.
3. Both land on the same (only) mocked appointment, already seeded as **Confirmed**.
4. Tap **Start Video Call** on both — the first becomes the caller, the second the
   callee, automatically (no manual room code needed).
5. Grant camera/microphone permissions when prompted on both devices.
6. You should see your own camera in the small corner preview and the other device's
   camera full-screen, with working mic/camera toggle buttons and an end-call button.

## 6. What is mocked

- **Authentication** — no real backend; `AuthRepo` checks against a hardcoded
  credential pair with a simulated network delay (swap-ready: the interface
  `IAuthRepo` doesn't change if a real API is added later).
- **Appointment data** — a single in-memory appointment (`AppointmentRepo`), seeded as
  `Confirmed` so the mandatory video-call path is reachable immediately. To see the
  **Unconfirmed → Cancel Appointment** flow instead, change `_seedStatus` in
  `lib/features/appointment/repo/appointment_repo.dart` to `AppointmentStatus.unconfirmed`
  and hot-restart.
- **Session notes** — stored locally per-appointment via `GetStorage`, not synced to a
  server.
- The base project ships with a large, unrelated set of HRMS API endpoints in
  `lib/utils/networks/end_point.dart` (leave management, payroll, attendance, etc.) —
  these belong to a different backend entirely and are **not used** by this assignment.

## 7. Known limitations / what could be improved

- **No TURN server** — only public STUN is configured, so calls may fail across
  restrictive/symmetric NATs or corporate firewalls. A production build would add a TURN
  server (e.g. via a managed provider) as a fallback relay.
- **No incoming-call UI / push notifications** — both parties must manually tap "Start
  Video Call" at roughly the same time; there's no ringing/accept-reject screen.
- **Firestore test-mode rules** — for a real deployment, Firestore security rules should
  restrict read/write access per authenticated user/appointment instead of open test mode.
- **Single mocked appointment / single doctor** — no multi-patient list, no real user
  management, no backend persistence.
- **No automated tests** — given the timeframe, effort went into a working, clean
  end-to-end flow over test coverage.
- **No call reconnection logic** — if a call drops, the user must manually restart it
  from the appointment screen.

## 8. Folder structure

```
lib/
  features/
    auth/            login (model/repo/controller/view)
    appointment/      dashboard + appointment detail
    video_call/       WebRTC + Firestore signaling
    session_notes/    add/view notes
    splash/           existing splash screen, now checks login state
  utils/
    navigation/       go_router routes
    widgets/          shared themed buttons/text fields/bottom sheets (reused as-is)
    constants/        colors, text styles, validators, mock data
  environment_config/ env loading + app bootstrap (Firebase init added here)
  firebase_options.dart  placeholder — regenerate with `flutterfire configure`
```
