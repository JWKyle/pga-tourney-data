//
//  Models.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import Foundation

struct IndexResponse: Codable {
    let schemaVersion: Int
    let updatedAtISO: String
    let tournaments: [TournamentSummary]
}

struct TournamentSummary: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let startDateISO: String
    let location: String
    let detailUrl: String
}

struct TournamentDetail: Codable, Identifiable {
    let schemaVersion: Int
    let id: String
    let name: String
    let location: String
    let startDateISO: String
    let updatedAtISO: String
    let notes: [String]
    let weights: [CategoryWeight]
    let players: [Player]
}

struct CategoryWeight: Codable, Identifiable {
    let id: String
    let category: StatCategory
    let weight: Double
}

enum StatCategory: String, Codable {
    case sgApproach
    case sgOTT
    case bogeyAvoid
    case sgPuttingPoaAdj
    case scrambling

    var displayName: String {
        switch self {
        case .sgApproach: return "SG: Approach"
        case .sgOTT: return "SG: Off-the-Tee"
        case .bogeyAvoid: return "Bogey Avoidance"
        case .sgPuttingPoaAdj: return "SG: Putting (Poa adj)"
        case .scrambling: return "Scrambling"
        }
    }
}

struct Player: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let stats: PlayerStats
    let courseHistory: [String]
    let betTargets: [BetTarget]
    let liveTriggers: [TriggerRule]
}

struct PlayerStats: Codable, Hashable {
    let sgApproach: Double
    let sgOTT: Double
    let bogeyAvoidPct: Double
    let sgPuttingPoaAdj: Double
    let scramblingPct: Double
}

struct BetTarget: Codable, Identifiable, Hashable {
    let id: String
    let market: MarketType
    let minAmericanOdds: Int
    let note: String
}

enum MarketType: String, Codable {
    case outright, top5, top10, top20

    var displayName: String {
        switch self {
        case .outright: return "Outright"
        case .top5: return "Top 5"
        case .top10: return "Top 10"
        case .top20: return "Top 20"
        }
    }
}

struct TriggerRule: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let conditions: [String]
    let action: String
}

