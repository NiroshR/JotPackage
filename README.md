# Jot Package

# Overview

This is a personal project of mine for taking notes and setting reminders on the
iOS platform. It combines my favourite features of [Microsoft's To-Do](https://todo.microsoft.com/)
and [Apple's Reminders](https://www.apple.com/ca/ios) apps. This was built off
existing work done from a seperate private repo; the way I had setup the project
made it very difficult to add widgets and extensions... and so Jot Package was
born. 

| | | |
|:-------------------------:|:-------------------------:|:-------------------------:|
|<img width="1604" alt="Permission Alert" src="Documentation/Permission Alert.png"> Permission Alert |  <img width="1604" alt="Splash Screen" src="Documentation/Splash Screen.png"> Splash Screen |<img width="1604" alt="Create Account" src="Documentation/Create Account.png"> Create Account |
|<img width="1604" alt="Login" src="Documentation/Login.png"> Login |  <img width="1604" alt="Reminders" src="Documentation/Reminders.png"> Reminders |<img width="1604" alt="Edit Reminder" src="Documentation/Edit Reminder.png"> Edit Reminder |
|<img width="1604" alt="Notes" src="Documentation/Notes.png"> Notes |  <img width="1604" alt="Notes Info" src="Documentation/Notes Info.png"> Notes Info |<img width="1604" alt="Edit Note" src="Documentation/Edit Note.png"> Edit Note |
|<img width="1604" alt="Settings" src="Documentation/Settings.png"> Settings |  <img width="1604" alt="Widget" src="Documentation/Widget.png"> Widget |<img width="180" alt="Logo" src="Jot/Jot/Assets.xcassets/AppIcon.appiconset/180.png">|

## Features

- **Reminders**
    - [x] Title, due date, alerts, priority, flags, notes
- **Notes**
    - [x] Markdown, info tool
- [x] Search functionality of notes and reminders
- [x] iOS Widget
- [x] Notification badges when reminders due
- [x] Firebase secure authentication and Firestore database
- [x] Custom background images on Reminders and Notes tabs

## Requirements 

- iOS 13
- Xcode 11

## Installation

### CocoaPods
We use [CocoaPods](http://cocoapods.org/) to install our dependencies defined in our `Podfile`:

```bash
sudo gem install cocoapods
cd <project-root>
pod init
pod install
```

For more info on project setup visit the [Wiki](https://github.com/NiroshR/JotPackage/wiki/Project-Setup).

## Author
Nirosh Ratnarajah. Literally just me... and StackOverflow.

