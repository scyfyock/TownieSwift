//
//  ContentView.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/15/23.
//

import SwiftUI
import MapKit

struct initMap: View {
    @State private var userTrackingMode: MapUserTrackingMode = .follow
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
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: MapInteractionModes.all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode
        )
    }
}

final class mapDisplay: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationMan: CLLocationManager?
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationMan = CLLocationManager()
            locationMan!.delegate = self
        }
        else {
            print("Incorrect")
        }
    }
    
    private func askForLocation() {
        guard let locationMan = locationMan else {
            return
        }
        
        switch locationMan.authorizationStatus {
            case .notDetermined:
                locationMan.requestWhenInUseAuthorization()
            case .restricted:
                print("Restricted")
            case .denied:
                print("Denied")
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askForLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error, didChangeAuthorization status: CLAuthorizationStatus) {
        locationMan?.requestAlwaysAuthorization()
    }
}

struct Home: View {
    @State var switchButton = false
    @State var buttonText = "Start"
    @State private var region = MKCoordinateRegion()
    @State private var viewModel = mapDisplay()
    
    
    func switcher() {
        switchButton = !switchButton
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "house.lodge.circle")
                        .padding([.top, .leading, .bottom], 10.0)
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .font(.title)
                    Text("Townie+")
                        .font(.title)
                        

                    Spacer()

                    Button(self.buttonText) {
                        if(!switchButton) {
                            self.buttonText = "End"
                            switchButton = !switchButton
                        }
                        else {
                            self.buttonText = "Start"
                            switchButton = !switchButton
                        }
                    }
                    .padding()
                    .controlSize(.regular)
                    .buttonStyle(.bordered)
                }
                
                Divider()
                
                VStack (alignment: .leading){
                    if(!switchButton) {
                        Text("Welcome to Townie+!")
                            .font(.headline)
                            .padding(.vertical, 5.0)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("This app tracks your current location and tells you what town you are in!")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text("Press Start to start the application. \nPress Stop to stop to see this menu again. ")
                            .padding(.top, 5.0)
                            .padding(.leading, 50.0)
                    }
                    
                    else {
                        Text("Location Details:")
                            .font(.headline)
                            .padding(.vertical, 5.0)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Road:")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text("City:")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text("County:")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text("State:")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                    }
                    Divider()
                    
                    if(!switchButton) {
                        FullMap()
                            
                    }
                    else {
                        
                        
                    }

                    Spacer()
                    Divider()
                    Spacer()
                    
                    
                    VStack(alignment: .center) {
                        NavigationLink(destination: FullMap()) {
                            Text("Places Traveled")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
