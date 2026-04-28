# Personal Development Plan

## Project

**Project title:** TableTurn  
**Project type:** Flutter and Firebase mobile application  

## Project Context

For this project, I am developing TableTurn, a Flutter app for a board game cafe. It includes sign up and login, board game discovery, booking management, Game of the Week voting, a loyalty system with QR support, and settings such as language, font size, and high contrast mode. The project also includes automated tests for important service and helper logic.

This personal development plan explains the skills I want to improve while building the app. My goal is not only to finish the product, but also to become better and more confident in how I plan, build, test, and improve a mobile app with several features.

## Overall Development Aim

During this project, I want to improve my ability to create a well-structured, user-focused Flutter app that is reliable, consistent, and supported by testing and clear documentation.

## Current Position

At this stage of the project, I have experience building Flutter screens and connecting features to Firebase, but I still want to improve in the following areas:

- structuring features more cleanly across views, models, and services
- handling Firebase data and errors more confidently
- testing app logic more consistently before finalising features
- designing with accessibility and usability in mind
- managing project progress in a more deliberate and organised way

## Development Objectives

### 1. Improve my Flutter architecture and code organisation

I want to organise my Flutter code better so that features are easier to maintain, test, and improve.

**Actions**

- I will keep UI code in widgets and move shared logic into models, controllers, or services when needed.
- I will review larger features, especially booking, loyalty, and Game of the Week, to reduce repeated code and make them easier to read.
- I will follow the project's existing patterns for routes, providers, and global widgets more consistently.

**Success criteria**

- My code is easier to navigate and understand.
- Feature logic is more clearly separated from UI code.
- I can change one feature with less risk of affecting another.

### 2. Strengthen my understanding of Firebase integration

Because this project uses Firebase Authentication, Firestore, and Storage, I want to become more confident in handling cloud data correctly.

**Actions**

- I will review how user data, bookings, voting data, and loyalty data are read from and written to Firebase.
- I will improve validation, loading states, and error handling when data is requested from external services.
- I will make sure important user flows behave safely when data is missing, slow to load, or invalid.

**Success criteria**

- Firebase features behave more reliably.
- I can explain the purpose of the main collections and data flows used in the app.
- I reduce avoidable runtime issues caused by weak validation or missing error states.

### 3. Build a more accessible and user-friendly interface

I want to improve the user experience by making the app clearer, more consistent, and easier to use.

**Actions**

- I will apply consistent styling through the existing theme and shared widgets.
- I will check important screens against the app's accessibility features, including font scaling and high contrast mode.
- I will improve loading, empty, and error states so that users always understand what is happening.
- I will support the existing localization approach by keeping visible text suitable for translation.

**Success criteria**

- Key screens remain usable across different accessibility settings.
- The app feels more consistent across its main flows.
- Users get clearer feedback when actions succeed, fail, or take time to load.

### 4. Improve my testing and quality assurance habits

I want to become more disciplined in how I check my work so that features are not only finished, but also reliable.

**Actions**

- I will continue adding and maintaining tests for feature logic, especially around bookings, quiz logic, loyalty behaviour, QR functionality, and Game of the Week services.
- I will run tests regularly after making meaningful changes instead of leaving validation until the end.
- I will use test failures and regressions as feedback to improve the structure of my code.

**Success criteria**

- Core logic is supported by automated tests.
- I catch more issues before final review or demonstration.
- I rely less on trial and error because testing becomes part of my normal workflow.

### 5. Develop better planning, reflection, and documentation habits

I want to manage the project in a more professional way by planning my work, tracking progress, and recording important decisions.

**Actions**

- I will break the project into smaller feature goals and review them weekly.
- I will record key decisions, blockers, and completed tasks as the project develops.
- I will keep documentation up to date so that the project is easier to explain, present, and maintain.

**Success criteria**

- My work is more organised and less reactive.
- I can explain what I built, why I built it, and what I learned.
- The final project is supported by clear documentation and evidence of progress.

## Planned Timeline

### Short term

- review the structure of existing features and identify the highest-risk areas
- continue stabilising Firebase-backed flows and improve error handling
- keep tests aligned with feature changes

### Mid project

- refine shared UI patterns and accessibility support
- improve the consistency of feature architecture across the app
- expand automated test coverage where logic is most important

### Final phase

- complete final polish on user-facing flows
- review the app for reliability, accessibility, and presentation quality
- finalise documentation and reflect on how my skills have improved

## Evidence I Will Use To Measure Progress

- cleaner and more maintainable Flutter code across major features
- successful use of Firebase services within core user journeys
- automated tests covering important service and helper logic
- a more consistent and accessible user experience
- clearer project notes, progress tracking, and final documentation

## Support and Resources Needed

To achieve this plan, I will need:

- ongoing practice with Flutter architecture and state management
- feedback on UI decisions and usability
- time to test features properly rather than only aiming for feature completion
- reference material for Firebase, Flutter accessibility, and testing best practices

## Reflection Statement

This project gives me the chance to improve beyond basic app development and strengthen the way I work overall. By the end of TableTurn, I want to show not only that I built a working application, but also that I improved in architecture, testing, accessibility, and project management. This personal development plan will help me stay focused on those improvements throughout the project.