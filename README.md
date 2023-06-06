# To-do Platform Admin

![Platform](https://img.shields.io/badge/platform-Web-green.svg)

Admin panel to manage to-do list for specific users.

## Overview

In **To-do**, we use:

- [Git](https://git-scm.com/) as version control.
- [Flutter](https://flutter.dev/) to build and test the mobile application.
- [Anxeb](https://github.com/nodrix/anxeb-flutter) as Flutter wrapper framework.
- [To-Do API](https://api.todo.com/) to fetch data from the To-do backend.
- [Github Actions](https://github.com/0aps/todo-admin) to build and publish the project.

## Prerequisites

Make sure you have installed all following prerequisites:

- [Git](https://git-scm.com/)
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)

## Install

Clone Anxeb and To-do repositories. Make sure they are both in the same directory level.\
Install project dependencies.

```bash
git clone https://github.com/nodrix/anxeb-flutter.git
git clone https://github.com/0aps/todo-admin.git
cd todo-admin
flutter pub get
```

## Code Style

Code style and conventions use all `flutter analyze` default rules.\
A few other rules were added in `analysis_options.yaml`.\
Please see [here](https://dart-lang.github.io/linter/lints/index.html) for all options.

## Useful Commands

- Launch Icons\
  `flutter pub run flutter_launcher_icons`\
  `flutter pub run flutter_native_splash:create`

- Execute Release\
  `flutter run --release -d device-id`

- Execute Profile\
  `flutter run --profile -d device-id`

- Build for Production - Web\
  `flutter build web --release`
