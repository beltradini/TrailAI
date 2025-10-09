//
//  FoundationModelService.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 9/25/25.
//

import Foundation
import FoundationModels
internal import _LocationEssentials

@Generable
struct TrailRecommendationPayload {
    var message: String
    var suggestedTrailName: String?
    var estimatedDurationMinutes: Int?
    var endNear: String?
}

actor FoundationModelService {
    static let shared = FoundationModelService()
    private init() {}
    
    func availability() -> SystemLanguageModel.Availability {
        SystemLanguageModel.default.availability
    }
    
    func generateRecommendation(
        trails: [Trail],
        preferences: [String],
        weatherSummary: [String],
        nearbyPlaces: [String] = []
    ) async throws -> Recommendation {
        // Fallback if the on-device model isn't available
        switch SystemLanguageModel.default.availability {
        case .available:
            break
        default:
            let fallbackTrail = trails.first
            let base = fallbackTrail?.name ?? "a nearby walk"
            let mins: Int
            if let t = fallbackTrail { mins = max(5, Int(t.estimatedTime / 60)) } else { mins = 45 }
            let end = nearbyPlaces.first.map { "and you'll end near \($0)" } ?? ""
            let fallback = "It's \(weatherSummary.lowercased()). I recommend \(base) (-\(mins) minutes\(end)."
            return Recommendation(message: fallback, suggestedTrail: fallbackTrail)
        }
        
        let instructions = """
            You are TrailAI, an assistant that recommends outdoot routes and places.
            Contraints: 
            - Keep the message to 1-2 sentences, friendly, second-person.
            - Reference today's weather succinctly.
            - Suggest a trail by name only if it appears in the provided options.
            - If appropriate, mention an estimated duration like “~45 minutes”.
            - Optionally mention a nearby place to end near (e.g., a cafe) if provided.
            - Be safe: avoid risky suggestions in severe weather.
            Output using the provided schema fields.
            """
        
        let trailLines = trails.map { t in
            let mins = max(5, Int(t.estimatedTime / 60))
            return "- \(t.name) - difficulty: \(t.difficulty) - est: \(mins)m - lat: \(t.location.latitude)" }.joined(separator: "\n")
        
        let nearby = nearbyPlaces.isEmpty ? "none" : nearbyPlaces.joined(separator: ", ")
        
        let prompt = """
            User preferences: \(preferences.joined(separator: ", "))
            Weather: \(weatherSummary)
            Nearby places: \(nearby)
            Trail options: \(trailLines)
            Create a concise recommendation.
            """
        
        let session = LanguageModelSession(instructions: instructions)
        let response = try await session.respond(to: prompt, generating: TrailRecommendationPayload.self)
        let payload = response.content
        
        let selectedTrail = trails.first { trail in
            guard let name = payload.suggestedTrailName else { return false }
            return trail.name.caseInsensitiveCompare(name) == .orderedSame
        }
        
        let messageFinal: String
        let trimmed = payload.message.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            messageFinal = trimmed
        } else {
            let base = selectedTrail?.name ?? "a nearby walk"
            let mins = payload.estimatedDurationMinutes ?? (selectedTrail != nil ? max(5, Int(selectedTrail!.estimatedTime / 60)) : 45)
            let end = (payload.endNear ?? nearbyPlaces.first).map {
                " and you'll end near \($0)" } ?? ""
            messageFinal = "It's \(weatherSummary.lowercased()). I recommend \(base) (- \(mins) minutes\(end)."
        }
        
        return Recommendation(message: messageFinal, suggestedTrail: selectedTrail)
    }
}
