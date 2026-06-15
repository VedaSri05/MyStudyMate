# StudyFlow AI

Smart Exam Planning. Stress-Free Preparation.

## Overview

StudyFlow AI is a Flutter-based exam preparation planner that helps students create personalized study schedules based on:

* Exam date
* Subjects and topics
* Difficulty level of topics
* Available study hours on weekdays and weekends
* Blocked dates (holidays, personal commitments, etc.)

The app automatically generates a study plan, distributes topics across available days, allocates revision sessions, tracks progress, and saves data locally.

---

## Features

### Study Plan Creation

* Create exam-specific study plans
* Add multiple subjects and topics
* Difficulty-based hour estimation
* Duplicate subject validation
* Duplicate topic validation

### Smart Scheduling

* Automatic study schedule generation
* Weekday and weekend study hour configuration
* Blocked date support
* Revision session generation
* Final Revision + Mock Test scheduling

### Progress Tracking

* Daily study checklist
* Progress percentage tracking
* Task completion persistence
* Dashboard overview

### Data Persistence

* Local storage using SharedPreferences
* Plan survives app restart
* Progress survives app restart
* Delete plan functionality

### User Experience

* Clean Material Design UI
* Mobile-friendly interface
* Validation dialogs and warnings
* Study Timer

---

## Tech Stack

* Flutter
* Dart
* SharedPreferences
* Material Design

---

## Installation

1. Clone the repository

git clone https://github.com/your-username/StudyFlow-AI.git

2. Navigate into the project

cd StudyFlow-AI

3. Install dependencies

flutter pub get

4. Run the application

flutter run

---

## Build APK

Debug APK

flutter build apk --debug

Release APK

flutter build apk --release

---

## Future Enhancements

* Adaptive schedule rescheduling
* Priority topic planner
* Calendar-based schedule view
* Exam reminder notifications
* Performance analytics
* Cloud backup and synchronization

---

## Author

Vedasri

Built using Flutter and Dart.
