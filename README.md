# Seervi Kshatriya Samaj Vadodara

A Flutter mobile application for the Seervi Kshatriya Samaj community in Vadodara. The app provides features for community management, member directory, events, news, and social interactions.

## 🚀 Features

- **Authentication**: Email/password and phone number (OTP) authentication
- **Member Directory**: Browse and search community members
- **Social Feed**: Create and interact with posts
- **Events**: View and manage community events (admin)
- **News**: Vadodara/Gujarat news integration
- **Announcements**: Community announcements (admin)
- **Committee**: Committee member directory and information
- **Multi-language**: Support for Hindi, English, and Gujarati
- **Dark Mode**: Light and dark theme support

## 📋 Prerequisites

- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0
- Firebase project configured
- Android Studio / Xcode (for platform-specific builds)

## 🛠️ Setup Instructions

### 1. Clone the repository

```bash
git clone <repository-url>
cd seervi_kshatriya_samaj_vadodara
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Copy the example environment file and configure your API keys:

```bash
cp .env.example .env
```

Edit `.env` and add your API keys:

```env
NEWSDATA_API_KEY=your_newsdata_api_key_here
```

**Note:** Get your NewsData.io API key from: https://newsdata.io/

### 4. Configure Firebase

#### Android

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`

#### iOS

1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/`

### 5. Run the app

```bash
flutter run
```

## 🧪 Testing

### Run all tests

```bash
flutter test
```

### Run tests with coverage

```bash
flutter test --coverage
```

### View coverage report

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

See [test/README.md](test/README.md) for detailed testing documentation.

## 📁 Project Structure

```
lib/
├── core/                 # Core application infrastructure
│   ├── config/          # Configuration (environment variables)
│   ├── constants/       # Constants and design tokens
│   ├── errors/          # Error handling and exceptions
│   ├── providers/       # Global providers (theme, locale)
│   ├── theme/           # Theme configuration
│   ├── utils/           # Utility functions
│   └── widgets/         # Reusable widgets
├── features/            # Feature modules
│   ├── admin/           # Admin features
│   ├── auth/            # Authentication
│   ├── committee/       # Committee information
│   ├── events/          # Events management
│   ├── home/            # Home and navigation
│   ├── members/         # Member directory
│   └── news/            # News and announcements
├── l10n/                # Localization files
└── shared/              # Shared resources
    ├── data/            # Shared data services
    ├── models/          # Shared models
    └── widgets/         # Shared widgets
```

## 🏗️ Architecture

The project follows a **feature-based modular architecture**:

- **State Management**: Riverpod 2.5.1
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Localization**: Flutter localization with ARB files
- **Error Handling**: Centralized error handling system
- **Testing**: Unit, widget, and integration tests

## 🔒 Security

- Firestore security rules implemented
- API keys stored in environment variables
- Role-based access control (admin vs member)
- User authentication required for most operations

## 🌐 Supported Languages

- Hindi (hi_IN) - Default
- English (en_US)
- Gujarati (gu_IN)

## 📦 Dependencies

### Key Dependencies

- `flutter_riverpod` - State management
- `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` - Firebase services
- `flutter_dotenv` - Environment variable management
- `intl` - Internationalization
- `google_fonts` - Custom fonts

See [pubspec.yaml](pubspec.yaml) for complete dependency list.

## 🚧 Recent Improvements

### ✅ Completed

1. **Environment Configuration**

   - API keys moved to environment variables
   - `.env` file support with `flutter_dotenv`
   - `.env.example` template for setup

2. **Centralized Error Handling**

   - Custom exception classes
   - Failure types for functional error handling
   - Error handler utility for Firebase and HTTP errors

3. **Testing Infrastructure**
   - Test directory structure created
   - Test helpers and utilities
   - Example unit tests
   - Mock support with `mocktail`

### 🔄 In Progress

- Repository pattern implementation
- Code documentation improvements
- Architecture consistency improvements

See [IMPROVEMENT_PLAN.md](IMPROVEMENT_PLAN.md) for detailed improvement plan.

## 📝 Development Guidelines

### Code Style

- Follow Flutter/Dart style guide
- Use `flutter_lints` for linting
- Run `flutter analyze` before committing

### Git Workflow

1. Create feature branch
2. Make changes
3. Write/update tests
4. Run tests and linting
5. Create pull request

### Environment Variables

- Never commit `.env` file
- Use `.env.example` as template
- Document new environment variables

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is private and proprietary.

## 📞 Support

For issues and questions, please contact the development team.

---

**Version:** 1.0.0+1
**Last Updated:** 2024
