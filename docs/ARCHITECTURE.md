# Architecture

## Folders

```
Benah/
├── App/                  Start of the app, shared session, root + tab navigation
│   ├── BenahApp.swift        @main entry point
│   ├── AppEnvironment.swift  Firebase or sample data?
│   ├── AppSession.swift      who is signed in, which DataStore/AuthService to use
│   ├── RootView.swift        first screen depending on sign-in state
│   └── MainTabView.swift     the 5 tabs
├── DesignSystem/         Tokens from Figma: colours, fonts, spacing, icons
├── Components/           Reusable UI pieces: buttons, fields, badges, tab bar, logo…
├── Models/               Data shapes (Codable structs) saved in Firestore
├── Services/             Talking to the backend (DataStore, AuthService)
├── SampleData/           Figma sample people & groups (used without Firebase)
├── Features/             One folder per feature, added by feature branches
│   └── Gallery/              developer screens: Design system, Backend check
└── Resources/            Fonts, app icon, colours (Assets.xcassets)
firebase/                 Firestore security rules + indexes
docs/                     These guides
```

Each feature branch adds a folder in `Features/` (e.g. `Features/Jamiya/`) with its screens, and
only touches shared folders when it needs a new component or model field.

## How data flows

```
 Screen (SwiftUI View)
   │  reads  @Environment(AppSession.self)
   ▼
 AppSession ──── auth:  AuthService   (FirebaseAuthService | SampleAuthService)
   │
   └──────────── store: DataStore     (FirestoreDataStore  | SampleDataStore)
                          │
                          ▼
                 Cloud Firestore (free Spark plan)
```

* Screens never import Firebase. They call `session.store.get / set / list / listen`.
* That's why the app can run on sample data: only `AppEnvironment` decides which store is used.
* `listen` gives live updates: when another member pays, your screen updates by itself.

## Firestore data model

Money is stored as **fils** (an integer): BHD 10.000 → `10000`. See `Models/Money.swift`.

| Path | Model | Notes |
|---|---|---|
| `users/{uid}` | `AppUser` | name, phone, language, `role` (member/admin), `status` (active/limited) |
| `users/{uid}/people/{id}` | `Person` | "Your people" |
| `users/{uid}/savedGroups/{id}` | `SavedGroup` | e.g. "Ahmed family" |
| `users/{uid}/notifications/{id}` | `AppNotification` | in-app notifications |
| `jamiyas/{id}` | `Jamiya` | `memberIds`, `turns` (uid → turn), `paidThisRound` |
| `jamiyas/{id}/swapRequests/{id}` | `SwapRequest` | direct or group swap |
| `lammahs/{id}` | `Lammah` | candidate dates, availability, votes, venues |
| `qattahs/{id}` | `Qattah` | kind, shares, paid, receipt items |
| `joinRequests/{id}` | `JoinRequest` | joining any group with a code |
| `payments/{id}` | `PaymentRecord` | **simulated** payments |
| `reports/{id}` | `Report` | "Report a problem", resolved by an admin |
| `admins/{uid}` | (empty doc) | exists = staff account; added by hand in the console |

"My groups" queries use array membership, e.g. *jamiyas where `memberIds` contains my uid*.

## Security

`firebase/firestore.rules` is the real protection: the server checks it on every request.
Summary: you can edit only your own profile (not your role or status), only group members can
update a group, restricted (limited) accounts can't create groups, and only admins resolve reports
or restrict accounts.

## Design ↔ code

| Figma | Code |
|---|---|
| Variables `Benah · Color` (Light/Dark) | `Color.benah.*` (`DesignSystem/Colors.swift`) |
| `Benah · Spacing & Radius` | `Space.*`, `Radius.*` |
| Text styles (`Title/1`, `Body/M`, …) | `.benahFont(.title1)`, `.benahFont(.bodyM)` |
| Elevation styles | `.elevation(.card / .raised / .sheet)` |
| Components page | `Components/` |
| `Logo / Benah mark` | `BenahLogo` |
| Screen `Home_FatimaAlrafaei_202406461` | `Features/Home/HomeView.swift` (feature branch) |

Motion follows the *Handoff · interactions & motion* page, and every animation respects
**Reduce Motion** (`@Environment(\.accessibilityReduceMotion)`).
