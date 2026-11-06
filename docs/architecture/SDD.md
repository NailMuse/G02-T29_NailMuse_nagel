# Software Design Document (SDD) - NailMuse

Project: G02-T29 NailMuse for nägel (Batu Kawa, Kuching)
Owner: Aida Nazura (Lead Mobile Architect)
Version: 0.1 draft. Update after the SRS v2.0 (16 Nov 2026).

## 1. Introduction
NailMuse is an Android app for booking manicure appointments at nägel. Customers pick a service, a date and a time, choose a design and pay a deposit. The owner manages bookings, hours, prices and stock. Three AI helpers give design ideas, price estimates and answers to common questions.

## 2. Architecture overview
Three layers (see the proposal Figure 1 and `architecture_diagram.png`):
1. **Presentation:** Flutter screens (Material 3) with Provider for state.
2. **Services:** Dart classes for Firebase Authentication, Cloud Firestore and the OpenAI API.
3. **Cloud:** Firebase and OpenAI.

Rule: a screen never calls Firebase directly. Screen asks provider, provider asks service.

## 3. Module design
| Module (`src/lib/features/`) | Requirements | Main screens (see wireframes) |
| --- | --- | --- |
| `auth` | NFR-02 | UI-01 Login / Register (one screen for customer and owner; the role decides where the app goes next) |
| `service_catalogue` | FR-04, FR-09 | UI-02, UI-11 |
| `availability` | FR-02 | UI-03, UI-09 |
| `booking` | FR-01 | UI-03, UI-05 |
| `appointments` | FR-03, FR-12, FR-13 | UI-07, UI-08 |
| `design_preferences` | FR-05, FR-08 | UI-04 |
| `deposit` | FR-11 | UI-05, UI-08 |
| `inventory` | FR-07, FR-14 | UI-10 |
| `ai_assistant` | FR-10 | UI-06 |
FR-06 (reminders) has no screen. It is a WhatsApp or push message. Channel to be confirmed with the client.

## 4. Data design
See `ERD.md` and `ERD.png`. Seven Firestore collections: users, services, slots, appointments, designs, supplies, expenses.

## 5. User interface design
- Wireframes: `wireframes/NailMuse_Wireframes_Grey.png` (11 screens) and a Figma link (add below).
- Colours and fonts: `STYLE_GUIDE.md` section 10 (Lora and Poppins).
- Size: Android Compact 412 x 917. Material 3.

Figma link: (add here)

## 6. AI design
| Feature | Requirement | Input | Output |
| --- | --- | --- | --- |
| AI design ideas | FR-08 | colour, style, shape, photo | 2 to 3 design suggestions |
| AI price estimate | FR-09 | chosen service, extras | estimated price range |
| AI FAQ chat | FR-10 | customer question | short answer |
All AI answers show a notice that they are suggestions. The owner confirms the final design and price. AI prompts are recorded in LOGAI (Yolanda).

## 7. Security and quality
- No API keys in code. Use `.env` (see `.env.example`). Safer option: call OpenAI through a Firebase Cloud Function. To decide with Yolanda.
- Firestore rules: a customer can read and write only their own appointments. Only the owner can change services, slots, supplies and deposit status.
- Code checks: `dart format`, `flutter analyze`, `flutter test` on every pull request (Bruce, CI).

## 8. Deployment
Signed APK v1.0.0 for Android 8.0 and above.

## 9. Open questions
1. Reminder channel: WhatsApp or push notification?
2. OpenAI key: inside the app or behind a Cloud Function?
3. Photos: Firebase Cloud Storage or not?
4. (Decided) Owner and Admin are the same person. Use "Owner".
5. AI requirement IDs: FR-08 to FR-10, or FR-AI-01 to FR-AI-04 as in the SRS template?
