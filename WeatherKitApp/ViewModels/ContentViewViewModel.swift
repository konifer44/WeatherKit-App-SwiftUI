//
//  ContentViewViewModel.swift
//  WeatherKitApp
//
//  Created by Jan Konieczny on 20.09.22.
//
import SwiftUI
import Combine

class ContentViewViewModel: ObservableObject {
    @Published var weatherManager = WeatherManager()
    
    private var anyCancellable: AnyCancellable? = nil
    init(){
        anyCancellable = weatherManager.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.objectWillChange.send()
            }
    }
}
