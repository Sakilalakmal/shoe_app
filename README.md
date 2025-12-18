<img width="1475" height="675" alt="sneakerX" src="https://github.com/user-attachments/assets/a6965696-495d-4f5e-bd39-5fcc65f3a4ec" />

# SneakerX 👟

An advanced, feature-rich Sneaker E-commerce Application built with Flutter, Firebase, GetX, and Riverpod. Designed to provide a seamless shopping experience with features like product discovery, secure user authentication, real-time data sync, and a modern, responsive UI.

## 🚀 Key Features

- **🔐 Robust Authentication**: Secure sign-up/login using Firebase Auth with Email and social providers.
- **👥 State Management**: Efficient state handling using a hybrid approach with GetX (for navigation/controllers) and Riverpod.
- **🛍️ Product Catalog**: Dynamic product listing with category filtering and search capabilities.
- **🎥 Rich Animations**: Engaging user interface with Lottie animations and carousel sliders.
- **📡 Connectivity Status**: Real-time network monitoring to handle offline states gracefully using `connectivity_plus`.
- **🎨 Modern UI/UX**: System-aware Light and Dark modes with a polished design system.
- **💾 Local Storage**: Persistent user preferences using Shared Preferences.
- **📍 Location Services**: Integrated Geolocation features for delivery or store location services.
- **☁️ Cloud Integration**: Powered by Firebase Firestore for real-time database and Firebase Storage for asset management.

## 🛠️ Tech Stack

### Frontend & Mobile

- **Framework**: Flutter (Dart)
- **State Management**: GetX, Riverpod
- **Navigation**: GetX Routes
- **UI Components**: Carousel Slider, Motion Toast, Rating Bar, Badges
- **Icons**: Iconsax, Cupertino Icons
- **Fonts**: Google Fonts

### Backend & Services

- **Database**: Firebase Cloud Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **HTTP Client**: `http` package
- **Environment**: `flutter_dotenv`

## 🏗️ Getting Started

Follow these steps to set up the project locally.

### Prerequisites

- Flutter SDK (v3.0+)
- Dart SDK
- Firebase Project Credentials

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/sakilalakmal/shoe_app_assigment.git
    cd shoe_app_assigment
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Configure Environment Variables:**
    Create a `.env` file in the root directory and add your keys (if applicable):

    ```env
    # Example
    API_KEY=your_api_key
    ```

    _Note: Ensure your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are placed in the respective directories for Firebase configuration._

4.  **Run the Application:**
    ```bash
    flutter run
    ```

## 📁 Project Structure

```
shoe_app_assigment/
├── lib/
│   ├── controllers/      # GetX Controllers for business logic
│   ├── core/             # Core configurations (e.g., Firebase Init)
│   ├── model/            # Data models
│   ├── provider/         # Riverpod providers
│   ├── service/          # API and external service calls
│   ├── utils/            # Utilities, themes, and constants
│   ├── views/            # UI Screens and Widgets
│   └── main.dart         # Entry point
├── assets/               # Images, animations, and icons
├── android/              # Android native code
├── ios/                  # iOS native code
└── pubspec.yaml          # Dependencies and configuration
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📝 License

This project is proprietary and confidential.

Made with ❤️ by **Sakila Lakmal**

