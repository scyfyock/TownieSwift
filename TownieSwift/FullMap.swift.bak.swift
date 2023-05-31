//
//  FullMap.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/22/23.
//

import SwiftUI
import CoreLocation
import MapKit

class LocationTracker : NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
}

class LocationTrackingViewControl: UIViewController, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager!.delegate = self
//        }
//        else {
//            print("Incorrect")
//        }
//    }

    private func askForLocation() {
        guard let locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askForLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
    }
    
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
    
    let map = LocationTracker()
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .edgesIgnoringSafeArea(.all)
            .onAppear() {
//                map.checkLocationServices()
            }
    }
}


struct FullMap_Previews: PreviewProvider {
    static var previews: some View {
        FullMap()
    }
}
