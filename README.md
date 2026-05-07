# 🍔 AppPasti

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)

A comprehensive, cross-platform mobile application built with **Flutter** designed to streamline meal ordering and management. AppPasti seamlessly connects schools, students, and kitchens in one unified, easy-to-use digital ecosystem.

## 📱 Download the App

Get the app now on your favorite platform:

[![Get it on Google Play](https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=apppasti.com&hl=ar)

---

## ✨ Key Features

* **👥 Multi-Role Workflows:** Tailored dashboards and features for **Students**, **Schools**, and **Kitchen Staff**.
* **🛒 Smart Ordering System:** Easily browse available meals, manage a digital cart, and securely check out.
* **📷 QR Code Integration:** Built-in QR scanner for quick order tracking, delivery verification, and school management.
* **🌍 Multi-Language Support:** Fully localized in **English**, **Arabic**, and **Italian** to cater to a diverse user base.
* **🔔 Real-Time Notifications:** Keep users informed with instant alerts and updates using local notifications and Pusher integration.
* **🎨 Modern UI/UX:** A clean, intuitive, and responsive interface optimized for a smooth user experience.

---

## 🛠️ Tech Stack & Architecture

* **Framework:** Flutter
* **Language:** Dart
* **Architecture Pattern:** MVC / Provider-based state management
* **Networking:** Custom API services for backend communication
* **Real-time & WebSockets:** Pusher integration
* **Local Storage:** Shared Preferences

---

## 🚀 Getting Started

If you want to run this project locally, follow these steps:

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest Stable Version)
* Android Studio / Xcode
* Dart plugin installed in your IDE

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/apppasti.git](https://github.com/your-username/apppasti.git)
    cd apppasti
    ```

2.  **Get packages:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 📁 Project Structure

A quick glance at the core directory structure:

```text
lib/
├── constants/         # App-wide themes, variables, and formats
├── helper_functions/  # Utility classes (API, localization, navigation)
├── models/            # Data models (Student, School, Meal, Order, etc.)
├── providers/         # State management providers
├── screens/           # UI Screens grouped by role (auth, kitchen, school, student)
├── shared/            # Reusable widgets, dialogs, and components
└── main.dart          # Entry point of the application
