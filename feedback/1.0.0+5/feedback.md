# RIVR v1.0.0+5 - Internal Tester Feedback

**Date:** March 2026
**Testers:** Bryce Imel, Phebe Ramsdell, Henok Teklu, Xueyi Li, and internal team

---

## Bugs

- [ ] **Push notifications not being received** — Testers have not received any push notifications even when their favorited rivers display risk levels different than Normal. Notifications should be triggering but are not arriving on device.
- [ ] **Music playback stops on app launch** — Opening the app kills any background audio (e.g., music). The app likely acquires the audio session incorrectly on load. *(Bryce Imel)*
- [ ] **Forecast page intermittent loading failure** — Occasionally need to refresh multiple times to get a river's forecast page to load. *(Bryce Imel)*
- [ ] **"Share My Location" button does nothing** — Tapping the button produces no visible response or action. *(Xueyi Li)*
- [ ] **Verification email links arrive expired** — Every "Resend Verification Email" results in an already-invalid/expired link by the time it is opened. *(Henok Teklu)*
- [ ] **Verification emails land in Spam** — Verification emails are consistently filtered to Spam folders. *(Henok Teklu)*
- [ ] **Intro tutorial tooltip renders off-screen** — One of the onboarding tutorial messages displays above the screen bounds, cut off and unreadable. It should be repositioned below the widget it points to so it stays within the screen bounding box. *(Xueyi Li / internal team)*
- [ ] **Error banners persist across route changes** — Error messages (e.g., "Invalid sign-in credentials") remain visible after navigating from Login to Create Account. Banners should clear on route change. *(Henok Teklu)*
- [ ] **Premature "Signed in successfully" banner** — After tapping "Create Account", the app shows a success banner even though the user is still blocked by the email verification screen and not actually signed in yet. *(Henok Teklu)*

## UX Improvements

- [ ] **Email validation too permissive** — The frontend shows a green checkmark for malformed emails (e.g., emails with internal spaces like `enock37. @gmail.com`, or long random strings). Implement stricter regex validation. *(Henok Teklu)*
- [ ] **Rename "Copy Reach Info" to "Copy Info"** — The word "reach" is confusing to non-technical users. Simplify the label. *(Phebe Ramsdell)*
- [ ] **Empty favorites screen guidance for new users** — When a new user opens the app for the first time, the home screen shows an empty favorites list with no guidance. The helpful guide that appears after adding a favorite should be shown from the start, before any favorites are added. *(Xueyi Li)*
- [ ] **Clarify the "Wave" section's purpose** — The Wave view on the Hourly Timeline feels redundant given the "View Hourly Hydrograph" button below it. Consider adding interactivity (tap data points to see specific values) to differentiate it, or reconsider its role. *(Xueyi Li)*
- [ ] **Add a back/home route for navigation edge cases** — Ensure there is a root "Welcome" or "Landing" route so users are not forced out of the app when navigating back. *(Henok Teklu)*

## Feature Requests

- [ ] **Add to favorites from Flow Forecast Overview Page** — Users should be able to favorite a river directly from the forecast detail view, not only from the map. *(Internal team)*
- [ ] **Option to restore default water video on favorite cards** — Users who customize their favorite card background should be able to revert to the original water animation. *(Bryce Imel)*

## Design Decisions

- [ ] **Discontinue Dark Mode** — Dark mode does not render well in several views. To reduce complexity in future releases, dark mode/theme support will be removed entirely. *(Internal team decision)*

---

## Positive Feedback (for reference)

- Clean aesthetic and fresh design that feels like a weather app *(Xueyi Li, Phebe Ramsdell)*
- Stream order display is appreciated and hard to find elsewhere *(Phebe Ramsdell)*
- Current flow/discharge as the main forecast metric with return period comparison is intuitive *(Phebe Ramsdell)*
- Favorite river customizability is enjoyable *(Bryce Imel)*
- Information density on a small screen is well handled *(Phebe Ramsdell)*
- Aesthetics and simplicity are standout qualities *(Xueyi Li)*
