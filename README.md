# Ora

**Ora** is a voice clock built for blind and visually impaired users. Tap anywhere on the home screen to hear the current time, or turn on automatic announcements that speak the time on a schedule — even when the app is in the background on Android.

Version **1.5.1**

## Download APK

[![Download APK](https://img.shields.io/github/v/release/abel2800/Ora-Hear-the-Time?label=Download%20APK&style=for-the-badge)](https://github.com/abel2800/Ora-Hear-the-Time/releases/latest)

1. Open the **[Releases](https://github.com/abel2800/Ora-Hear-the-Time/releases)** page
2. Download **Ora-v1.5.1.apk**
3. Install on your Android phone (enable "Install unknown apps" if prompted)
4. Allow **notifications** and **battery optimization** when the app asks

Supports **Android 5.0 and newer** (including older / low-end phones).

If install says "App not installed", uninstall any old Talk Time or Ora first, then try again.

---

## Features

### Hear the time instantly
- **Tap to speak** — tap the home screen to hear the current time
- **Long press** — hear today's date (optional, in Accessibility settings)
- **Greeting on launch** — optional spoken greeting when you open the app

### Automatic announcements
- Speak the time every **15, 30, or 60 minutes**, or turn announcements off
- **Repeat count** — say the time 1 to 5 times per announcement
- **Quiet hours** — mute announcements during hours you choose
- **Next announcement** preview so you always know when the clock will speak next

### Voice and language
- **12 spoken languages** including English, Spanish, French, German, Amharic, Arabic, and more
- **Voice picker** — choose male, female, or standard voices installed on your device
- Adjustable **volume**, **speed**, and **pitch**
- **Test Voice** button to preview before saving

### Accessibility-first design
- Large touch targets and screen reader labels
- Vibration feedback when time is spoken
- Optional large text and high contrast modes
- Material 3 interface with dark mode and dynamic colors

### Reliable background operation (Android)
- Foreground service keeps announcements running 24/7
- Survives sleep, reboot, and low-memory conditions (with battery optimization disabled)
- Backup alarm manager as a second layer of reliability

---

## Supported languages

| Language | UI | Spoken time |
|----------|----|-------------|
| English (US) | ✓ | ✓ |
| Español | ✓ | ✓ |
| አማርኛ (Amharic) | ✓ | ✓ (Amharic words) |
| Français, Deutsch, Italiano, Português | — | ✓ |
| 中文, 日本語, 한국어, हिन्दी, العربية | — | ✓ |

UI translations are available in **English**, **Spanish**, and **Amharic**. All listed languages work for spoken time via your device's text-to-speech voices.

---

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0+)
- **Android** — phone or emulator with API 21+ for full background announcements
- **Chrome** — for quick testing on desktop (announcements run while the tab is open)
- **Windows speech voices** — install language packs under *Settings → Time & Language → Speech* for more voice options

---

## Getting started

### 1. Clone and install dependencies

```bash
git clone <your-repo-url>
cd "Time Talk"
flutter pub get
```

### 2. Generate app icons (first time only)

```bash
dart run flutter_launcher_icons
```

Icons are built from `assets/images/app_icon.png`.

### 3. Run the app

**Android device or emulator:**

```bash
flutter run
```

**Chrome (desktop testing):**

```powershell
$env:CI='true'
flutter run -d chrome --no-version-check
```

On first launch, allow **notifications** and **battery optimization exemption** when prompted — these are required for reliable background announcements on Android.

---

## Build release APK

```bash
flutter build apk --release
```

The APK is output to:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Settings overview

| Section | What you can configure |
|---------|------------------------|
| **Voice** | Language, voice tone, volume, speed, pitch |
| **Announcements** | Interval, repeat count, quiet hours |
| **Accessibility** | Tap-to-speak, vibration, greeting, large text, contrast |
| **Appearance** | Dark mode, dynamic colors |
| **About** | Version, mission, privacy, share |

---

## Project structure

```
lib/
├── main.dart                 # App entry, providers, permissions
├── core/
│   ├── constants/            # App name, intervals, languages
│   ├── theme/                # Material 3 light/dark themes
│   ├── utils/                # Time formatting, scheduling, TTS helpers
│   └── widgets/              # Shared UI components
├── features/
│   ├── home/                 # Dashboard, analog + digital clock
│   ├── settings/             # Settings hub and category screens
│   └── splash/               # Loading screen
├── services/
│   ├── alarm_service.dart    # Announcement scheduling (web + UI state)
│   ├── background_service.dart  # Android 24/7 foreground service
│   ├── tts_service.dart      # In-app text-to-speech
│   └── settings_provider.dart   # User preferences (persisted)
└── l10n/                     # English, Spanish, Amharic translations
```

---

## Platform notes

| Platform | Background announcements | Voice selection |
|----------|-------------------------|-----------------|
| **Android** | Full 24/7 via foreground service | All installed TTS voices |
| **Web / Chrome** | While tab is open only | Browser speech voices |
| **iOS** | Limited (platform restrictions) | System voices |

---

## Privacy

Ora does not collect personal data. All settings are stored locally on your device. The app uses text-to-speech and background services only to announce the time.

---

## License

See [LICENSE](LICENSE) for details.
