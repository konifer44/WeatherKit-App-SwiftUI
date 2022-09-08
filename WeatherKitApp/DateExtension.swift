//
//  DateExtension.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 08.09.22.
//

import Foundation
extension Date {
    func weekDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: self )
        return weekDay
    }
}
