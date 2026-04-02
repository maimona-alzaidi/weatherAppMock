//
//  ForecastResponse.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 11/10/1447 AH.
//

import Foundation

struct ForecastResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}

struct CurrentWeather: Decodable {
    let time: String
    let temperature: Double
    let apparentTemperature: Double
    let relativeHumidity: Double
    let precipitation: Double
    let weatherCode: Int
    let windSpeed: Double
    let pressure: Double
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity = "relative_humidity_2m"
        case precipitation
        case weatherCode = "weather_code"
        case windSpeed = "wind_speed_10m"
        case pressure = "pressure_msl"
        case isDay = "is_day"
    }
}

struct HourlyWeather: Decodable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
    let precipitationProbability: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
        case precipitationProbability = "precipitation_probability"
    }
}

struct DailyWeather: Decodable {
    let time: [String]
    let weatherCode: [Int]
    let maxTemperature: [Double]
    let minTemperature: [Double]
    let uvIndexMax: [Double]
    let sunrise: [String]
    let sunset: [String]
    let precipitationSum: [Double]
    let windSpeedMax: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case maxTemperature = "temperature_2m_max"
        case minTemperature = "temperature_2m_min"
        case uvIndexMax = "uv_index_max"
        case sunrise
        case sunset
        case precipitationSum = "precipitation_sum"
        case windSpeedMax = "wind_speed_10m_max"
    }
}

