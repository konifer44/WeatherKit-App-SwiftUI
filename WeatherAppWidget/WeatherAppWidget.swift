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
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
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
    @Environment(\.widgetFamily) private var family
    
    let gradient = LinearGradient(colors: [.blue, .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
    var entry: Provider.Entry
    
    
    var body: some View {
        switch family {
        case .systemSmall:
           SystemSmallWidgetView(entry: entry)
        
        case .accessoryCircular:
            LockScreenWidget()
        default:
            EmptyView()
        }
    }
}

@main
struct WeatherKitAppWidget: Widget {
    let kind: String = "WeatherKitAppWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherKitAppWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .accessoryCircular])
        .configurationDisplayName("Weather")
        .description("Get the latest forecast")
    }
}

struct WeatherKitAppWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherKitAppWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),  weather: nil, city: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            WeatherKitAppWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(),  weather: nil, city: nil))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
