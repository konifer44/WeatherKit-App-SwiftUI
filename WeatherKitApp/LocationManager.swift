//
//  LocationManager.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject{
    @Published var city: String = ""
    
    private let locationManager = CLLocationManager()
    private var isLocationManagerAuthorised: Bool = false
    var userLocation: CLLocation?
   
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        requestUserLocation()
    }
    
    func getCityforCurrentLocation(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        guard let userLocation = userLocation else { return }
        CLGeocoder().reverseGeocodeLocation(userLocation) { placemarks, error in
            completion(placemarks?.first?.locality, error)
        }
    }
    
    func requestUserLocation(){
        guard isLocationManagerAuthorised else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
        locationManager.stopUpdatingLocation() //presevring battery life
        
        getCityforCurrentLocation { [weak self] city, error in
            guard error == nil else {
                print("no location yet")
                return
            }
            self?.city = city ?? "Unknown City"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            isLocationManagerAuthorised = true
        case .authorizedWhenInUse:
            isLocationManagerAuthorised = true
        case .denied:
            isLocationManagerAuthorised = false
        case .notDetermined:
            isLocationManagerAuthorised = false
        case .restricted:
            isLocationManagerAuthorised = false
        
        @unknown default:
            fatalError("Location Manager Authorization Status Error")
        }
    }
}


