//
//  WeatherCodeMapper.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 22/09/1447 AH.
//

import Foundation

enum WeatherCodeMapper {
    static func description(for code: Int) -> String {
        switch code {
        case 0:
            return "Clear"
        case 1, 2, 3:
            return "Cloudy"
        case 45, 48:
            return "Fog"
        case 51, 53, 55, 56, 57:
            return "Drizzle"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "Rain"
        case 71, 73, 75, 77, 85, 86:
            return "Snow"
        case 95, 96, 99:
            return "Thunderstorm"
        default:
            return "Weather"
        }
    }

    static func symbolName(for code: Int, isDay: Bool = true) -> String {
        switch code {
        case 0:
            return isDay ? "sun.max.fill" : "moon.stars.fill"
        case 1:
            return isDay ? "sun.max.fill" : "moon.fill"
        case 2, 3:
            return isDay ? "cloud.sun.fill" : "cloud.moon.fill"
        case 45, 48:
            return "cloud.fog.fill"
        case 51, 53, 55, 56, 57:
            return "cloud.drizzle.fill"
        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "cloud.rain.fill"
        case 71, 73, 75, 77, 85, 86:
            return "cloud.snow.fill"
        case 95, 96, 99:
            return "cloud.bolt.rain.fill"
        default:
            return "cloud.fill"
        }
    }
}
