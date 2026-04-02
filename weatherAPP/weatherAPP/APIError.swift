//
//  APIError.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 11/10/1447 AH.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case server(message: String)
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        case .invalidResponse:
            return "The server returned an invalid response."
        case .server(let message):
            return message
        case .decoding:
            return "The app could not read the weather data."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}

struct APIErrorPayload: Decodable {
    let error: Bool?
    let reason: String?
}
