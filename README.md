# 🎂 BirthdayVerse

**Create personalized birthday experiences with beautiful themes, heartfelt messages, photos, and music.**

BirthdayVerse is a Flutter-based birthday greeting application designed to help users create personalized digital birthday experiences for their loved ones.

Instead of sending an ordinary birthday message, create something more memorable with customized greetings, personal letters, photo collections, and background music.

## ✨ Features

- **Personalized Greetings** – Add the recipient's name, nickname, relationship, and birthday date.
- **Custom Birthday Messages** – Write meaningful birthday wishes.
- **Personal Letters** – Include a dedicated letter with your own words.
- **Photo Gallery** – Select and include memorable photos.
- **Background Music** – Add a favorite audio track to the birthday experience.
- **Beautiful Themes** – Customize the visual appearance with different themes.
- **Live Preview** – Preview the birthday experience before finalizing it. *(Planned)*
- **Personalized APK Generation** – Generate a separate Android APK for each recipient. *(Planned)*

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Riverpod | State management |
| GoRouter | Navigation and routing |
| Hive | Local data persistence |
| Image Picker | Photo selection |
| File Picker | Audio file selection |
| AudioPlayers | Audio playback |
| Google Fonts | Typography |
| Lottie | Animations |
| UUID | Unique birthday creation IDs |

## 📁 Project Structure

```text
birthdayverse/
│
├── assets/
│   ├── images/
│   ├── music/
│   ├── animations/
│   └── fonts/
│
├── lib/
│   ├── features/
│   │   ├── dashboard/
│   │   ├── creator/
│   │   ├── shared/
│   │   ├── preview/
│   │   ├── themes/
│   │   └── settings/
│   │
│   ├── models/
│   │   └── birthday_config.dart
│   │
│   ├── routes/
│   │
│   └── main.dart
│
├── test/
│
├── android/
├── web/
│
├── pubspec.yaml
├── pubspec.lock
├── .gitignore
└── README.md
```

*Note: This is the intended project structure. Some directories and features may be added as development progresses.*

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK (included with Flutter)
- Visual Studio Code or Android Studio
- Git

### 1. Clone the repository

```bash
git clone https://github.com/RahulUbale06/birthdayverse.git
```

### 2. Navigate to the project directory

```bash
cd birthdayverse
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

### 5. Run static analysis and tests

```bash
flutter analyze
flutter test
```

## 📱 Build APK

To generate a release APK for Android:

```bash
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 🗺️ Development Roadmap

- [x] Initial Flutter project setup
- [x] Dashboard UI
- [x] Birthday creation wizard
- [x] Recipient details and birthday message
- [x] Photo selection and removal
- [x] Music selection and playback
- [ ] Birthday experience preview
- [ ] Theme customization
- [ ] Local data persistence
- [ ] Birthday experience confirmation
- [ ] Personalized APK generation
- [ ] Final UI polish and testing

## 🎯 Project Goal

The goal of BirthdayVerse is to make digital birthday greetings more personal, creative, and memorable.

The long-term vision is to allow users to create a customized birthday experience and share it with someone special through an individual Android application.

## 👨‍💻 Developer

**Rahul Ubale**

- GitHub: [@RahulUbale06](https://github.com/RahulUbale06)
- Portfolio: [rahul-portfolio-snowy-six.vercel.app](https://rahul-portfolio-snowy-six.vercel.app/)

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

<p align="center">
  Made with ❤️ and Flutter
</p>