//
//  ContentView.swift
//  TownieSwift
//
//  Created by Colin Fyock on 5/15/23.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation
import AVFoundation


extension String {
    static let startButtonTitle = "Start"
    static let stopButtonTitle = "End"
    static let alertTitle: String = "No Location Found"
    static let titleIcon = "house.lodge.circle"
    static let appTitle = "Townnouncer"
    static let intro1 = "Welcome to Townnouncer!"
    static let intro2 = "This app tracks your current location and tells you what town you are in!"
    static let intro3 = "Press Start to start the application. \nPress Stop to stop to see this menu again."
    static let locationDetails = "Location Details:"
    static let locationError = "Townnouncer will be unable to display a map or show the towns that you have visited without your location. Please go to Settings > Townnouncer > Location and Select 'Always'"
    static let townsVisitedTitle = "Towns Visited"
    
}


struct Home: View {
    @State var locationTrackingIsOn = false
    @State var buttonText = String.startButtonTitle
    
    
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
    
    @ObservedObject var map = locator.shared

    let intro = "You are now entering "
    let speech = SpeakLocation.speaker
    @State var currentCity = ""
    
    
    func switcher() {
        locationTrackingIsOn = !locationTrackingIsOn
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: .titleIcon)
                        .padding([.top, .leading, .bottom], 10.0)
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                        .font(.title)
                    Text(String.appTitle)
                        .font(.title)
                    
                    
                    Spacer()
                    
                    Button(self.buttonText) {
                        if(locationTrackingIsOn) {
                            self.buttonText = .startButtonTitle
                            locationTrackingIsOn = !locationTrackingIsOn
                        }
                        else {
                            self.buttonText = .stopButtonTitle
                            locationTrackingIsOn = !locationTrackingIsOn
                        }
                    }
                    .padding()
                    .controlSize(.regular)
                    .buttonStyle(.bordered)
                }
                
                Divider()
                
                VStack (alignment: .leading){
                    if(!locationTrackingIsOn) {
                        Text(String.intro1)
                            .font(.headline)
                            .padding(.vertical, 5.0)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text(String.intro2)
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text(String.intro3)
                            .padding(.top, 5.0)
                            .padding(.leading, 50.0)
                    }
                    
                    else {
                        Text(String.locationDetails)
                            .font(.headline)
                            .padding(.vertical, 5.0)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Text("Road: \(map.getCurrentLocation()[0])")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)


                        Text("City: \(map.getCurrentLocation()[1])")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)

                        
                        Text("County: \(map.getCurrentLocation()[2])")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                        
                        Text("State: \(map.getCurrentLocation()[3])")
                            .padding(.top, 5.0)
                            .padding([.leading, .trailing], 50.0)
                            .onChange(of: map.currentLocation) { _ in
                                speech.speak(speech: map.getCurrentLocation()[1])
                            }
                    }
                    
                    Divider()
                    
                    if(locationTrackingIsOn) {
                        Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: true, userTrackingMode: .constant(.follow))
                            .edgesIgnoringSafeArea(.all)
                            .onAppear() {
                                map.startTracking()
                            }
                            .alert(
                                String.alertTitle,
                                isPresented: map.deniedPermission()
                            ) {
                                Button("OK") {
                                }
                            } message: {
                                Text(String.locationError)
                            }
                    }
                    
                    else {
                        Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: false)
                            .edgesIgnoringSafeArea(.all)
                            .onAppear() {
                                map.stopTracking()
                            }
                    }
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    VStack(alignment: .center) {
                        NavigationLink(destination: Places()) {
                            Text(String.townsVisitedTitle)
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

