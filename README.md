# Breaker Simulator

An iOS simulation game built with SwiftUI. Players select a local save slot,
open progressively higher-tier virtual card packs, and grow an in-game follower
count through randomized rewards.

## Features

- Four persistent, locally stored save slots backed by `Codable` JSON.
- Pack-progression system that unlocks Silver, Gold, and Hobby tiers as the
  follower count increases.
- Weighted reward generation and animated pack-opening feedback.
- SwiftUI navigation, reusable views, and layouts designed for multiple device
  sizes.

## Run Locally

1. Install a current version of Xcode.
2. Open `Breaker Simulator.xcodeproj`.
3. Allow Swift Package Manager to resolve the checked-in dependencies.
4. Select an iOS simulator or connected device, then build and run.

The project pins its Swift Package Manager dependencies in
`Package.resolved` for reproducible installs.

## Project Structure

```text
Breaker Simulator/Views/  SwiftUI screens and shared UI components
Breaker Simulator/Save/   Save-slot models and local persistence
Breaker Simulator/Gifs/   Animated pack-opening assets
Breaker Simulator/Assets.xcassets/  App artwork and image resources
```

## Notes

This is a personal learning project. Save data is stored only in the app's
Documents directory on the local device or simulator.
