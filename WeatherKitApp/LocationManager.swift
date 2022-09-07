//
//  LocationManager.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 05.09.22.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    
    var userLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocationAuthorization()
        startUpdatingUserLocalization()
        requestUserLocation()
    }
    
    func requestLocationAuthorization() {
        print("requestLocationAuthorization")
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingUserLocalization(){
        print("startUpdatingUserLocalization")
        locationManager.startUpdatingLocation()
    }
    
    func requestUserLocation(){
        print("requestUserLocation")
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
             print("error:: \(error.localizedDescription)")
        }
}
