# src/lib

Main app code. Owner: Aida (Lead Mobile Architect).

| Folder | What goes inside |
| --- | --- |
| `core/` | Theme, routing, shared widgets, constants. Nothing feature-specific. |
| `features/` | One folder per feature. Each has `screens/`, `widgets/`, `providers/`. |
| `models/` | Plain Dart classes that match Firestore documents. |
| `services/` | Code that talks to Firebase (Auth, Firestore) and the OpenAI API. |

Rule: a screen never calls Firebase directly. It asks a provider, the provider asks a service.
