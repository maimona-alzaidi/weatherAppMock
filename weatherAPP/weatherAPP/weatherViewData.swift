//
//  weatherViewData.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 21/09/1447 AH.
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
