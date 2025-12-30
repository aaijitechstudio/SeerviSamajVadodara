# Navigation Flow Report

This document describes the **current navigation + session flow** across the app, based on the code under `lib/` as of the latest changes.

---

## Overview (Navigator hierarchy)

- **Root**: `MaterialApp` (`lib/main.dart`)

  - **home**: `AuthGate` (nested navigator)
  - **navigatorObservers**: `NavigationLogger` (logs PUSH/POP/REPLACE)

- **AuthGate navigator**: `AuthGate` (`lib/features/auth/presentation/screens/auth_gate.dart`)

  - Owns the **auth/root routes** (`/splash`, `/welcome`, `/login`, `/main`, etc.)
  - On auth changes, it calls: `pushNamedAndRemoveUntil(target, (route) => false)`

- **Main app shell**: `MainNavigationScreen` (`lib/features/home/presentation/screens/main_navigation_screen.dart`)

  - Uses an **`IndexedStack`** for bottom tabs (no page push when switching tabs)
  - Has a **Drawer** (`AppDrawer`)
  - Has a **FAB** on Home tab → opens `PostComposerScreen`

- **Modal navigation**
  - Comments open via `showModalBottomSheet` → `CommentsSheet`

---

## Auth + Session routing (centralized)

### Source of truth

- **Firebase session**: `authStateProvider` (`auth.authStateChanges()`)
  File: `lib/features/auth/providers/auth_provider.dart`
- **App routing**: `AuthGate` listens to `authStateProvider` and decides which root screen should be active.

### Rules

- **Minimum splash duration**: ~2 seconds (UX smoothing)
- After splash and **auth resolved**:
  - **Logged in** (`Firebase User != null`) → route to **`/main`**
  - **Logged out** (`Firebase User == null`) → route to **`/welcome`**

### Key guarantees

- No screen (login/welcome/profile/logout) needs to manually redirect to Main/Welcome.
- Login/logout always results in a consistent root screen because the stack is cleared.

---

## AuthGate Route Table (named routes)

All of these are served by `AuthGate`:

- **`/splash`** → `SplashScreen`
- **`/welcome`** → `WelcomeScreen`
- **`/login`** → `LoginScreen`
- **`/forgot-password`** → `ForgotPasswordScreen`
- **`/signup`** → `SignupScreen`
- **`/phone-login`** → `PhoneLoginScreen`
- **`/onboarding`** → `OnboardingScreen`
- **`/main`** → `MainNavigationScreen`
- **`/settings`** → `SettingsScreen`
- **`/settings/notifications`** → `NotificationsSettingsScreen`
- **`/settings/login-history`** → `LoginHistoryScreen`
- **`/terms`** → `TermsAndConditionsScreen`
- **`/privacy`** → `PrivacyPolicyScreen`
- **`/samaj-id-card`** → `SamajIdCardScreen`

---

## Startup flows (all cases)

### Case A: Fresh install / logged out

- App starts → **`/splash`**
- After ~2 seconds + auth resolved → **`/welcome`**

### Case B: Already logged in (session exists)

- App starts → **`/splash`**
- After ~2 seconds + auth resolved → **`/main`**

### Case C: Firebase not initialized / auth stream fails

- App starts → **`/splash`**
- Auth resolves as logged out → **`/welcome`**

---

## Welcome / Login / Signup flows

### WelcomeScreen (`/welcome`)

- **Login button** → `pushNamed('/login')`
- **Register button** → `pushNamed('/signup')`

### LoginScreen (`/login`)

- **Forgot password** → `pushNamed('/forgot-password')`
- **Sign up link** → `pushReplacementNamed('/signup')`
- **Successful sign-in (email/google)**:
  - Screen does **not** navigate to Main.
  - Firebase auth changes → `AuthGate` routes to **`/main`**.

### ForgotPasswordScreen (`/forgot-password`)

- Back arrow → `pop()`
- After reset email sent → “Back to login” uses `pop()`

### SignupScreen (`/signup`)

- “Already have account” → `pushReplacementNamed('/login')`
- If error indicates “email already in use” → “Go to sign in” → `pushReplacementNamed('/login')`
- Successful signup:
  - No manual navigation to login/main
  - Firebase auth changes → `AuthGate` routes to **`/main`**.

### PhoneLoginScreen (`/phone-login`)

- OTP success:
  - No manual navigation
  - Firebase auth changes → `AuthGate` routes to **`/main`**.

### OnboardingScreen (`/onboarding`)

- “Skip” / “Get started” → `pushReplacementNamed('/login')`

---

## Main App Shell (`/main`) — bottom tabs

