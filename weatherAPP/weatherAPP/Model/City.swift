//
//  City.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 28/09/1447 AH.
//
import Foundation

struct City: Decodable, Equatable {
    let id: Int?
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
    let timezone: String?

    var displayName: String {
        [name, admin1, country]
            .compactMap { value in
                guard let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
                return value
            }
            .joined(separator: ", ")
    }

    static let riyadh = City(
    id: nil,
    name: "Riyadh",
    latitude: 24.7136,
    longitude: 46.6753,
    country: "Saudi Arabia",
    admin1: "Riyadh",
    timezone: "Asia/Riyadh"
)
}

struct GeocodingResponse: Decodable {
    let results: [City]?
}
