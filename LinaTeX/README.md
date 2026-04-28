# LinaTeX - Linux Learning Simulator

## Overview
LinaTeX is an innovative SwiftUI iOS app that makes learning Linux commands fun and intuitive. Through interactive buttons and a simulated terminal interface, users can practice commands while enjoying a smooth, responsive interface.

## Features
- **Interactive Terminal Simulator**: Visual feedback as commands are typed
- **Command Buttons**: Quick access to essential Linux commands
- **Retro-modern UI**: Green/black terminal styling with smooth SwiftUI motion
- **Learning-Focused**: Progress through commands from basics to advanced
- **Portrait Mode**: Optimized for iPhone vertical orientation

## Project Structure
```
LinaTeX/
├── LinaTeXApp.swift          # App entry point
├── ContentView.swift         # Main view container
├── Views/
│   ├── TerminalView.swift    # Terminal display component
│   └── CommandButtonPanel.swift  # Button interface
├── ViewModels/
│   └── TerminalViewModel.swift   # Logic & state management
└── Package.swift             # Swift Package configuration
```

## Getting Started
1. Open the project in Xcode 15+
2. Select an iOS 16+ simulator or device
3. Build and run

## UI Design Philosophy
- **Intuitive**: Button-press interactions mirror typing experience
- **Smooth**: Animations and transitions for visual feedback
- **Educational**: Command library with simulated outputs
- **Modern**: SwiftUI motion and layout with a strict green/black visual system

## Commands Included
- `ls` - List directory contents
- `pwd` - Print working directory
- `cd` - Change directory
- `mkdir` - Create directory
- `touch` - Create file
- `cat` - Display file contents
- `rm` - Remove file
- `cp` - Copy file
- `mv` - Move file

## Future Enhancements
- [ ] Expandable command database (basic → advanced → expert)
- [ ] Interactive tutorials with hints
- [ ] Command explanations and man pages
- [ ] Progress tracking and achievements
- [ ] Dark/Light theme support
- [ ] Customizable keyboard shortcuts
