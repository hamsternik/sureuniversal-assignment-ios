# SureUniversalAssignment

This repository contains the SureUniversalAssignment project.

<details>
<summary>Demo - Recording</summary>
![public-demo-screen-recording-iphone-16-pro](public/SimulatorScreenRecording_iPhone16Pro.mp4)
</details>

## Requirements

Develop an iOS application with a bottom navigation bar that allows navigation between two screens:

- Action Screen
- Users Screen

### The Action Screen

The application will utilize the JSONPlaceholder API, which provides a set of endpoints and resources.

The Action Screen must contain two buttons:

- Start Button:
    - Initiates a worker thread that performs the following tasks:
        - Sends a network request every second to fetch a "user" resource, starting with user ID = 1 and ending with user ID = 10.
        - The fetched user resources will be stored locally (no persistence required).
        - This operation should be repeated for a total of 10 user resources.
- Stop Button:
    - Stops the worker thread if it is running.
    - Deletes all previously stored user resources.

Ref  1.

### The Users Screen

The Users Screen will display a scrollable list of cards, where each card represents a downloaded "user" resource.

- Cards must be displayed in ascending order of user IDs.
- Each card will prominently feature the name of the corresponding user in its center.
- The list may be empty if no users have been downloaded.

Ref 2.

### Design and Requirements

The application's looks must closely resemble the provided images, ensuring proper usage of colors, page titles, and navigation buttons.

Prepare to articulate the rationale behind your design choices.

## Prerequisites

Before you begin, ensure you have met the following requirements:
- You have installed [Xcode](https://developer.apple.com/xcode/) (version 12 or later).

## Installation

To install the project, follow these steps:

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/SureUniversalAssignment.git
    ```
2. Navigate to the project directory:
    ```bash
    cd SureUniversalAssignment
    ```

## Running the Project

To run the project, follow these steps:

1. Open the project in Xcode:
    ```bash
    open SureUniversalAssignment.xcodeproj
    ```
2. Select the target device or simulator.
3. Click the "Run" button or press `Cmd + R`.

## Running Unit Tests

To run the unit tests, follow these steps:

1. Open the project in Xcode:
    ```bash
    open SureUniversalAssignment.xcodeproj
    ```
2. Select the target device or simulator.
3. Click the "Test" button or press `Cmd + U`.

## Contact

If you have any questions or issues, please open an issue in this repository.
