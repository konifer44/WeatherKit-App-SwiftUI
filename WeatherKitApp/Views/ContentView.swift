//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import SwiftUI
import Combine
import WeatherKit


struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack{
            if let weather = viewModel.weatherManager.weather  {
                ScrollView {
                    VStack {
                        Spacer(minLength: 110)
                        CityAndTemperatureView(weather: weather, viewModel: viewModel)
                        
                        Spacer(minLength: 50)
                        HourlyForecastView(weather: weather, viewModel: viewModel)
                        
                        DailyForecastView(weather: weather)
                        Spacer()
                    }
                }
            } else {
               // NoInternetConnectionView()
                VStack{
                    Spacer()
                    Text("Requesting weather")
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 40)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .frame(maxWidth: .infinity)
        .background{
            Image("clouds")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            await viewModel.weatherManager.requestWeatherForCurrentLocation()
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}








