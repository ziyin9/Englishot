# Englishot

Englishot is an iOS application designed to help users improve their English language skills through interactive games and learning exercises. The app combines CoreML technology with engaging gameplay to create an effective and enjoyable learning experience.

## Features

### Interactive Learning Games
- **Audio-Image Matching Game**: Match spoken words with corresponding images to improve vocabulary and pronunciation
- Multiple rounds of gameplay with scoring system
- Audio playback functionality for pronunciation practice
- Visual feedback for correct/incorrect answers

### CoreML Integration
- Text analysis capabilities for language learning
- Smart content recommendations based on user performance
- Natural language processing for interactive exercises

### Data Management
- CoreData integration for persistent storage of:
  - User progress and scores
  - Vocabulary lists
  - Learning history
  - Game statistics

### User Interface
- Modern SwiftUI-based design
- Intuitive navigation
- Responsive and adaptive layout
- Accessibility support

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/Englishot.git
```

2. Open the project in Xcode:
```bash
cd Englishot
open Englishot.xcodeproj
```

3. Build and run the project in Xcode

## Project Structure

- `All_Games/`: Contains game-related views and logic
  - `AudioImageMatchingGame.swift`: Audio-visual matching game implementation
  - `1_Home/`: Home screen and navigation components
- `coreMLtext/`: CoreML integration for text analysis
- `CoreData/`: Data persistence layer
- `Englishot.xcodeproj/`: Xcode project configuration

## Game Modes

### Audio-Image Matching Game
- Multiple rounds of gameplay
- Score tracking and progress monitoring
- Audio playback controls
- Visual feedback system

###Text-Image Matching Game

