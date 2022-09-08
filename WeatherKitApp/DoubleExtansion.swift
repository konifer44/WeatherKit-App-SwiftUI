//
//  DoubleExtansion.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 08.09.22.
//

import Foundation

extension Double {
    func roundDouble() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
