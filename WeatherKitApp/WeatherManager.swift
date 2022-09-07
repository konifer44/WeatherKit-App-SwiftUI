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

class WeatherManager: ObservableObject{
    private let weatherService = WeatherService.shared
    let locationManager = LocationManager()
    
    
    func requestWeatherForCurrentLocation() async {
        print("requestWeatherForCurrentLocation")
       // locationManager.requestUserLocation()
        guard let userLocation = locationManager.userLocation else { return }
        
        do {
            let weather = try await weatherService.weather(for: userLocation)
            let termperature = weather.currentWeather.temperature
            print("Current temp: \(termperature)")
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    
    @State var weather: Weather?
    
    func requestWeather() async {
        let location: CLLocation =
        CLLocation(
                latitude: .init(floatLiteral: 37.322998),
                longitude: .init(floatLiteral: -122.032181)
            )
        
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await self.weatherService.weather(for:location)
            }.value
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
