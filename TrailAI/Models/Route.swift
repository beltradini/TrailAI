//
//  Route.swift
//  TrailAI
//
//  Created by Alejandro Beltrán on 3/4/26.
//


import Foundation

public struct Route: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let distance: Double // km
    public let elevationGain: Int // meters
    public let rating: Double // 0...5
    public let tag: String
    public let symbol: String // SF Symbol name

    public init(id: UUID = UUID(), title: String, distance: Double, elevationGain: Int, rating: Double, tag: String, symbol: String) {
        self.id = id
        self.title = title
        self.distance = distance
        self.elevationGain = elevationGain
        self.rating = rating
        self.tag = tag
        self.symbol = symbol
    }
}

// MARK: - Mock Data
public enum RouteSamples {
    /// Deterministic pseudo-random generator for reproducible datasets.
    private struct LCRandom {
        private var state: UInt64
        init(seed: UInt64) { self.state = seed &* 6364136223846793005 &+ 1 }
        mutating func next() -> UInt64 {
            state = state &* 2862933555777941757 &+ 3037000493
            return state
        }
        mutating func nextDouble() -> Double { Double(next() % 10_000) / 10_000.0 }
        mutating func nextInt(_ upperBound: Int) -> Int { Int(next() % UInt64(upperBound)) }
    }

    private static let adjectives = [
        "Mirador", "Bosque", "Costa", "Cascada", "Valle", "Pico",
        "Laguna", "Sendero", "Ribera", "Cañón", "Nevado", "Encantado",
        "Rojo", "Azul", "Verde", "Oculto", "Eterno", "Lunar"
    ]

    private static let nouns = [
        "del Sol", "del Norte", "de los Pinos", "de la Niebla", "del Águila",
        "del Río", "del Mar", "de la Luna", "del Viento", "del Fuego",
        "de las Rocas", "del Horizonte", "del Bosque", "de la Costa"
    ]

    private static let tags = [
        "Fácil", "Moderado", "Difícil", "Circular", "Lineal", "Mirador",
        "Río", "Bosque", "Costa", "Alta Montaña"
    ]

    private static let symbols = [
        "map", "leaf.fill", "mountain.2.fill", "figure.hiking", "binoculars.fill",
        "compass.drawing", "sun.max.fill", "cloud.sun.fill", "drop.fill"
    ]

    public static func generate(count: Int, seed: UInt64 = 42) -> [Route] {
        var rng = LCRandom(seed: seed ^ UInt64(count))
        var routes: [Route] = []
        routes.reserveCapacity(count)

        for i in 0..<count {
            let adj = adjectives[rng.nextInt(adjectives.count)]
            let noun = nouns[rng.nextInt(nouns.count)]
            let title = "Sendero \(adj) \(noun)"
            let distance = (rng.nextDouble() * 18.0 + 2.0).rounded(to: 1)
            let elevation = Int((rng.nextDouble() * 1400.0).rounded())
            let rating = (rng.nextDouble() * 2.0 + 3.0).rounded(to: 1) // 3.0 ... 5.0
            let tag = tags[rng.nextInt(tags.count)]
            let symbol = symbols[rng.nextInt(symbols.count)]

            routes.append(Route(
                id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012llx", UInt64(i))) ?? UUID(),
                title: title,
                distance: distance,
                elevationGain: elevation,
                rating: rating,
                tag: tag,
                symbol: symbol
            ))
        }
        return routes
    }

    public static let small: [Route] = generate(count: 32)
    public static let large: [Route] = generate(count: 2000)
    public static let xlarge: [Route] = generate(count: 5000)
}

private extension Double {
    func rounded(to places: Int) -> Double {
        let p = pow(10.0, Double(places))
        return (self * p).rounded() / p
    }
}
