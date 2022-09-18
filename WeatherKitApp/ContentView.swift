//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import SwiftUI
import Combine
import WeatherKit

class ContentViewViewModel: ObservableObject {
    @Published var weatherManager = WeatherManager()
    
    private var anyCancellable: AnyCancellable? = nil
    init(){
        anyCancellable = weatherManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.objectWillChange.send()
            }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack{
            if let weather = viewModel.weatherManager.weather  {
                ScrollView {
                    VStack {
                        Spacer(minLength: 50)
                        CityAndTemperatureView(weather: weather, viewModel: viewModel)
                        
                        Spacer(minLength: 50)
                        HourlyForecastView(weather: weather, viewModel: viewModel)
                        
                        DailyForecastView(weather: weather)
                    }
                }
                
            } else {
                VStack(spacing: 15) {
                    Spacer()
                    Image(systemName: "wifi.slash")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundColor(Color(uiColor: .systemGray5))
                    Text("Weather Unavailable")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text("The Weather app isn't connected to the internet. To view weather, check your connection, then try again.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(Color(uiColor: .systemGray5))
                        
                    Spacer()
                }
                .padding()
            }
        }
        
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.6))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            Task{
                await viewModel.weatherManager.requestWeatherForCurrentLocation()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HourlyForecastView: View {
    @State var weather: Weather
    @State var viewModel: ContentViewViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text(weather.dailyForecast.first?.condition.description ?? "")
                .font(.caption)
            Divider()
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(viewModel.weatherManager.shortenedHourWeather, id: \.date){ hourForecast in
                        VStack(spacing: 15){
                            Text("\(Calendar.current.component(.hour, from: hourForecast.date))")
                            Image(systemName: "\(hourForecast.symbolName).fill")
                                .symbolRenderingMode(.multicolor)
                            Text(hourForecast.temperature.formatted(.measurement(width: .narrow)).description)
                        }
                        .padding(.horizontal, 15)
                    }
                    
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(10)
        .padding()
    }
}

struct CityAndTemperatureView: View {
    @State var weather: Weather
    @State var viewModel: ContentViewViewModel
    
    var body: some View {
        VStack(spacing: 10){
            Text(viewModel.weatherManager.locationManager.city)
                .font(.title)
            Text(weather.currentWeather.temperature.formatted())
                .font(.system(size: 80))
            Text(weather.currentWeather.condition.description)
            HStack{
                Text("H: \(weather.dailyForecast.first?.highTemperature.formatted(.measurement(width: .narrow)).description ?? "")")
                Text("L: \(weather.dailyForecast.first?.lowTemperature.formatted(.measurement(width: .narrow)).description ?? "")")
            }
        }
        .redacted(reason: viewModel.weatherManager.weather == nil ? .placeholder : [])
        .foregroundColor(.white)
    }
}

struct DailyForecastView: View {
    @State var weather: Weather
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "calendar")
                Text("10- DAY FORECAST")
                Spacer()
            }
            .font(.caption)
            Divider()
            
            ForEach(weather.dailyForecast, id: \.date){ dailyForecast in
                HStack{
                    Text(dailyForecast.date.weekDay())
                        .frame(width: 50 , alignment: .leading)
                    if dailyForecast.date.timeIntervalSince(Date()) < 100 {
                        Text("DZIŚ")
                    }
                    
                    Spacer()
                    Image(systemName: "\(dailyForecast.symbolName).fill")
                        .symbolRenderingMode(.multicolor)
                    Spacer()
                    
                    
                    Text(dailyForecast.lowTemperature.formatted(.measurement(width: .narrow)).description)
                        .foregroundColor(Color(uiColor: .systemGray6))
                    TemperatureBarView(minTemp: dailyForecast.lowTemperature.value, maxTemp: dailyForecast.highTemperature.value)
                        .frame(width: 100, height: 8)
                    Text(dailyForecast.highTemperature.formatted(.measurement(width: .narrow)).description)
                }
                .padding(.top, 5)
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(.white)
        .background(Color.gray.opacity(0.4))
        .cornerRadius(10)
        .padding()
    }
}
