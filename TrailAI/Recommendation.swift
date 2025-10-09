//
//  Recommendation.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 9/25/25.
//

import Foundation

struct Recommendation: Identifiable {
    let id = UUID()
    let message: String
    let suggestedTrail: Trail?
}
