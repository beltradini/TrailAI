# TrailAI

> AI-powered outdoor trail recommendations using Apple's on-device Foundation Models

TrailAI is a SwiftUI application that leverages Apple's FoundationModels framework to generate intelligent, context-aware trail recommendations. By combining real-time weather data, user preferences, and nearby points of interest, TrailAI delivers personalized suggestions—all processed locally on your device for maximum privacy.

## Features

- **On-Device AI**: Uses Apple's SystemLanguageModel for private, fast recommendations
- **Context-Aware Suggestions**: Considers weather conditions, trail difficulty, and estimated duration
- **Smart Recommendations**: Suggests nearby trails and cafes based on your preferences
- **Beautiful UI**: Modern SwiftUI interface with glass morphism effects
- **Privacy First**: All AI processing happens on-device—no data leaves your device

## Getting Started

### Prerequisites

- **Xcode 16.2+** (or later)
- **iOS 18.2+** / **macOS 15.2+** with Apple Intelligence support
- Swift 6.0+
- Device with on-device language model support

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/TrailAI.git
cd TrailAI
```

2. Open the project in Xcode:
```bash
open TrailAI.xcodeproj
```

3. Build and run the project (⌘R)

## Architecture

TrailAI is built with a clean, modular architecture:

```
TrailAI/
├── TrailAIApp.swift              # App entry point
├── ContentView.swift              # Main content view
├── RecommendationView.swift       # UI for displaying recommendations
├── FoundationModelService.swift   # AI service layer using FoundationModels
├── Trail.swift                    # Trail data model
└── Recommendation.swift           # Recommendation data model
```

### Key Components

- **FoundationModelService**: Actor-based service that handles AI interactions using Apple's `LanguageModelSession` API
- **TrailRecommendationPayload**: Generable struct that defines the AI response schema
- **RecommendationView**: SwiftUI view with glass morphism effects and interactive UI

## How It Works

1. User taps "Generate" to request a recommendation
2. The app collects context: available trails, weather, preferences, and nearby places
3. FoundationModelService creates a structured prompt with instructions and context
4. Apple's on-device language model generates a personalized recommendation
5. The response is parsed and displayed with the suggested trail details

```swift
let rec = try await FoundationModelService.shared.generateRecommendation(
    trails: sampleTrails,
    preferences: samplePreferences,
    weatherSummary: sampleWeather,
    nearbyPlaces: sampleNearby
)
```

## Future Enhancements

- [ ] Integration with real MapKit trail data
- [ ] Live WeatherKit integration for accurate forecasts
- [ ] User preference persistence
- [ ] Trail photos and reviews
- [ ] Route visualization on map
- [ ] Share recommendations with friends
- [ ] Offline trail database

## Built With

- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - UI framework
- [FoundationModels](https://developer.apple.com/documentation/foundationmodels) - Apple's on-device AI framework
- [CoreLocation](https://developer.apple.com/documentation/corelocation) - Location services

## Screenshots

_Coming soon_

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Alejandro Beltrán**

## Acknowledgments

- Built with Apple's FoundationModels framework introduced at WWDC 2025
- Inspired by the potential of on-device AI for privacy-preserving applications
- Glass morphism UI inspired by modern iOS design language

---

⭐️ If you found this project interesting, please consider giving it a star!
