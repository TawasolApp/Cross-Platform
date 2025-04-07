# Tawasol - Cross-Platform

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

2. **Checkout the `develop` branch:**
   ```sh
   git checkout develop
   ```

3. **Install dependencies:**
   ```sh
   flutter pub get
   ```

4. **Run the application:**
5. **Set NDK Version in Android Studio:**

To ensure compatibility, change the NDK version in Android Studio:

- Open **Android Studio > SDK Manager > SDK Tools**
- Check **NDK (Side by side)** and click **Apply**
- Click the **Show Package Details** and check version **27.0.12077973**
- Confirm `ndkVersion = "27.0.12077973"` exists in your `android/build.gradle` file

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
|── appium/                   # E2E Tests
│   ├── android/              # Android Tests
│   ├── desktop/              # Windows (Desktop) Tests
│   ├── utils/                # Testing Utilities
│   ├── requirements.txt      # Testing Dependencies
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

## 🧪 Test Credentials (Temporary)

Use the following test credentials for login and registration (until the API is fully ready):

- **Email:** `test@example.com`
- **Password:** `123456`

## 🧪 E2E Testing

Before running the tests, ensure you have the following dependencies installed on your system:

### 1. **Install Python** (If not already installed)
   - Download and install Python 3.x from [python.org](https://www.python.org/downloads/).
   - Make sure to add Python to your PATH during the installation process.
   - You can verify the installation by running the following command:
     ```bash
     python --version
     ```

### 2. **Install Java Development Kit (JDK)**
   Appium requires JDK for Android automation. You can download it from [Oracle's website](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) or use OpenJDK.

   - After installing JDK, set the `JAVA_HOME` environment variable to point to your JDK installation directory.
   - You can verify the JDK installation by running:
     ```bash
     java -version
     ```

### 3. **Install Android SDK**
   For Android testing, you will need to have the Android SDK installed.

   - You can install the Android SDK via [Android Studio](https://developer.android.com/studio) or by installing the standalone SDK.
   - Set the `ANDROID_HOME` environment variable to the directory where the Android SDK is installed.
   - Ensure the following environment variables are added to the system PATH:
         - %ANDROID_HOME%/platform-tools
         - %ANDROID_HOME%/cmdline-tools/latest/bin
         - %ANDROID_HOME%/build-tools/<version> where version could be something like 36.0.0
         - %ANDROID_HOME%/emulator
         - where %ANDROID_HOME% is the directory where the ANDROID SDK is installed

   - You can verify the Android SDK installation by running:
     ```bash
     adb --version
     ```

### 4. **Install Appium Server**
   Appium is the framework that runs the tests. You can install it globally using npm.

   - Install Node.js and npm from [nodejs.org](https://nodejs.org/).
   - After Node.js and npm are installed, run the following command to install Appium globally:
     ```bash
     npm install -g appium
     ```
   - You can verify the installation by running:
     ```bash
     appium --version
     ```

### 5. **Install Appium Drivers**
   After Appium is installed, run the following commands to install Android and Windows drivers:
   
   - Android:
     ```bash
     appium driver install UiAutomator2
     ```
   - Windows:
     ```bash
     appium driver install Windows
     ```

### 6. **Install Python Dependencies**
   Install the required Python libraries for both Android and Windows tests:
   ```bash
   cd appium
   pip install -r requirements.txt
   ```

After everything is installed, follow the next steps to run the E2E tests:

### 1. **Start Appium Server**

   Start the Appium server by running the following command:
   ```bash
   appium
   ```

### 2. **Run Android Tests**
   First, make sure you have a connected physical device or a running emulator. Then, go to appium/android/capabilities.py and update the 'deviceName' with the name of your device.

   You can get a list of the detected devices by running:
   ```bash
   adb devices
   ```

   After, just run the following command to run the tests:
   ```bash
   pytest appium/android
   ```

### 3. **Run Windows Tests**
   Assuming your local device is a Windows device, just run the following command:
   ```bash
   pytest appium/desktop
   ```

   Otherwise, you would need to install a virtual windows machine first for the tests to run on.
