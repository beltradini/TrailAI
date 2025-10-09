//
//  Trail.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 9/25/25.
//

import Foundation
import CoreLocation

struct Trail: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let difficulty: String
    let estimatedTime: TimeInterval
}
