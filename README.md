# NeuroTick - Interactive AR Learning Platform

## 🚀 Overview
NeuroTick is an innovative educational application that combines **Augmented Reality (AR)** with interactive quiz-based learning for STEM subjects. The app provides an immersive learning experience through 3D visualizations and gamified assessments.

## ✨ Key Features

### 🎯 **Learning Features**
- **Augmented Reality Visualizations** - Interactive 3D models for complex concepts
- **Multi-Level Quizzes** - Subject-based quizzes with Easy/Medium/Hard levels
- **Progress Tracking** - Comprehensive analytics and performance metrics
- **Subject Categories** - Biology, Chemistry, Physics, Mathematics, Astronomy

### 🔄 **User Experience**
- **Hero Animations** - Smooth screen transitions with visual continuity
- **Provider State Management** - Efficient app-wide state handling
- **Responsive Design** - Adaptable UI for various screen sizes
- **Offline Support** - Local data persistence for uninterrupted learning

### 📊 **Progress & Analytics**
- Real-time score tracking
- Subject-wise performance analysis
- Learning streak maintenance
- Achievement badges and rewards

## 🏗️ Project Architecture

### **Technical Stack**
- **Framework**: Flutter (Dart)
- **State Management**: Provider Pattern
- **Backend**: Firebase (Authentication, Firestore)
- **AR Engine**: Custom AR implementation
- **Local Storage**: SharedPreferences

### **Project Structure**
```
lib/
├── 📁 models/          # Data models and DTOs
├── 📁 screens/         # 8+ main application screens
│   ├── home_screen.dart
│   ├── quiz_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   ├── progress_screen.dart
│   └── ... (6 more)
├── 📁 providers/       # State management with Provider
├── 📁 services/        # Business logic and APIs
├── 📁 widgets/         # Reusable UI components
├── 📁 utils/           # Helper functions and constants
└── 📁 assets/          # Images, fonts, AR models
```

## 🛠️ Installation & Setup

### **Prerequisites**
- Flutter SDK (v3.0+)
- Android Studio / VS Code
- Android/iOS device or emulator

### **Installation Steps**
```bash
# 1. Clone the repository
git clone <repository-url>
cd neurotick

# 2. Install dependencies
flutter pub get

# 3. Add Firebase configuration
# - Download google-services.json (Android)
# - Add GoogleService-Info.plist (iOS)

# 4. Run the application
flutter run
```

### **Firebase Setup**
1. Create Firebase project at [firebase.google.com](https://firebase.google.com)
2. Enable Authentication (Email/Password)
3. Enable Firestore Database
4. Add Firebase configuration files to respective platform folders

## 📱 Screens Overview

### **1. Home Screen** 
- Dashboard with quick access to features
- Featured and recent topics
- User progress overview

### **2. Quiz Screens** 
- Subject selection interface
- Adaptive question levels
- Real-time scoring system
- Detailed result analytics

### **3. AR Learning Screen** 
- Interactive 3D model viewer
- Subject-specific AR content
- Gesture-based model manipulation

### **4. Profile & Settings** 
- User profile management
- App customization options
- Progress statistics
- Achievement display

### **5. Progress Dashboard** 
- Visual progress charts
- Learning analytics
- Performance insights

## 🔧 Development

### **State Management**
The app uses **Provider Pattern** for efficient state management:
```dart
// Provider setup in main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppProvider()),
  ],
  child: NeuroTickApp(),
)

// Accessing provider in screens
final appProvider = Provider.of<AppProvider>(context);
```

### **Key Dependencies**
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  google_fonts: ^4.0.0
  shared_preferences: ^2.0.0
  ar_flutter_plugin: ^1.0.0
```

## 🎨 UI/UX Design

### **Design Principles**
- **Material Design 3** compliant
- **Accessibility** focused with proper contrast ratios
- **Responsive** layouts for all screen sizes
- **Consistent** color scheme and typography

### **Animations**
- Hero animations for screen transitions
- Animated progress indicators
- Micro-interactions for better feedback

## 📊 Current Status

### **✅ Completed**
- All UI screens implementation
- Quiz system with scoring
- Provider state management
- Firebase authentication
- Local data persistence
- AR integration framework

### **🚧 In Progress**
- Enhanced AR content library
- Cloud sync for progress
- Advanced analytics dashboard
- Social learning features

### **📋 Planned**
- Collaborative learning rooms
- AI-powered learning paths
- Offline AR content
- Multi-language support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team
- **Frontend Development**: [Your Name]
- **UI/UX Design**: [Your Name/Team]
- **AR Development**: [Your Name/Team]
- **Backend Integration**: [Your Name/Team]

## 📞 Support
For support, email  or create an issue in the repository.

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Platform**: Android & iOS  
**Minimum SDK**: Android 8.0 / iOS 12.0
