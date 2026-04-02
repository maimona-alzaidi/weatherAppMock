//
//  OpenMeteoService.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
//
import Foundation

protocol WeatherServicing {
    func fetchWeather(for city: City) async throws -> ForecastResponse
}

struct OpenMeteoService: WeatherServicing {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }

    func fetchWeather(for city: City) async throws -> ForecastResponse {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(city.latitude)),
            URLQueryItem(name: "longitude", value: String(city.longitude)),
            URLQueryItem(name: "current", value: [
                "temperature_2m",
                "apparent_temperature",
                "relative_humidity_2m",
                "precipitation",
                "weather_code",
                "wind_speed_10m",
                "pressure_msl",
                "is_day"
            ].joined(separator: ",")),
            URLQueryItem(name: "hourly", value: [
                "temperature_2m",
                "weather_code",
                "precipitation_probability"
            ].joined(separator: ",")),
            URLQueryItem(name: "daily", value: [
                "weather_code",
                "temperature_2m_max",
                "temperature_2m_min",
                "uv_index_max",
                "sunrise",
                "sunset",
                "precipitation_sum",
                "wind_speed_10m_max"
            ].joined(separator: ",")),
            URLQueryItem(name: "forecast_days", value: "10"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        return try await client.fetch(ForecastResponse.self, from: url)
    }
}

