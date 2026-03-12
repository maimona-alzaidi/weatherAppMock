//
//  WeatherDateFormatter.swift
//  weatherAPP
//
//  Created by maimona alzaidi on 23/09/1447 AH.
//

import Foundation

enum WeatherDateFormatter {
    private static func makeFormatter(format: String, timezoneID: String?) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        if let timezoneID, let timeZone = TimeZone(identifier: timezoneID)
        {
            formatter.timeZone = timeZone
        }
        return formatter
    }

    
    static func hourlyDate(from string: String, timezoneID: String?) -> Date? {
        makeFormatter(format: "yyyy-MM-dd'T'HH:mm", timezoneID: timezoneID).date(from: string)
    }

    static func dailyDate(from string: String, timezoneID: String?) -> Date? {
        makeFormatter(format: "yyyy-MM-dd", timezoneID: timezoneID).date(from: string)
    }

    static func dayTitle(from date: Date, timezoneID: String?) -> String {
        let formatter = makeFormatter(format: "EEEE", timezoneID: timezoneID)
        return formatter.string(from: date)
    }

    static func hourTitle(from date: Date, timezoneID: String?) -> String {
        let formatter = makeFormatter(format: "ha", timezoneID: timezoneID)
        return formatter.string(from: date)
    }

    static func shortDateTitle(from date: Date, timezoneID: String?) -> String {
        let formatter = makeFormatter(format: "MMM d", timezoneID: timezoneID)
        return formatter.string(from: date)
    }

    static func timeTitle(from string: String, timezoneID: String?) -> String {
        guard let date = hourlyDate(from: string, timezoneID: timezoneID) else { return string }
        return hourTitle(from: date, timezoneID: timezoneID)
    }

    static func shortTimeTitle(from string: String, timezoneID: String?) -> String {
        guard let date = hourlyDate(from: string, timezoneID: timezoneID) else { return string }
        let formatter = makeFormatter(format: "h:mm a", timezoneID: timezoneID)
        return formatter.string(from: date)
        
    }

    
    static func isSameDay(_ lhs: Date, _ rhs: Date, timezoneID: String?) -> Bool {
        var calendar = Calendar.current
        if let timezoneID, let timeZone = TimeZone(identifier: timezoneID) {
            calendar.timeZone = timeZone
        }
        return calendar.isDate(lhs, inSameDayAs: rhs)
    }
}


