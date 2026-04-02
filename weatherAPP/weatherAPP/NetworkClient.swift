//
//  NetworkClient.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 12/10/1447 AH.
//

import Foundation

protocol NetworkClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

struct NetworkClient: NetworkClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let apiMessage = try? JSONDecoder().decode(APIErrorPayload.self, from: data)
            throw APIError.server(message: apiMessage?.reason ?? "Request failed with status code \(httpResponse.statusCode).")
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}

