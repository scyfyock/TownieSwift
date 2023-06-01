//
//  FullMap.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/22/23.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationTrackingViewControl: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var previousTime = -10
    
    
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

    }
    
    public func startTracking() {
        self.locationManager.startUpdatingLocation()
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
            case .denied:
                print("Denied")
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                print("Unknown authorizationStatus \(locationManager.authorizationStatus)")
                break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let date = Date()
        let time = Calendar.current
        let seconds = time.component(.second, from: date)
        
        print(seconds)
        print(previousTime)
        
        if(seconds > previousTime + 2) {
            CLGeocoder().reverseGeocodeLocation(locations[0]) { placemarks, error in
                if let error { print("This is an error: \(error)")}
                else if let placemarks {
                    print(placemarks.first)
                    self.previousTime = seconds
                    if(self.previousTime + 2 >= 60) { self.previousTime = self.previousTime - 60 }
                }
//                check time have an if at the beginning checking if it has been 5 seconds since the last time this function was called, if it is then do not call the function, break or something
            }
        }
        else {
            return
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askForLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager?.requestAlwaysAuthorization()
    }
    
    
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//
//        locationManager?.requestAlwaysAuthorization()
//    }
    
//    final class mapDisplay: NSObject, ObservableObject, CLLocationManagerDelegate {
//
//        var locationMan: CLLocationManager?
//
//        func checkLocationServices() {
//            if CLLocationManager.locationServicesEnabled() {
//                locationMan = CLLocationManager()
//                locationMan!.delegate = self
//            }
//            else {
//                print("Incorrect")
//            }
//        }
//
//        private func askForLocation() {
//            guard let locationMan else {
//                return
//            }
//
//            switch locationMan.authorizationStatus {
//                case .notDetermined:
//                    locationMan.requestWhenInUseAuthorization()
//                case .restricted:
//                    print("Restricted")
//                case .denied:
//                    print("Denied")
//                case .authorizedAlways, .authorizedWhenInUse:
//                    break
//                @unknown default:
//                add print here
//                    break
//            }
//        }
//
//        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//            askForLocation()
//        }
//
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
//            locationMan?.requestAlwaysAuthorization()
//        }
//    }
    

}



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
