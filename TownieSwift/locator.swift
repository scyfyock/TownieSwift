//
//  locator.swift
//  TownieSwift
//
//  Created by Colin Fyock on 6/1/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

public class locator: NSObject, ObservableObject,
                                          CLLocationManagerDelegate {
    static let shared = locator()
    var hasGivenLocation: Bool
    var locationManager: CLLocationManager!
    var previousTime = -10
    @Published var placesTraveled: [String]
    @Published var currentLocation: [String]
    
    override init() {
        self.placesTraveled = []
        self.currentLocation = ["", "", "", ""]
        self.hasGivenLocation = true
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func deniedPermission() -> Binding<Bool> {
        let binding = Binding<Bool>(get: { !self.hasGivenLocation }, set: { _ in })
        return binding
    }
    
    public func getPlacesTraveled() -> String {
        return placesTraveled.joined(separator: "\n")
    }
    
    public func getCurrentLocation() -> [String] {
//        print(currentLocation)
        return currentLocation
    }
    
    public func startTracking() {
        self.locationManager.startUpdatingLocation()
    }
    
    public func stopTracking() {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    private func askForLocation() {
        guard let locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Restricted")
            hasGivenLocation = false
        case .denied:
            print("Denied")
            hasGivenLocation = false
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            hasGivenLocation = true
            break
        @unknown default:
            print("Unknown authorizationStatus \(locationManager.authorizationStatus)")
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let date = Date()
        let time = Calendar.current
        let seconds = time.component(.second, from: date)
//        let intro = "You are now entering "
//        let speech = speakLocation.speaker


        if(seconds > previousTime + 2) {
            CLGeocoder().reverseGeocodeLocation(locations[0]) { placemarks, error in
                if let error { print("This is an error: \(error)")}
                else if let placemarks {
//                    if self.currentLocation[1] != placemarks.first?.locality ?? "" {
//                        speech.speak(speech: intro + (placemarks.first!.locality ?? ""))
//                    }

                    if(!self.currentLocation.contains(placemarks.first?.thoroughfare ?? "") || !self.currentLocation.contains(placemarks.first?.locality ?? "") || !self.currentLocation.contains(placemarks.first?.postalCode ?? "") || !self.currentLocation.contains(placemarks.first?.administrativeArea ?? "")) {
                        self.currentLocation = [placemarks.first?.thoroughfare ?? "",
                                                placemarks.first?.locality ?? "",
                                                placemarks.first?.postalCode ?? "",
                                                placemarks.first?.administrativeArea ?? ""]
                    }
                    
                    
                    if(!self.placesTraveled.contains(placemarks.first?.locality ?? "")) {
                        self.placesTraveled.append(placemarks.first?.locality ?? "")
                        
                    }
                    
                    
                    self.previousTime = seconds
                    if(self.previousTime + 3 >= 60) { self.previousTime = self.previousTime - 60 }
                }
            }
        }
        else {
            return
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askForLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager?.requestAlwaysAuthorization()
    }
    
}
