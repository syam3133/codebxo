Field Sales CRM
A Flutter-based Field Sales CRM application that helps sales teams manage clients, track interactions, and stay organized on the go.

Features
User authentication (sign up, sign in, sign out)
Client management (add, edit, delete, view)
GPS location capture for clients
Call and SMS integration
Interaction tracking
Search functionality
Responsive design for mobile and web
Technology Stack
Frontend: Flutter
Backend: Firebase (Authentication, Firestore)
Architecture: MVVM / Clean Architecture
State Management: Provider
Local Storage: Hive (for offline support)
Location: Geolocator
Permissions: Permission Handler
Setup Instructions
Prerequisites
Flutter SDK (>=3.10.0)
Dart SDK (>=3.0.0)
Firebase account
Android Studio / VS Code with Flutter extensions
Firebase Setup
Create a new Firebase project at Firebase Console
Enable Authentication (Email/Password)
Set up Firestore Database
Add your Flutter app to the Firebase project
Download the configuration files:
For Android: google-services.json → place in android/app/
For iOS: GoogleService-Info.plist → place in ios/Runner/
Running the App
Clone this repository
Run flutter pub get to install dependencies
Run flutter packages pub run build_runner build to generate code
Connect a device or start an emulator
Run flutter run
Architecture
This app follows Clean Architecture principles with clear separation of concerns:

Presentation Layer: UI components, screens, and state management
Domain Layer: Business logic, entities, use cases, and repository interfaces
Data Layer: Repository implementations, data sources, and models
Database Schema
Users Collection
users
└── userId
├── id: string
├── email: string
├── name: string
└── createdAt: timestamp



### Clients Collection

users
└── userId
└── clients
└── clientId
├── userId: string
├── clientName: string
├── phoneNumber: string
├── companyName: string
├── businessType: string
├── usingSystem: boolean
├── customerPotential: string
├── latitude: number
├── longitude: number
├── address: string
├── createdAt: timestamp
└── updatedAt: timestamp



### Interactions Collection

users
└── userId
└── clients
└── clientId
└── interactions
└── interactionId
├── clientId: string
├── interactionType: string
├── notes: string
├── clientReply: string
├── followUpDate: timestamp
└── createdAt: timestamp



## Build Instructions

 

```bash
Android
flutter build apk --release

iOS
bash

flutter build ios --release

Web
bash

flutter build web --release

License
This project is licensed under the MIT License - see the LICENSE file for details.