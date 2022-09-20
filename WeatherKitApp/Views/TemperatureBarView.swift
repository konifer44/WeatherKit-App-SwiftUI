//
//  SwiftUIView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 15.09.22.
//

import SwiftUI

struct TemperatureBarView: View {
    @State var currentTemp: Double
    @State var minTemp: Double
    @State var maxTemp: Double
    @State var isToday: Bool
    
    var minValue: CGFloat
    var maxValue: CGFloat
    
    init(currentTemp: Double, minTemp: Double, maxTemp: Double, isToday: Bool) {
        self.currentTemp = currentTemp
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.isToday = isToday
        self.minValue = abs(minTemp) * 1.5
        self.maxValue = abs(maxTemp) * 1.5
    }
    let gradient = LinearGradient(colors: [
        Color(.blue).opacity(0.3),
        Color(.yellow),
    ],startPoint: .leading, endPoint: .trailing)
    
    func countWidth(in geometry: GeometryProxy) -> CGFloat{
        let width = ((abs(minTemp) + abs(maxTemp)) / (abs(minValue) + abs(maxValue))) * geometry.size.width
        return width
    }
    
    func countOffset(in geometry: GeometryProxy) -> CGFloat {
        return (abs(minValue) - abs(minTemp)) / (abs(minValue) + abs(maxValue)) * geometry.size.width
    }
    
    func countDotOffset(in geometry: GeometryProxy) -> CGFloat {
        return countOffset(in: geometry) + currentTemp / maxTemp * countWidth(in: geometry) + (currentTemp > ((minTemp + maxTemp) / 2) ? -(geometry.size.height) : 0)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.gray.opacity(0.5))
            
            RoundedRectangle(cornerRadius: 35)
                .fill(gradient)
                .mask {
                    GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 35)
                                .padding(1)
                                .shadow(radius: 10)
                                .frame(width: countWidth(in: geometry))
                                .offset(x: countOffset(in: geometry))
                    }
                }
            if isToday{
                GeometryReader { geometry2 in
                    Circle()
                        .fill(.white)
                        .padding(2)
                        .shadow(radius: 1)
                        .offset(x:  countDotOffset(in: geometry2))
                }
            }
        }
    }
}


struct TemperatureBarView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureBarView(currentTemp: 5, minTemp: 5, maxTemp: 8, isToday: true)
            .frame(height: 20)
            .frame(width: 200)
    }
}
