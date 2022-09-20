//
//  WeatherFetcher.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import Foundation
import WeatherKit
import CoreLocation
import SwiftUI
import Combine
import Network

class WeatherManager: ObservableObject{
    @Published var weather: Weather?
    @Published var locationManager = LocationManager()
    private let weatherService = WeatherService.shared
    private let monitor = NWPathMonitor()
     
    private var anyCancellable: AnyCancellable? = nil
    
    init() {
        anyCancellable = locationManager.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    var shortenedHourWeather: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) > 0
            }.prefix(24))
        } else {
            return []
        }
    }
    
    
    func requestWeatherForCurrentLocation() async {
       guard let userLocation = locationManager.userLocation else { return }
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await self.weatherService.weather(for: userLocation)
            }.value
        } catch {
            print("\(error.localizedDescription)")
            weather = nil
        }
    }
}