File: `lib/features/home/presentation/screens/main_navigation_screen.dart`

### Tabs (IndexedStack)

`navigationIndexProvider` controls which child is visible:

- **Tab 0 – Home** → `HomeScreen`
- **Tab 1 – News** → `NewsScreen`
- **Tab 2 – Members** → `MergedMembersScreen`
- **Tab 3 – Education** → `EducationCareerScreen`
- **Tab 4 – Profile** → `ProfileScreen`

### FAB (only on Home tab)

- Visible when: **Home tab** and user != null
- On tap → `Navigator.push(MaterialPageRoute(PostComposerScreen(...)))`
  - Screen: `lib/features/community/presentation/screens/post_composer_screen.dart`

---

## Drawer navigation (available from /main)

File: `lib/features/home/presentation/widgets/app_drawer.dart`

### Drawer Items → Screens

- **Events** → `EventsScreen` (MaterialPageRoute)
- **Helpline** → `HelplineScreen` (MaterialPageRoute)
- **History** → `HistoryScreen` (PageTransitions.fadeSlideRoute)
- **Photo Gallery** → `PhotoGalleryScreen` (PageTransitions.fadeSlideRoute)
- **Contact Us** → `ContactUsScreen` (PageTransitions.slideRoute)
- **About Us** → `AboutUsScreen` (MaterialPageRoute)
- **Admin Panel** (admin only) → `AdminPanelScreen` (PageTransitions.slideRoute)
- **Language** → dialog (no route)
- **Logout** → dialog → `await signOut()` → auth becomes null → `AuthGate` routes to `/welcome`

---

## Feature flows (by tab / entry point)

## Home tab (Tab 0)

### HomeScreen

File: `lib/features/home/presentation/screens/home_screen.dart`

- Menu button opens Drawer (`ScaffoldState.openDrawer()`)
- Notifications button currently shows “Coming soon” snackbar
- Content is primarily:
  - `PostListWidget` (community feed)

### PostListWidget (feed)

File: `lib/features/community/presentation/widgets/post_list_widget.dart`

- Loads posts and renders `PostItemWidget` per post

### PostItemWidget

File: `lib/features/community/presentation/widgets/post_item_widget.dart`

- Like / Pin / Admin badges handled in-widget
- **Comments**:
  - Opens bottom sheet: `showModalBottomSheet` → `CommentsSheet`
  - File: `lib/features/community/presentation/widgets/comments_sheet.dart`

### PostComposerScreen

File: `lib/features/community/presentation/screens/post_composer_screen.dart`

- Opened from Home FAB (MaterialPageRoute)
- Uploads media to Storage and creates post (no special navigation flow documented here)
- Typical exit is via back/pop after posting (screen-controlled)

> Note: `FeedScreen` exists (`lib/features/home/presentation/screens/feed_screen.dart`) but appears **not referenced** by the current app entry flow.

---

## News tab (Tab 1)

### NewsScreen

File: `lib/features/news/presentation/screens/news_screen.dart`

- Has internal TabBar (4 tabs) for different news categories.
- **E-Newspapers action**:
  - Opens `ENewspapersScreen` via `MaterialPageRoute`
  - Method: `_navigateToENewspapers()`
- **News item → Web view**:
  - Opens `WebviewScreen` via `PageTransitions.fadeSlideRoute(...)`

### ENewspapersScreen

File: `lib/features/news/presentation/screens/enewspapers_screen.dart`

- Lists e-papers
- On tap → `WebViewScreen(url, title)` via `PageTransitions.fadeSlideRoute`

### WebViewScreen

File: `lib/features/news/presentation/screens/webview_screen.dart`

- Uses `webview_flutter`
- Back arrow → `pop()`

---

## Members tab (Tab 2)

### MergedMembersScreen

File: `lib/features/members/presentation/screens/merged_members_screen.dart`

- TabBar with 2 tabs:
  - **Members**
  - **Committee Members**

### Members list → MemberDetailScreen

- From both:
  - `MembersScreen` (`lib/features/members/presentation/screens/members_screen.dart`)
  - `MergedMembersScreen`
- On member tap → `Navigator.push(PageTransitions.fadeSlideRoute(MemberDetailScreen))`

### MemberDetailScreen

File: `lib/features/members/presentation/screens/member_detail_screen.dart`

- Back arrow → `pop()`
- Actions:
  - Phone call / WhatsApp / Email via `url_launcher` (external apps)

### Committee members (inside MergedMembersScreen)

- Rendered as cards.
- Tap (if phone present) triggers `_makePhoneCall` via `url_launcher`
- Committee images are now fetched from Firebase Storage path → download URL (committee feature work)

