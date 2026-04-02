//
//  WeatherViewModel.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 23/09/1447 AH.
//
import UIKit

struct HourlyItemViewData {
    let date: Date
    let timeText: String
    let temperatureText: String
    let symbolName: String
    let precipitationText: String
}

struct DailyItemViewData {
    let date: Date
    let weekdayText: String
    let lowText: String
    let highText: String
    let symbolName: String
    let normalizedStart: CGFloat
    let normalizedEnd: CGFloat
}

struct WeatherDetailItem {
    let title: String
    let value: String
    let subtitle: String
}

struct WeatherScreenData {
    let cityName: String
    let currentTemperatureText: String
    let conditionText: String
    let highLowText: String
    let hourlyItems: [HourlyItemViewData]
    let dailyItems: [DailyItemViewData]
    let detailItems: [WeatherDetailItem]
    let isDay: Bool
}

struct DaySummary {
    let title: String
    let message: String
}

@MainActor
final class WeatherViewModel {
    enum State {
        case idle
        case loading
        case loaded(WeatherScreenData)
        case error(String)
    }

    private let weatherService: WeatherServicing
    private(set) var selectedCity: City
    private(set) var latestResponse: ForecastResponse?

    var onStateChange: ((State) -> Void)?

    init(
        selectedCity: City = .riyadh,
        weatherService: WeatherServicing = OpenMeteoService()
    ) {
        self.selectedCity = selectedCity
        self.weatherService = weatherService
    }

    func loadWeather() {
        onStateChange?(.loading)

        Task {
            do {
                let response = try await weatherService.fetchWeather(for: selectedCity)
                latestResponse = response
                let data = mapResponseToScreenData(response, city: selectedCity)
                onStateChange?(.loaded(data))
            } catch {
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                onStateChange?(.error(message))
            }
        }
    }

    func updateCity(_ city: City) {
        selectedCity = city
        loadWeather()
    }

    func daySummary(for date: Date) -> DaySummary? {
        guard let response = latestResponse else { return nil }

        for index in response.daily.time.indices {
            guard let dailyDate = WeatherDateFormatter.dailyDate(from: response.daily.time[index], timezoneID: response.timezone) else {
                continue
            }

            if WeatherDateFormatter.isSameDay(dailyDate, date, timezoneID: response.timezone) {
                let title = "\(selectedCity.name) • \(WeatherDateFormatter.shortDateTitle(from: dailyDate, timezoneID: response.timezone))"
                let condition = WeatherCodeMapper.description(for: response.daily.weatherCode[index])
                let high = Int(response.daily.maxTemperature[index].rounded())
                let low = Int(response.daily.minTemperature[index].rounded())
                let wind = Int(response.daily.windSpeedMax[index].rounded())
                let rain = Int(response.daily.precipitationSum[index].rounded())
                let uv = Int(response.daily.uvIndexMax[index].rounded())
                let sunrise = WeatherDateFormatter.shortTimeTitle(from: response.daily.sunrise[index], timezoneID: response.timezone)
                let sunset = WeatherDateFormatter.shortTimeTitle(from: response.daily.sunset[index], timezoneID: response.timezone)

                let message = """
                Condition: \(condition)
High: \(high)°
Low: \(low)°
Wind: \(wind) km/h
Rain: \(rain) mm
UV Index: \(uv)
Sunrise: \(sunrise)
Sunset: \(sunset)
"""
                return DaySummary(title: title, message: message)
            }
        }

        return nil
    }

    private func mapResponseToScreenData(_ response: ForecastResponse, city: City) -> WeatherScreenData {
        let isDay = response.current.isDay == 1
        let todayHigh = Int(response.daily.maxTemperature.first?.rounded() ?? 0)
        let todayLow = Int(response.daily.minTemperature.first?.rounded() ?? 0)
        let currentTemperature = Int(response.current.temperature.rounded())
        let condition = WeatherCodeMapper.description(for: response.current.weatherCode)

        let hourlyItems = makeHourlyItems(from: response)
        let dailyItems = makeDailyItems(from: response)
        let detailItems = makeDetailItems(from: response)

        return WeatherScreenData(
            cityName: city.displayName,
            currentTemperatureText: "\(currentTemperature)°",
            conditionText: condition,
            highLowText: "H: \(todayHigh)°   L: \(todayLow)°",
            hourlyItems: hourlyItems,
            dailyItems: dailyItems,
            detailItems: detailItems,
            isDay: isDay
        )
    }

