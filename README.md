# RestBreak

A macOS menu bar app that enforces healthy rest breaks during work sessions.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Configurable Work/Rest Intervals** - Set custom work duration (x minutes) and rest duration (y minutes)
- **Full-Screen Rest Overlay** - Takes over the screen during rest periods with a frosted glass effect
- **Automatic Countdown** - Visual countdown timer during rest periods
- **Emergency Exit** - Instantly regain control when needed
- **Menu Bar Integration** - Lives in your menu bar, not the Dock
- **Auto-Start** - Work timer begins automatically on launch
- **Persistent Settings** - Remembers your preferences between sessions

## Screenshots

The app displays a calming full-screen overlay with:
- Moon and stars icon
- Large countdown timer
- Emergency exit button

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0+ (for building from source)

## Installation

### From Source

1. Clone the repository:
   ```bash
   git clone https://github.com/roasahi1986/RestBreak.git
   ```

2. Open the project in Xcode:
   ```bash
   cd RestBreak
   open RestBreak.xcodeproj
   ```

3. Build and run (Cmd + R)

### Direct Download

Download the latest release from the [Releases](https://github.com/roasahi1986/RestBreak/releases) page.

## Usage

1. **Launch the app** - It appears in your menu bar with a timer icon
2. **Configure settings** - Click the menu bar icon to set work/rest durations
3. **Work timer starts automatically** - The countdown begins on launch
4. **Rest when prompted** - When work time elapses, a full-screen overlay appears
5. **Emergency exit** - Click the red "Emergency Exit" button if you need to return to work immediately

## Default Settings

- Work duration: 25 minutes
- Rest duration: 5 minutes

## Building for Distribution

1. Open the project in Xcode
2. Select **Product > Archive**
3. In the Organizer, click **Distribute App**
4. Choose **Copy App** for direct distribution

Users may need to right-click and select "Open" the first time to bypass Gatekeeper.

## Project Structure

```
RestBreak/
├── RestBreak.xcodeproj
└── RestBreak/
    ├── RestBreakApp.swift          # App entry point, menu bar setup
    ├── ContentView.swift           # Settings UI in menu bar popover
    ├── TimerManager.swift          # Work/rest timer logic
    ├── SettingsManager.swift       # UserDefaults persistence
    ├── RestScreenView.swift        # Full-screen rest overlay
    ├── RestScreenController.swift  # Window management
    ├── AppIcon.icns               # Application icon
    └── Assets.xcassets/           # Asset catalog
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Ro Asahi - 盧旭

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
