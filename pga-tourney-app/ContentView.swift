//
//  ContentView.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var store = TournamentStore()

    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            tournamentPanel
        } detail: {
            playerDetailPanel
        }
        .task {
            store.loadCached()
            await store.refreshIndex()
            if let t = store.selectedTournament {
                await store.loadTournamentDetail(for: t)
            }
        }
    }

    private var sidebar: some View {
        Group {
            if let tournaments = store.index?.tournaments {
                List(tournaments, selection: $store.selectedTournament) { t in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(t.name).font(.headline)
                        Text(t.location).font(.subheadline).foregroundStyle(.secondary)
                        Text(t.startDateISO).font(.caption).foregroundStyle(.secondary)
                    }
                    .tag(t)
                }
                .navigationTitle("Tournaments")
                .refreshable {
                    await store.refreshIndex()
                }
                .onChange(of: store.selectedTournament) { _, newValue in
                    guard let t = newValue else { return }
                    Task { await store.loadTournamentDetail(for: t) }
                }
            } else {
                ContentUnavailableView("No tournaments yet", systemImage: "trophy")
                    .navigationTitle("Tournaments")
            }
        }
    }

    private var tournamentPanel: some View {
        Group {
            if let detail = store.tournamentDetail {
                TournamentDetailView(detail: detail, selectedPlayer: $store.selectedPlayer)
                    .navigationTitle(detail.name)
                    .toolbar {
                        if store.isLoading { ProgressView() }
                    }
            } else if store.isLoading {
                ProgressView("Loading…")
            } else {
                ContentUnavailableView("Select a tournament", systemImage: "list.bullet")
            }
        }
    }

    private var playerDetailPanel: some View {
        Group {
            if let player = store.selectedPlayer {
                PlayerDetailView(player: player)
            } else {
                ContentUnavailableView("Select a player", systemImage: "person")
            }
        }
    }
}

