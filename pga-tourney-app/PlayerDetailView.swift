//
//  PlayerDetailView.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import SwiftUI

struct PlayerDetailView: View {
    let player: Player

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(player.name)
                    .font(.largeTitle).bold()

                GroupBox("Key stats") {
                    VStack(alignment: .leading, spacing: 8) {
                        statRow("SG: Approach", player.stats.sgApproach)
                        statRow("SG: OTT", player.stats.sgOTT)
                        statRow("Bogey Avoid %", player.stats.bogeyAvoidPct, suffix: "%")
                        statRow("SG: Putting (Poa adj)", player.stats.sgPuttingPoaAdj)
                        statRow("Scrambling %", player.stats.scramblingPct, suffix: "%")
                    }
                }

                GroupBox("Course history") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(player.courseHistory, id: \.self) { item in
                            Text("• \(item)")
                        }
                    }
                }

                GroupBox("Bet targets") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(player.betTargets) { t in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(t.market.displayName).font(.headline)
                                Text("Bet if ≥ \(formatAmerican(t.minAmericanOdds))")
                                    .font(.subheadline).foregroundStyle(.secondary)
                                Text(t.note).font(.subheadline)
                            }
                            Divider()
                        }
                    }
                }

                GroupBox("Live bet triggers") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(player.liveTriggers) { r in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(r.title).font(.headline)
                                ForEach(r.conditions, id: \.self) { c in
                                    Text("• \(c)").font(.subheadline)
                                }
                                Text("Action: \(r.action)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Divider()
                        }
                    }
                }
            }
            .padding()
        }
    }

    private func statRow(_ label: String, _ value: Double, suffix: String = "") -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(String(format: "%.2f%@", value, suffix))
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }

    private func formatAmerican(_ n: Int) -> String {
        n >= 0 ? "+\(n)" : "\(n)"
    }
}
