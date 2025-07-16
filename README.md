# AuraSync ⚡

A lightning-fast, frictionless group photo sharing app for real-world events like weddings, trips, and college fests — with QR/PIN-based joining, shared cloud galleries, and offline upload queuing.

## 🚀 One-liner
AuraSync solves the post-event photo sharing chaos. Instead of sharing WhatsApp links or Google Drive folders after a wedding or trip, AuraSync lets guests scan a QR code or enter a PIN at the venue to instantly join a shared gallery where everyone's photos are auto-synced to the cloud.

## 🧠 What the App Does (Core Concept)
Guests can upload pictures anonymously, browse all photos from the event in a shared feed, and download what they want — all without making an account or asking for links.

## 🔧 Core Features for MVP

- **Anonymous Event Join**: QR code or numeric PIN, frictionless, no login required
- **Event-based Shared Gallery**: Firebase Storage + Firestore, Grid view of all uploaded event photos
- **Upload from Device**: Gallery picker or camera input, queues if offline
- **Offline Upload Queue**: Hive storage, auto-sync when online resumes
- **Simple Identity Layer**: Nickname input (optional)
- **Cloud Backend**: Firebase (Storage, Firestore, Anonymous Auth)

## 🖼️ UX Flow Summary

1. Host creates event via admin panel (future phase)
2. App generates QR code or 6-digit PIN for that event
3. Guest installs app → scans QR / enters PIN
4. Lands in shared gallery → uploads or browses
5. Photos auto-sync to Firebase Storage
6. Users can download others' pics, or view real-time uploads

## 🎨 Design Vibe (UI/UX Goals)

- Clean and minimal (not over-designed)
- Simple gallery grid (like Google Photos Lite)
- No distractions: only photos, name, upload/download
- Blur-based overlays or floating CTAs welcome
- Rounded card corners, smooth transitions
- Fonts: Inter, Manrope, or default system font

## 📦 Tech Stack

| Layer | Tech |
|-------|------|
| Frontend | Flutter (Android/iOS) |
| State Mgmt | Provider |
| Auth | Firebase Anonymous Auth |
| Storage | Firebase Storage |
| DB | Firestore (Event ↔ Photos mapping) |
| Offline Sync | Hive + retry mechanism |
| QR Code | qr_flutter + qr_code_scanner |
| Image Upload | image_picker, firebase_storage |
| App Theme | Light, muted, simple, readable |

## 📂 Project Structure

```
lib/
├── features/
│   ├── auth/             # Anonymous entry
│   ├── join_event/       # QR scan + PIN entry
│   ├── gallery/          # View photos
│   └── upload/           # Upload queue
├── core/
│   ├── services/         # Firebase, storage, queue
│   ├── theme/            # Colors, text styles
│   └── utils/            # QR utils, network check
├── data/
│   └── models/           # Event, Photo, Participant models
└── widgets/              # Reusable UI components
```

## 🚀 Getting Started

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Configure Firebase (see Firebase Setup below)
4. Run the app: `flutter run`

## 🔥 Firebase Setup

1. Create a new Firebase project
2. Enable Authentication (Anonymous)
3. Enable Firestore Database
4. Enable Storage
5. Download configuration files and update `lib/firebase_options.dart`
6. Set up Firestore security rules for anonymous users

## 🧩 Key Features Implementation

- **QR Code Scanning**: Camera-based QR scanner for instant event joining
- **PIN Entry**: 6-digit numeric PIN as alternative to QR codes
- **Anonymous Auth**: No signup required, instant access
- **Real-time Gallery**: Live photo updates using Firestore streams
- **Offline Queue**: Photos stored locally and uploaded when connection resumes
- **Event Management**: Simple event creation and participant tracking

## 💡 Future Vision

- Paid hosting plans for long-term galleries
- Custom branding for weddings/corporate events
- Premium analytics & download stats
- Web viewer version with download permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

**AuraSync**: The easiest group photo sync app for real-life events, focused on instant QR-based joining, uploading to a shared cloud gallery, and zero login friction. ⚡