//
//  WeatherKitAppWidget.swift
//  WeatherKitAppWidget
//
//  Created by Jan Konieczny on 22.09.22.
//

import WidgetKit
import SwiftUI
import Intents
import WeatherKit

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), weather: nil, city: nil)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let weatherManager = WeatherManager()
        let city = weatherManager.locationManager.city
        Task {
            let weather = await weatherManager.requestWeatherForCurrentLocation2()
            if let weather = weather {
                let entry = SimpleEntry(date: Date(), configuration: configuration, weather: weather, city: city)
                completion(entry)
            } else {
                let entry = SimpleEntry(date: Date(), configuration: configuration, weather: nil, city: "Poznań")
                completion(entry)
            }
        }
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let weatherManager = WeatherManager()
        let city = weatherManager.locationManager.city
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        
        Task {
            let weather = await weatherManager.requestWeatherForCurrentLocation2()
            if let weather = weather {
                let entry = SimpleEntry(date: Date(), configuration: configuration, weather: weather, city: city)
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            } else {
                let entry = SimpleEntry(date: Date(), configuration: configuration, weather: nil, city: "Poznań")
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let weather: Weather?
    let city: String?
}

struct WeatherKitAppWidgetEntryView : View {
    let gradient = LinearGradient(colors: [.blue, .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(spacing: 3) {
                Text(entry.city ?? "Poznań")
                Image(systemName: "location.fill")
                    .font(.system(size: 8))
                Text(entry.date, style: .timer)
            }
            Text(entry.weather?.currentWeather.temperature.description ?? "14°")
                .font(.largeTitle)
            Spacer()
            
            VStack(alignment: .leading, spacing: 2){
                Image(systemName: entry.weather?.currentWeather.symbolName ?? "cloud.fill")
                Text(entry.weather?.currentWeather.condition.description ?? "Cloudy")
                HStack{
                    Text("L: \(entry.weather?.dailyForecast.first?.lowTemperature.description ?? "5")°")
                    Text("H: \(entry.weather?.dailyForecast.first?.highTemperature.description ?? "16")°")
                }
            }
            .font(.caption)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Image("clouds")
                .offset(x: 200, y: -120))
        
    }
}

@main
struct WeatherKitAppWidget: Widget {
    let kind: String = "WeatherKitAppWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherKitAppWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Weather")
        .description("Get the latest forecast")
    }
}

struct WeatherKitAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherKitAppWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),  weather: nil, city: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
