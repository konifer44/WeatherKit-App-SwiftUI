//
//  SystemSmallWidgetView.swift
//  WeatherAppWidgetExtension
//
//  Created by Jan Konieczny on 22.09.22.
//

import SwiftUI
import WidgetKit
struct SystemSmallWidgetView: View {
    @State var entry: Provider.Entry
    
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

//struct SystemSmallWidgetView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        SystemSmallWidgetView(entry: )
//    }
//}
