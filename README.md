# Lettutor App

A small Flutter project for learning purpose.

## Introduction

This is a english learning app. Help user connect with tutor and learn english.

## Project

### Tech Stack

Main: Flutter

I use a lot of libraries in this project. Here are some of them:

- Bloc for state management,
- Dio, retrofit for http request
- get_it for dependency injection
- Local storage
- Json serialization, freezed for data entity/model
- flutter_pdfview for pdf viewer
- spin_kit for loading indicator
- flutter_svg for svg image
- flutter_facebook_auth for facebook login
- google_sign_in for google login
- flutter_localizations for localization
- jisti_meet_wrapper for meeting


### Project Structure

This project structure follow Clean Architecture. Which is divided into 3 main layers:

- Data: 
  - This layer is responsible for data handling. It contains repositories, data providers (local/network), models, etc.
  - I use dio + retrofit to generate data providers (network) and json_serializable to generate models.
  - Data from api will be map to models. From models (data layer), data will be map to entity (domain layer) to using in presentation.
  - Repository implement from domain layer is responsible for handling data from data providers (api) and map to entities.
  - I use local storage to store user data and tokens.
- Domain: 
  - This layer is responsible for business logic. It contains use cases, entities, repositories etc.
  - I use freezed to generate entities.
  - Repository in this layer is abstract class. It will be implemented in data layer.
  - Use cases is responsible for handling business logic and call repository to get data.
- Presentation: 
  - This layer is responsible for UI. It contains widgets, screens, blocs, etc.
  - I use bloc for state management.

I add a core folder to contain all the app related stuffs. It contains app config, constants, common layouts, dependency injection config, etc.

### Features

- Splash screen
- Authentication
  - Login
  - Register
  - Forgot password
  - Reset password
  - Login with Google
  - Login with Facebook
- Home
  - Home page (with bottom navigation bar)
  - Tutor list tab
  - Course list tab
  - Schedule Tab
  - Profile
- Course Detail
  - Course detail page
  - Course detail topics
- Schedule
  - Upcoming list
  - History list
  - Meeting screen
- Tutor Detail
  - Tutor detail screen
  - Tutor detail reviews
  - Tutor detail courses
- Profile/Setting
  - View/Edit profile 
  - Become a tutor
  - Change password
  - Change language
  - Change theme
  - Logout

## Timeline

### Milestone 1 - Mockup UI

- App Widget Tree can be found here: 
  - https://miro.com/app/board/uXjVNSu85i8=/?share_link_id=141781065522

### Milestone 2

- Offline app with more implementation from Milestone 1
- Refactor state management to Bloc
- Demo video: https://drive.google.com/file/d/1VVWSzjuiARzbRN92yg5ji8GYX7_BsRZm/view?usp=sharing 
  - Because of the video time limit of youtube, I can't upload video, please watch it on google drive, sorry about that.
- The report can be found in [here](https://docs.google.com/document/d/e/2PACX-1vRy8spMPcTorAYu327Iebl8Tux2QlgM1XJMJ-413wgIMW-4oLg0ezOAc3lnx7pX2g/pub) 

### Milestone 3

- Online app with more implementation from Milestone 2
- Demo video: https://drive.google.com/file/d/1VVWSzjuiARzbRN92yg5ji8GYX7_BsRZm/view?usp=sharing
  - Because i have done integration with api in milestone 2, so i don't have to do much in milestone 3, just add some features and fix some bugs.
  - Please watch the video in milestone 2, it's the same.
- The report can be found in [here](https://docs.google.com/document/d/e/2PACX-1vRy8spMPcTorAYu327Iebl8Tux2QlgM1XJMJ-413wgIMW-4oLg0ezOAc3lnx7pX2g/pub)

### Milestone 4

- Coming soon

## References

- Flutter: https://flutter.dev/
- Bloc: https://bloclibrary.dev/#/ 
- Flutter Clean Architecture: https://marajhussain.medium.com/flutter-bloc-clean-architecture-best-practice-news-apis-3adb0e2012cc
- Flutter Clean Architecture with Bloc: https://www.dbestech.com/tutorials/flutter-bloc-clean-architecture-and-tdd
- Web and API from https://www.letutor.com.vn/