# Lettutor App

A new Flutter project for learning.

## Introduction

This is a english learning app. Help user connect with tutor and learn english.

## Project

### Tech Stack

Main: Flutter

I use a lot of libraries in this project. Here are some of them:

- Dio for http request
- Getx for state management, routing, dependency injection, etc.
- Local storage and Secure local storage
- Json serialization for data model
- syncfusion_flutter_pdfviewer for pdf viewer
- etc

### Structure

This project structure follow Clean Architecture. Which is divided into 3 main layers:

- Data: 
  - This layer is responsible for data handling. It contains repository, data source, model, etc.
- Domain: 
  - This layer is responsible for business logic. It contains use case, entity, etc.
- Presentation: 
  - This layer is responsible for UI. It contains widget, page, etc.

I add a app folder to contain all the app related stuffs. It contains app config, app theme, app localization, etc.

### Features

- Splash screen
- Onboarding
- Authentication
  - Login
  - Register
  - Forgot password
  - Reset password
  - Login with Google
  - Login with Facebook
- Home
  - Home page
  - Tutor list
  - Course list
  - Schedule list
  - Profile
- Course Detail
  - Course detail page
  - Course detail info
  - Course detail topics
- Schedule
  - Schedule page
  - Schedule detail
  - Meeting screen
- Tutor Detail
  - Tutor detail page
  - Tutor detail info
  - Tutor detail review
  - Tutor detail courses
- Chat
- Profile/Setting
  - View profile 
  - Become a tutor
  - Edit profile
  - Change password
  - Change language
  - Change theme

## Timeline

### Milestone 1 - Mockup UI

- App Widget Tree can be found here: 
  - https://miro.com/app/board/uXjVNSu85i8=/?share_link_id=141781065522

### Milestone 2

- Upcoming

### Milestone 3

- Upcoming
