//
//  TournamentDetailView.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import SwiftUI

struct TournamentDetailView: View {
    let detail: TournamentDetail
    @Binding var selectedPlayer: Player?

    var body: some View {
        List {
            Section("Last updated") {
                Text(detail.updatedAtISO).font(.caption).foregroundStyle(.secondary)
            }

            Section("Course notes") {
                ForEach(detail.notes, id: \.self) { note in
                    Text(note)
                }
            }

            Section("Weights") {
                ForEach(detail.weights) { w in
                    HStack {
                        Text(w.category.displayName)
                        Spacer()
                        Text(String(format: "%.0f%%", w.weight * 100))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Players") {
                ForEach(detail.players) { p in
                    Button {
                        selectedPlayer = p
                    } label: {
                        HStack {
                            Text(p.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
        }
    }
}
