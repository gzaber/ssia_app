# ssia_app - Security Systems Installer Assistant

A mobile application designed for security system installers.  
It supports working with addressable electronic devices.
The application allows to create the structure of security systems in a graphic form.
It is useful during the start-up of security systems and during systems development.

## Table of contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technologies](#technologies)
- [Setup](#setup)
- [Launch](#launch)
- [Test](#test)
- [Insipiration](#inspiration)

## Features

- Manage projects
  - Create project (e.g. building name)
  - Update project name / icon
  - Delete project
- Manage nodes
  - Create node (e.g. security system name, element of the security system)
  - Update node name / icon
  - Delete node
- Change the order of the items on the displayed list
- Slide a list item to view the menu
- Export project to file
- Import project from file
- Create a tree preview of the items
- Share the tree preview as an image

## Screenshots

[<img alt="Home screen" width="150px" src="_screenshots/ssia_home.png" />](_screenshots/ssia_home.png)
[<img alt="Add" width="150px" src="_screenshots/ssia_add.png" />](_screenshots/ssia_add.png)
[<img alt="Select icon" width="150px" src="_screenshots/ssia_select_icon.png" />](_screenshots/ssia_select_icon.png)
[<img alt="Edit" width="150px" src="_screenshots/ssia_edit.png" />](_screenshots/ssia_edit.png)
[<img alt="Delete" width="150px" src="_screenshots/ssia_delete.png" />](_screenshots/ssia_delete.png)
[<img alt="Import" width="150px" src="_screenshots/ssia_import.png" />](_screenshots/ssia_import.png)
[<img alt="Export" width="150px" src="_screenshots/ssia_export.png" />](_screenshots/ssia_export.png)
[<img alt="Slidable" width="150px" src="_screenshots/ssia_slidable1.png" />](_screenshots/ssia_slidable1.png)
[<img alt="Slidable" width="150px" src="_screenshots/ssia_slidable2.png" />](_screenshots/ssia_slidable2.png)
[<img alt="Nodes" width="150px" src="_screenshots/ssia_nodes1.png" />](_screenshots/ssia_nodes1.png)
[<img alt="Node details" width="150px" src="_screenshots/ssia_node_details1.png" />](_screenshots/ssia_node_details1.png)
[<img alt="Nodes" width="150px" src="_screenshots/ssia_nodes2.png" />](_screenshots/ssia_nodes2.png)
[<img alt="Nodes" width="150px" src="_screenshots/ssia_nodes3.png" />](_screenshots/ssia_nodes3.png)
[<img alt="Node details" width="150px" src="_screenshots/ssia_node_details2.png" />](_screenshots/ssia_node_details2.png)
[<img alt="System tree" width="150px" src="_screenshots/ssia_system_tree.png" />](_screenshots/ssia_system_tree.png)
[<img alt="Share" width="150px" src="_screenshots/ssia_share.png" />](_screenshots/ssia_share.png)

## Technologies

- Dart
- Flutter
- SQLite

## Setup

Clone or download this repository.  
Use the following command to install all the dependencies:

```
flutter pub get
```

Use the following command to update to the latest compatible versions of all the dependencies :

```
flutter pub upgrade
```

Use the following command to create platform-specific folders:

```
flutter create .
```

## Launch

Run the application using your IDE or using the following command:

```
flutter run
```

## Test

Run the tests using your IDE or using the following command:

```
flutter test
```

## Inspiration

This application was based on Island Coder876 tutorial:  
_How to implement Domain Driven Design in Flutter Applications_  
https://www.youtube.com/playlist?list=PLFhJomvoCKC_YMx_ObwZG3bfImpu2VdEN
