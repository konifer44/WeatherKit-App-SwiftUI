//
//  LockScreenWidget.swift
//  WeatherAppWidgetExtension
//
//  Created by Jan Konieczny on 22.09.22.
//

import SwiftUI
import WidgetKit

struct LockScreenWidget: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.2, to: 0.8)
                .stroke(Color.gray, style: StrokeStyle( lineWidth: 5, lineCap: .round))
                .overlay{
                    Circle()
                        .shadow(radius: 5)
                        .frame(width: 5)
                        .offset(x: -5, y: -22)
                }
                .rotationEffect(.degrees(90))
                .animation(.easeOut, value: 20)
                .padding(7)
              
            
            VStack(alignment: .center){
                Text("14")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.white)
                HStack(spacing: 20){
                    Text("5")
                    Text("16")
                }
             
                .font(.system(size: 10))
                .padding(.bottom, 5)
                .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(y: 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenWidget()
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