    private func makeHourlyItems(from response: ForecastResponse) -> [HourlyItemViewData] {
        let maxItems = min(24, response.hourly.time.count)
        guard maxItems > 0 else { return [] }

        var result: [HourlyItemViewData] = []
        for index in 0..<maxItems {
            guard let date = WeatherDateFormatter.hourlyDate(from: response.hourly.time[index], timezoneID: response.timezone) else {
                continue
            }

            let temp = Int(response.hourly.temperature[index].rounded())
            let precipitation = Int((response.hourly.precipitationProbability?[index] ?? 0).rounded())

            result.append(
                HourlyItemViewData(
                    date: date,
                    timeText: WeatherDateFormatter.hourTitle(from: date, timezoneID: response.timezone),
                    temperatureText: "\(temp)°",
                    symbolName: WeatherCodeMapper.symbolName(for: response.hourly.weatherCode[index], isDay: response.current.isDay == 1),
                    precipitationText: "\(precipitation)%"
                )
            )
        }
        return result
    }

    private func makeDailyItems(from response: ForecastResponse) -> [DailyItemViewData] {
        let minTemp = response.daily.minTemperature.min() ?? 0
        let maxTemp = response.daily.maxTemperature.max() ?? 1
        let range = max(maxTemp - minTemp, 1)

        var items: [DailyItemViewData] = []
        for index in response.daily.time.indices {
            guard let date = WeatherDateFormatter.dailyDate(from: response.daily.time[index], timezoneID: response.timezone) else {
                continue
            }

            let low = response.daily.minTemperature[index]
            let high = response.daily.maxTemperature[index]

            items.append(
                DailyItemViewData(
                    date: date,
                    weekdayText: index == 0 ? "Today" : WeatherDateFormatter.dayTitle(from: date, timezoneID: response.timezone),
                    lowText: "\(Int(low.rounded()))°",
                    highText: "\(Int(high.rounded()))°",
                    symbolName: WeatherCodeMapper.symbolName(for: response.daily.weatherCode[index], isDay: true),
                    normalizedStart: CGFloat((low - minTemp) / range),
                    normalizedEnd: CGFloat((high - minTemp) / range)
                )
            )
        }
        return items
    }

    private func makeDetailItems(from response: ForecastResponse) -> [WeatherDetailItem] {
        let humidity = Int(response.current.relativeHumidity.rounded())
        let wind = Int(response.current.windSpeed.rounded())
        let pressure = Int(response.current.pressure.rounded())
        let feelsLike = Int(response.current.apparentTemperature.rounded())
        let uv = Int((response.daily.uvIndexMax.first ?? 0).rounded())
        let sunrise = response.daily.sunrise.first.map { WeatherDateFormatter.shortTimeTitle(from: $0, timezoneID: response.timezone) } ?? "--"
        let sunset = response.daily.sunset.first.map { WeatherDateFormatter.shortTimeTitle(from: $0, timezoneID: response.timezone) } ?? "--"
        let precipitation = Int(response.current.precipitation.rounded())

        return [
            WeatherDetailItem(title: "Humidity", value: "\(humidity)%", subtitle: "Current relative humidity"),
            WeatherDetailItem(title: "Feels Like", value: "\(feelsLike)°", subtitle: "Perceived temperature"),
            WeatherDetailItem(title: "Wind", value: "\(wind) km/h", subtitle: "Current wind speed"),
            WeatherDetailItem(title: "Pressure", value: "\(pressure) hPa", subtitle: "Sea level pressure"),
            WeatherDetailItem(title: "UV Index", value: "\(uv)", subtitle: "Maximum for today"),
            WeatherDetailItem(title: "Rain", value: "\(precipitation) mm", subtitle: "Current precipitation"),
            WeatherDetailItem(title: "Sunrise", value: sunrise, subtitle: "Today"),
            WeatherDetailItem(title: "Sunset", value: sunset, subtitle: "Today")
        ]
    }
}


