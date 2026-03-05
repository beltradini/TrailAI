//
//  RouteCard.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 3/5/26.
//

import SwiftUI
import Foundation

struct RouteCard: View {
    let route: Route
    
    var tagColor: Color {
        switch route.tag {
        case "Easy": return .green
        case "Moderate": return .orange
        case "Difficult": return .red
        case "Circular": return .blue
        case "Lineal": return .purple
        case "Viewer": return .teal
        case "River": return .cyan
        case "Wood": return .mint
        case "Coast": return .indigo
        default: return .accentColor
        }
    }
    
    var distanceText: String {
        String(format: "%.1f km", route.distance)
    }
    
    var elevationText: String { "↑\(route.elevationGain)m" }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Image(systemName: route.symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.primary)
                    .glassEffect(.regular.tint(tagColor.opacity(0.35)).interactive(), in: .circle)
                
                Spacer(minLength: 0)
                
                TagChip(text: route.tag, color: tagColor)
            }
            
            Text(route.title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            
            HStack(spacing: 12) {
                Label(distanceText, systemImage: "figure.walk")
                Label(elevationText, systemImage: "mountain.2")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
            RatingView(rating: route.rating)
                .padding(.top, 2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.clear)
                .glassEffect(.regular.tint(tagColor.opacity(0.15)).interactive(), in: .rect(cornerRadius: 16))
        }
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(route.title), \(route.tag), \(distanceText), \(elevationText), valoración \(String(format: "%.1f", route.rating))")

    }
    
    private struct TagChip: View {
        let text: String
        let color: Color
        
        var body: some View {
            Text(text)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background {
                    Capsule().fill(.clear)
                        .glassEffect(.regular.tint(color.opacity(0.35)).interactive())
                }
                .foregroundStyle(.primary)
                .accessibilityLabel("Label: \(text)")
        }
    }
    
    private struct RatingView: View {
        let rating: Double
        
        var body: some View {
            HStack(spacing: 2) {
                let full = Int(rating.rounded(.down))
                let partial = rating - Double(full)
                
                ForEach(0..<5, id: \.self) { idx in
                    if idx < full {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                    } else if idx == full && partial > 0.5 {
                        Image(systemName: "star.leadinghalf.filled").foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "star").foregroundStyle(.secondary)
                    }
                }
                Text(String(format: "%.1f", rating))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel("Valuate: \(String(format: "%.1f", rating)) of 5")
        }
    }
}
