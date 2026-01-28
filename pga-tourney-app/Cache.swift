//
//  Cache.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import Foundation

final class Cache {
    static let shared = Cache()
    private init() {}

    private func fileURL(_ name: String) throws -> URL {
        let dir = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return dir.appendingPathComponent(name)
    }

    func save(_ data: Data, as name: String) {
        do {
            let url = try fileURL(name)
            try data.write(to: url, options: [.atomic])
        } catch {
            // Keep silent for MVP; you can log later.
        }
    }

    func load(name: String) -> Data? {
        do {
            let url = try fileURL(name)
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }
}
