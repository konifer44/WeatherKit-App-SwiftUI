//
//  CityAndTemperatureView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 20.09.22.
//

import SwiftUI
import WeatherKit

struct CityAndTemperatureView: View {
    @State var weather: Weather
    @State var viewModel: ContentViewViewModel
    
    var body: some View {
        if let dailyForecast = weather.dailyForecast.first {
            VStack(spacing: 5){
                Text(viewModel.weatherManager.locationManager.city)
                    .font(.title)
                Text("\(weather.currentWeather.temperature.value.roundDouble())°")
                    .font(.system(size: 80))
                Text(weather.currentWeather.condition.description)
                HStack{
                    Text("L: \(dailyForecast.lowTemperature.value.roundDouble())°")
                    Text("H: \(dailyForecast.highTemperature.value.roundDouble())°")
                }
            }
            .foregroundColor(.white)
        }
    }
}
