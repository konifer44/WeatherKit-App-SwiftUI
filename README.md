# SwiftUI-Weather-App

>WeatherKit brings valuable weather information to your apps and services through a wide range of data that can help people stay up to date, safe, and prepared. It’s easy to use WeatherKit in your apps for iOS 16, iPadOS 16, macOS 13, tvOS 16, and watchOS 9 with a platform-specific Swift API

>Access to WeatherKit is included in the Apple Developer Program, which also provides all the tools, resources, and support you need to develop and distribute apps — including access to beta software, app services, testing tools, app analytics, and more.


 <h3>Requesting location and weather</h3>
  <p align="center">
  <img src="requestingWeather.PNG" alt="drawing" width="600"/>
</p>

 <h3>Homescreen Widget- still in development</h3>
  <p align="center">
  <img src="homeScreenWidget.PNG" alt="drawing" width="600"/>
</p>

 <h3>Lock Screen Widget- still in development</h3>
  <p align="center">
  <img src="lockScreenWidget.PNG" alt="drawing" width="600"/>
</p>

## Get Weather from Apple
>Using new Swift API 
```func requestWeatherForCurrentLocation() async {
       guard let userLocation = locationManager.userLocation else { return }
        do {
            weather = try await WeatherService.shared.weather(for: userLocation)
        } catch {
            print("\(error.localizedDescription)")
            weather = nil
        }
    }
```


## Tech
  - Core Location
  - SwiftUI
  - WeatherKit
 
