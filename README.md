# Cross-Platform# Tawasol - Cross-Platform (Flutter)

## 🚀 Project Overview
Tawasol is a LinkedIn clone designed for Android and Desktop applications, built using Flutter and Dart. 

## 🛠 Tech Stack
- **Flutter**
- **Dart**

## 📋 Prerequisites
Before setting up the project, ensure you have the following installed and configured:

### 1. Install Flutter SDK
- Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install) based on your operating system (Windows, macOS, Linux).
- After installation, verify it by running:
  ```sh
  flutter --version
  ```

### 2. Install Dart
- Dart is included with the Flutter SDK. No separate installation is required.
- Ensure Dart is available by running:
  ```sh
  dart --version
  ```

### 3. Set Up an Emulator or Physical Device
- **For Android:**
  - Install [Android Studio](https://developer.android.com/studio) (recommended) or another emulator.
  - Enable **USB debugging** on your physical device (Settings > Developer Options > USB Debugging).
  - Check available devices by running:
    ```sh
    flutter devices
    ```

- **For Windows/Mac/Linux Desktop Builds:**
  - Enable desktop support by running:
    ```sh
    flutter config --enable-windows-desktop  # For Windows
    flutter config --enable-macos-desktop    # For macOS
    flutter config --enable-linux-desktop    # For Linux
    ```

### 4. Install a Code Editor (Recommended)
- **VS Code:** Install the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter).
- **Android Studio:** Install the Flutter and Dart plugins from **Preferences > Plugins**.

### 5. Verify Setup
- Run the following command to check if everything is installed correctly:
  ```sh
  flutter doctor
  ```
- If there are any issues, follow the suggestions provided by `flutter doctor` to fix them.

## ⚙️ Setup Instructions
1. **Clone the repository:**
   ```sh
   git clone https://github.com/TawasolApp/Cross-Platform.git
   cd Cross-Platform
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the application:**
   ```sh
   flutter run
   ```
   - If using an emulator, ensure it is running before executing the command.
   - If using a physical device, enable **USB debugging** and connect the device.

## ▶️ Running the Program
To run the application on your desired platform, follow these instructions:

### Running on Android Emulator or Physical Device
1. Ensure an Android emulator is running or a physical device is connected.
2. Run the following command:
   ```sh
   flutter run
   ```
3. If multiple devices are connected, specify the target device:
   ```sh
   flutter run -d <device_id>
   ```
   You can list available devices using:
   ```sh
   flutter devices
   ```

### Running on Windows, macOS, or Linux
1. Ensure the desktop support is enabled (refer to the Prerequisites section).
2. Run the application:
   ```sh
   flutter run -d windows   # For Windows
   flutter run -d macos     # For macOS
   flutter run -d linux     # For Linux
   ```

### Running on Web
1. Ensure you have enabled web support:
   ```sh
   flutter config --enable-web
   ```
2. Run the application in a web browser:
   ```sh
   flutter run -d chrome
   ```

## 📂 Folder Structure
```
linkedin_clone/
│── lib/
│   ├── core/                 # Global utilities (Shared across the app)
│   │   ├── api/              # API service classes (Backend communication)
│   │   ├── themes/           # UI theme (colors, fonts, styles)
│   │   ├── utils/            # Helper functions, validation, constants
│   ├── features/             # Each feature has its own module
│   │   ├── authentication/
│   │   ├── navigation/
│   │   ├── messaging/
│   │   ├── feed/
│   │   ├── jobs/
│   │   ├── profile/
│   │   ├── connections/
│   │   ├── company/
│   │   ├── admin/
│   │   ├── notifications/
│   ├── widgets/              # Reusable UI components
│── assets/                   # Static assets folder
│   ├── images/               # User profile pics, company logos, etc.
│   ├── icons/                # Custom icons
│   ├── fonts/                # App fonts
│── test/                     # Test files
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│── android/                  # Android-specific settings
│── ios/                      # iOS-specific settings
│── web/                      # Web-specific settings (if applicable)
│── windows/                  # Windows settings (if applicable)
│── macos/                    # macOS settings (if applicable)
│── linux/                    # Linux settings (if applicable)
│── pubspec.yaml              # Dependencies
│── README.md                 # Documentation
```

## 🤝 Contribution Guidelines
### Commit Message Format
Use clear, structured commit messages:
```
[type]: [short description]

[Optional detailed explanation]
```
Example:
```
feat: Implement user profile feature

Added profile creation, editing, and display functionalities with UI enhancements.
```

#### Commit Types:
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code improvement
- `docs`: Documentation update
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (CI/CD, dependencies, etc.)

### Branch Naming Convention
Use the following format:
```
[type]/[short-description]
```
Examples:
```
feat/user-profile
fix/job-listing-ui
```