---

## Education tab (Tab 3)

### EducationCareerScreen

File: `lib/features/education/presentation/screens/education_career_screen.dart`

- Search results and category cards navigate to detail screens:
  - `CareerDetailScreen`
  - `ScholarshipDetailScreen`
  - `SkillDetailScreen`
  - `ExamDetailScreen`
  - `SuccessStoryDetailScreen`
  - `VedicSikshaScreen`

### VedicSikshaScreen

File: `lib/features/education/presentation/screens/vedic_siksha_screen.dart`

- Opens `VedicSikshaDetailScreen` from scripture cards (via Navigator push)

### Detail screens

Files:

- `lib/features/education/presentation/screens/*_detail_screen.dart`
- Navigation typically: list → detail (push), back (pop)

---

## Profile tab (Tab 4)

### ProfileScreen

File: `lib/features/auth/presentation/screens/profile_screen.dart`

- Top actions:
  - **Settings** → `pushNamed('/settings')`
  - **Samaj ID card** → `pushNamed('/samaj-id-card')`
  - **Logout** → dialog → `await signOut()` → `AuthGate` routes to `/welcome`

### SettingsScreen

File: `lib/features/auth/presentation/screens/settings_screen.dart`

- **Notifications settings** → `pushNamed('/settings/notifications')`
- **Login history** → `pushNamed('/settings/login-history')`
- **Terms** → `pushNamed('/terms')`
- **Privacy** → `pushNamed('/privacy')`
- Language selection updates locale and closes settings (pop).

---

## Admin flows

### AdminPanelScreen

File: `lib/features/admin/presentation/screens/admin_panel_screen.dart`

- Access control:
  - If `user == null` or `!user.isAdmin` → “Access denied”
- TabBar (3 tabs):
  - Members, Announcements, Events
- FAB opens:
  - `AddMemberScreen` (MaterialPageRoute)
  - `AddAnnouncementScreen` (MaterialPageRoute)
  - `AddEventScreen` (MaterialPageRoute)

---

## Events (drawer / quick access)

### EventsScreen

File: `lib/features/events/presentation/screens/events_screen.dart`

- Read-only list from Firestore
- No navigation to details currently

---

## Committee extras (quick access / drawer)

### HelplineScreen

File: `lib/features/committee/presentation/screens/helpline_screen.dart`

- Opened from Drawer and from `HomeQuickAccess` grid.

### AartiScreen

File: `lib/features/committee/presentation/screens/aarti_screen.dart`

- Opened from `HomeQuickAccess` grid.

### CommitteeScreen

File: `lib/features/committee/presentation/screens/committee_screen.dart`

- Exists as a separate screen (search + list), but the app currently uses the combined committee list inside `MergedMembersScreen`.

---

## Misc screens reachable via Drawer

- `HistoryScreen` → drawer
- `PhotoGalleryScreen` → drawer
- `ContactUsScreen` → drawer
- `AboutUsScreen` → drawer

---

## Current navigation style summary

- **Auth-related navigation**: centralized, named routes via `AuthGate`
- **Main app feature navigation**: mixed
  - Many places use `MaterialPageRoute`
  - Some use `PageTransitions` helper routes
  - Comments use bottom sheet modals

---

## Android Back Button Policy (final)

This policy defines how the Android system back button should behave across the app.

### A) Welcome (`/welcome`) — double back to exit

- **First back press**: show message/snackbar: **“Press back again to exit”**
- **Second back press within ~2 seconds**: **exit app**

### B) Main shell (`/main` → `MainNavigationScreen`)

Because bottom tabs are implemented using an `IndexedStack`, tab switches do not create a navigation stack. So back behavior must be defined explicitly:

- **If current tab is NOT Home (index 0)**:
  - Back → switch to **Home tab (index 0)** (consume back)
- **If current tab IS Home (index 0)**:
  - Back → **double back to exit** (same UX/message as Welcome)

### C) Any pushed screen (details / sub-pages)

If a screen is opened via `Navigator.push(...)` (detail pages, WebView, forms, etc.):

- Back → **pop** (return to previous screen)

### D) Modal layers

- **Bottom sheets** (e.g., comments): back closes the sheet first
- **Dialogs**: back dismisses dialog first

### E) Auth/session overrides

If Firebase auth session changes (logout, token revoked, etc.):

- `AuthGate` will reset the root screen to `/welcome` and clear the stack
  (Back button handling must never block this.)

If you want, the next step after this report is to **extend named-route routing to the non-auth features** (drawer items, news epaper, post composer, education details, etc.) so the entire app follows one consistent approach.
