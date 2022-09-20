//
//  NoInternetConnectionView.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 20.09.22.
//

import SwiftUI

struct NoInternetConnectionView: View {
    var body: some View {
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


struct NoInternetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetConnectionView()
    }
}
