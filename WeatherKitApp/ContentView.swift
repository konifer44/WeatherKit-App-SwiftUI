//
//  ContentView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import SwiftUI

class ContentViewViewModel: ObservableObject {
    @ObservedObject var weatherManager = WeatherManager()
    
    
   
}

struct ContentView: View {
    @StateObject private var contentViewViewModel = ContentViewViewModel()
    
    var body: some View {
        ScrollView {
            
            Button {
                Task{
                    await contentViewViewModel.weatherManager.requestWeather()
                    print(contentViewViewModel.weatherManager.weather?.currentWeather.temperature as Any)
                }
            } label: {
                Text("Request Weather")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(30)
            }
            
            Button {
                print(contentViewViewModel.weatherManager.locationManager.userLocation as Any)
            } label: {
                Text("Print Location")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(30)
            }

            VStack {
                Spacer(minLength: 50)
                VStack{
                    Text("Poznań")
                        .font(.title)
                    Text("19°")
                        .font(.system(size: 80))
                    Text("Clear")
                    HStack{
                        Text("H: 29°")
                        Text("L: 10°")
                    }
                }
                .foregroundColor(.white)
                
                Spacer(minLength: 50)
                VStack(alignment: .leading){
                    Text("Clear conditions will continue for the rest of the day")
                        .font(.caption)
                    Divider()
                        
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(0..<10){ _ in
                                VStack(spacing: 15){
                                    Text("21")
                                    Image(systemName: "moon.stars.fill")
                                    Text("17°")
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
        
                    
                    
                    ForEach(0..<10){ _ in
                        
                        HStack{
                            Text("Day")
                            Spacer()
                            Image(systemName: "cloud")
                            Spacer()
                            
                            
                            Text("10°")
                                .foregroundColor(Color(uiColor: .systemGray3))
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: 80, height: 10)
                            Text("21°")
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
        .background(Color.blue.opacity(0.6))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
