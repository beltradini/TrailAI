//
//  RecommendationView.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 9/25/25.
//

import SwiftUI
import CoreLocation

struct RecommendationView: View {
    @State private var isGenerating = false
    @State private var recommendation: Recommendation? = nil
    @State private var errorMessage: String? = nil

    // Demo data for now; wire your real MapKit/WeatherKit data here
    private let sampleTrails: [Trail] = [
        Trail(name: "Riverside Loop", location: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090), difficulty: "Easy", estimatedTime: 45 * 60),
        Trail(name: "Summit Ascent", location: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0307), difficulty: "Hard", estimatedTime: 95 * 60),
        Trail(name: "Cafe Stroll", location: CLLocationCoordinate2D(latitude: 37.332, longitude: -122.029), difficulty: "Easy", estimatedTime: 30 * 60)
    ]

    private let samplePreferences = ["hiking", "cafes", "short walks"]
    private let sampleWeather = ["Sunny with a light breeze"]
    private let sampleNearby = ["Blue Bottle Coffee", "City Park Cafe"]

    var body: some View {
        ZStack {
            // Background content to show through glass
            LinearGradient(colors: [.blue.opacity(0.4), .green.opacity(0.4)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("TrailAI Recommendations")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.primary)

                GlassEffectContainer(spacing: 32) {
                    VStack(spacing: 16) {
                        Group {
                            if let recommendation {
                                Text(recommendation.message)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            } else if let errorMessage {
                                Text(errorMessage)
                                    .font(.callout)
                                    .foregroundStyle(.red)
                                    .padding()
                            } else {
                                Text("Tap Generate to get a smart suggestion based on weather and your preferences.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                        }
                        .glassEffect(.regular.tint(.blue.opacity(0.2)).interactive(), in: .rect(cornerRadius: 20))

                        Button(action: generate) {
                            HStack(spacing: 8) {
                                if isGenerating { ProgressView().tint(.white) }
                                Text(isGenerating ? "Generating…" : "Generate")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glassProminent)
                        .disabled(isGenerating)
                    }
                    .padding()
                }
                .padding(.horizontal)

                if let trail = recommendation?.suggestedTrail {
                    VStack(spacing: 8) {
                        Text("Suggested Trail: \(trail.name)")
                            .font(.headline)
                        Text("Difficulty: \(trail.difficulty)")
                            .font(.subheadline)
                    }
                    .padding()
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
                }

                Spacer()
            }
            .padding(.top, 40)
        }
    }

    @MainActor
    private func generate() {
        isGenerating = true
        errorMessage = nil
        Task {
            do {
                let rec = try await FoundationModelService.shared.generateRecommendation(
                    trails: sampleTrails,
                    preferences: samplePreferences,
                    weatherSummary: sampleWeather,
                    nearbyPlaces: sampleNearby
                )
                recommendation = rec
            } catch {
                errorMessage = error.localizedDescription
            }
            isGenerating = false
        }
    }
}

#Preview {
    RecommendationView()
}
