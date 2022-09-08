//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import SwiftUI
import Combine
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
        ScrollView {
            if let weather = viewModel.weatherManager.weather  {
                VStack {
                    Spacer(minLength: 50)
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
                    
                    Spacer(minLength: 50)
                    VStack(alignment: .leading){
                        Text(weather.dailyForecast.first?.condition.description ?? "")
                            .font(.caption)
                        Divider()
                        
                        ScrollView(.horizontal){
                            HStack{
                                
                                ForEach(viewModel.weatherManager.shortenedHourWeather, id: \.date){ hourForecast in
                                    VStack(spacing: 15){
                                        Text("\(Calendar.current.component(.hour, from: hourForecast.date))")
                                        Image(systemName: "\(hourForecast.symbolName)")
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
                    
                    VStack(){
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

                                Spacer()
                                Image(systemName: dailyForecast.symbolName)
                                Spacer()
                                
                                
                                Text(dailyForecast.lowTemperature.formatted())
                                    .foregroundColor(Color(uiColor: .systemGray3))
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 80, height: 10)
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
                    
                    
                    
                    
                    
                    
                    
                    Text("Hello, world!")
                }
                .frame(maxWidth: .infinity)
            }
            }
                .background(Color.blue.opacity(0.6))
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
