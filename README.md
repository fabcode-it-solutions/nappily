# Nappily — AI-Powered Parenting Coach App

A cross-platform Flutter mobile application that helps parents navigate early childhood development through personalized coaching plans, an AI chat assistant, and guided questionnaires. Built with a clean, scalable architecture and a modern Firebase backend.

> This repository is shared as a portfolio reference. It showcases production-grade Flutter development practices, state management, and third-party service integration delivered for a client project.

## Overview

Nappily guides parents through their child's development journey by combining structured questionnaires, tailored coaching plans, and an AI-driven chat assistant — all wrapped in a polished, native-feeling mobile experience for iOS and Android.

## Key Features

- **Baby Profile Management** — Create and manage detailed profiles for each child
- **Smart Questionnaires** — Guided, multi-step question flows with result-based insights
- **Personalized Coaching Plans** — Recommendations generated from questionnaire results
- **AI Chat Assistant** — In-app conversational support for parenting guidance
- **Advice Hub** — Curated articles and tips relevant to each stage of development
- **Push Notifications** — Timely reminders and updates via Firebase Cloud Messaging
- **Subscription & Paywall** — In-app subscription plans for premium content
- **Secure Authentication** — Email/password and Google Sign-In, backed by Firebase Auth
- **User Profile & Settings** — Full account and preference management

## Tech Stack

| Category | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod & Provider |
| Navigation | go_router |
| Backend | Firebase (Auth, Firestore, Cloud Messaging) |
| Authentication | Firebase Auth, Google Sign-In |
| Local Storage | Shared Preferences |
| Notifications | Firebase Cloud Messaging + Local Notifications |
| Networking | HTTP + REST |
| Platforms | iOS, Android |

## Architecture

The project follows a **feature-first architecture**, keeping each domain (auth, baby profile, coaching plan, AI chat, subscriptions, etc.) self-contained with its own UI, logic, and models. This keeps the codebase easy to scale, test, and hand off to other engineers.

```
lib/
├── features/          # Feature modules (auth, baby-profile, ai-chat, coaching-plan, ...)
├── models/            # Shared data models
├── services/          # Firebase & API integrations
├── widgets/           # Reusable UI components
├── utils/             # Helpers & utilities
├── routes.dart        # App routing configuration
└── main.dart          # App entry point
```

## Development Highlights

- Clean separation of concerns using feature modules
- Reactive state management with Riverpod for predictable, testable UI logic
- Secure, environment-based configuration (`.env` + Firebase config, excluded from version control)
- Custom UI components and gradient-based design system
- Optimized image handling and native splash/launcher icon generation

## Getting Started

This project requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) and a configured Firebase project.

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

> Note: Firebase configuration files and environment secrets are intentionally excluded from this repository for security reasons.

## About This Project

This app was developed as a client engagement, covering the full mobile development lifecycle — from architecture and UI implementation to Firebase backend integration and third-party API connectivity.

**Interested in working together?** Feel free to reach out to discuss your Flutter or mobile app development needs.
