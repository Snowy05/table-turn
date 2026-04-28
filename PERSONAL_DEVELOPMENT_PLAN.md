# Personal Development Plan

## Project

**Project title:** TableTurn  
**Project type:** Flutter and Firebase mobile application  

## Project Context

For this project, I am developing **TableTurn**, a Flutter application that supports user authentication, board game discovery, booking management, Game of the Week voting, a loyalty scheme with QR support, and user settings such as localization, font scaling, and high contrast mode. The project also includes automated tests for key service and helper logic.

This personal development plan outlines how I want to improve my own technical and project skills while completing the app. My aim is not only to finish the product, but to become more confident and capable in how I design, build, test, and refine a multi-feature mobile application.

## Overall Development Aim

During this project, I want to strengthen my ability to deliver a structured, user-focused Flutter application that is technically reliable, visually consistent, and supported by testing and clear documentation.

## Current Position

At this stage of the project, I have experience building Flutter screens and connecting app features to Firebase services, but I still want to improve in the following areas:

- structuring features more cleanly across views, models, and services
- handling Firebase data and errors more confidently
- testing logic more consistently before finalising features
- designing with accessibility and usability in mind
- managing project progress in a more deliberate and organised way

## Development Objectives

### 1. Improve my Flutter architecture and code organisation

I want to improve how I structure my Flutter code so that features are easier to maintain, test, and extend.

**Actions**

- I will keep presentation logic in widgets and move reusable business logic into models, controllers, or services where appropriate.
- I will review my larger feature areas, especially booking, loyalty, and Game of the Week flows, to reduce duplication and improve readability.
- I will follow the existing project patterns for routes, providers, and global widgets more consistently.

**Success criteria**

- My code is easier to navigate and understand.
- Feature logic is more clearly separated from UI code.
- I can make changes to one feature with less risk of breaking another.

### 2. Strengthen my understanding of Firebase integration

Because this project relies on Firebase Authentication, Firestore, and Storage, I want to become more confident in handling cloud-backed data correctly.

**Actions**

- I will review how user data, bookings, voting data, and loyalty-related data are read from and written to Firebase.
- I will improve validation, loading, and error handling where data is requested from external services.
- I will make sure important user journeys behave safely when data is missing, slow to load, or invalid.

**Success criteria**

- Firebase-backed features behave more reliably.
- I can explain the purpose of the main collections and data flows used in the app.
- I reduce avoidable runtime issues caused by weak validation or missing error states.

### 3. Build a more accessible and user-friendly interface

I want to improve the user experience by making the app clearer, more consistent, and more accessible.

**Actions**

- I will apply consistent styling through the existing theme and shared widgets.
- I will check important screens against the app's accessibility features, including font scaling and high contrast mode.
- I will improve the clarity of loading, empty, and error states so that users always understand what is happening.
- I will support the existing localization approach by keeping visible text suitable for translation.

**Success criteria**

- Key screens remain usable across different accessibility settings.
- The app feels more consistent across its main flows.
- Users receive clearer feedback when actions succeed, fail, or require waiting.

### 4. Improve my testing and quality assurance habits

I want to become more disciplined in how I verify my work so that features are not only implemented, but dependable.

**Actions**

- I will continue adding and maintaining tests for feature logic, especially around bookings, quiz logic, loyalty behaviour, QR functionality, and Game of the Week services.
- I will run tests regularly after making meaningful changes instead of leaving validation until the end.
- I will use failures and regressions as feedback to improve the structure of my code.

**Success criteria**

- Core logic is supported by automated tests.
- I catch more issues before final review or demonstration.
- I rely less on trial and error because validation becomes part of my normal workflow.

### 5. Develop better planning, reflection, and documentation habits

I want to manage the project more professionally by planning my work, tracking progress, and recording important decisions.

**Actions**

- I will break the project into smaller feature goals and review them weekly.
- I will record key decisions, blockers, and completed tasks as the project develops.
- I will keep documentation up to date so that the project is easier to explain, demo, and maintain.

**Success criteria**

- My work is more organised and less reactive.
- I can explain what I built, why I built it, and what I learned.
- The final project is supported by clearer documentation and evidence of progress.

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

This project gives me the opportunity to develop beyond basic app building and improve the quality of my overall software development process. By the end of TableTurn, I want to show not only that I created a functioning application, but also that I improved in architecture, testing, accessibility, and project management. This personal development plan will help me stay focused on those improvements throughout the project.