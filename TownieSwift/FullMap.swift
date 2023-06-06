//
//  FullMap.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/22/23.
//

import SwiftUI
import CoreLocation
import MapKit
//
//class LocationTrackingViewControl: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager!
//    var previousTime = -10
////    var locationDetails: [[String]] = [[]]
//    var placesTraveled: [String] = []
//
//    override init() {
//        super.init()
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//    }
//
//    public func startTracking() {
//        self.locationManager.startUpdatingLocation()
//    }
//
//    public func stopTracking() {
//        self.locationManager.stopUpdatingLocation()
//    }
//
//    private func askForLocation() {
//        guard let locationManager else {
//            return
//        }
//
//        switch locationManager.authorizationStatus {
//            case .notDetermined:
//                locationManager.requestAlwaysAuthorization()
//
//            case .restricted:
//                print("Restricted")
//            case .denied:
//                print("Denied")
//            case .authorizedAlways, .authorizedWhenInUse:
//                break
//            @unknown default:
//                print("Unknown authorizationStatus \(locationManager.authorizationStatus)")
//                break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let date = Date()
//        let time = Calendar.current
//        let seconds = time.component(.second, from: date)
//
//        if(seconds > previousTime + 2) {
//            CLGeocoder().reverseGeocodeLocation(locations[0]) { placemarks, error in
//                if let error { print("This is an error: \(error)")}
//                else if let placemarks {
//                    if(!self.placesTraveled.contains(placemarks.first?.locality ?? "")) {
//                        self.placesTraveled.append(placemarks.first?.locality ?? "")
//                    }
////                    if(!self.locationDetails.contains(placemarks.first?.thoroughfare ?? "")) {
////                        self.locationDetails.append(contentsOf: [placemarks.first?.thoroughfare ?? "", placemarks.first?.locality ?? "", placemarks.first?.postalCode ?? "", placemarks.first?.administrativeArea ?? ""])
////                    }
//                    self.previousTime = seconds
//                    if(self.previousTime + 3 >= 60) { self.previousTime = self.previousTime - 60 }
//                    print(self.placesTraveled)
//                }
//            }
//        }
//        else {
//            return
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        askForLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
//        locationManager?.requestAlwaysAuthorization()
//    }
//
//}



struct FullMap: View {
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 25.7617,
                longitude: 80.1918
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 10,
                longitudeDelta: 10
            )
        )
    
    let map = LocationTrackingViewControl()
    
     
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
                map.startTracking()
            }
    }
}


struct FullMap_Previews: PreviewProvider {
    static var previews: some View {
        FullMap()
    }
}
