//
//  TournamentStore.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import Foundation
import SwiftUI
import Combine

@MainActor
final class TournamentStore: ObservableObject {

    let objectWillChange = ObservableObjectPublisher()

    // Your GitHub Pages index URL:
    private let indexURL = "https://jwkyle.github.io/pga-tourney-data/index.json"

    @Published var index: IndexResponse?
    @Published var selectedTournament: TournamentSummary?
    @Published var tournamentDetail: TournamentDetail?
    @Published var selectedPlayer: Player?

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let api = APIClient()

    func loadCached() {
        if let data = Cache.shared.load(name: "index.json"),
           let decoded = try? JSONDecoder().decode(IndexResponse.self, from: data) {
            self.index = decoded
            self.selectedTournament = decoded.tournaments.first
        }
    }

    func refreshIndex() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: indexURL)!)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw APIError.badStatus(http.statusCode)
            }

            Cache.shared.save(data, as: "index.json")

            let decoded = try JSONDecoder().decode(IndexResponse.self, from: data)
            self.index = decoded

            if selectedTournament == nil {
                selectedTournament = decoded.tournaments.first
            }
        } catch {
            errorMessage = "Failed to load tournaments."
        }
    }

    func loadTournamentDetail(for summary: TournamentSummary) async {
        isLoading = true
        errorMessage = nil
        selectedPlayer = nil
        defer { isLoading = false }

        // Try cache first for instant UI
        let cacheName = "\(summary.id).json"
        if let cached = Cache.shared.load(name: cacheName),
           let decoded = try? JSONDecoder().decode(TournamentDetail.self, from: cached) {
            self.tournamentDetail = decoded
        }

        // Fetch latest
        do {
            let (data, response) = try await URLSession.shared.data(from: URL(string: summary.detailUrl)!)
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                throw APIError.badStatus(http.statusCode)
            }

            Cache.shared.save(data, as: cacheName)
            let decoded = try JSONDecoder().decode(TournamentDetail.self, from: data)
            self.tournamentDetail = decoded
        } catch {
            if tournamentDetail == nil {
                errorMessage = "Failed to load tournament details."
            }
        }
    }
}
