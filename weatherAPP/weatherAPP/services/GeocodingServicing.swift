//
//  GeocodingServicing.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 28/09/1447 AH.
//

import Foundation

protocol GeocodingServicing {
    func searchCities(query: String) async throws -> [City]
}

struct GeocodingService: GeocodingServicing {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func searchCities(query: String) async throws -> [City] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return [] }

        var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")
        components?.queryItems = [
            URLQueryItem(name: "name", value: trimmed),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let response = try await client.fetch(GeocodingResponse.self, from: url)
        return response.results ?? []
    }
}

