//
//  APIClient.swift
//  pga-tourney-app
//
//  Created by JaKy on 1/26/26.
//
import Foundation

enum APIError: Error {
    case badURL
    case badStatus(Int)
    case decodeFailed
}

final class APIClient {
    func fetch<T: Decodable>(_ type: T.Type, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw APIError.badURL }
        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.badStatus(http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodeFailed
        }
    }
}
