//
//  SwiftUIView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 15.09.22.
//

import SwiftUI

struct TemperatureBarView: View {
    let minValue: CGFloat = -10
    let maxValue: CGFloat = 20
    
    @State var minTemp: Double
    @State var maxTemp: Double
    @State var isToday: Bool
    
    let gradient = LinearGradient(colors: [
        //Color(.blue),
      //  Color(.blue).opacity(0.3),
        Color(.blue).opacity(0.3),
        Color(.yellow),
       // Color(.red).opacity(0.5)
    ],startPoint: .leading, endPoint: .trailing)
    
    func countWidth(in geometry: GeometryProxy) -> CGFloat{
        let width = ((abs(minTemp) + abs(maxTemp)) / (abs(minValue) + abs(maxValue))) * geometry.size.width
        return width
    }
    
    func countOffset(in geometry: GeometryProxy) -> CGFloat {
        return (abs(minValue) - abs(minTemp)) / (abs(minValue) + abs(maxValue)) * geometry.size.width
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color.gray.opacity(0.1))
            
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
        }
    }
}

struct TemperatureBarView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureBarView(minTemp: 7.5, maxTemp: 15, isToday: true)
            .frame(height: 10)
    }
}
