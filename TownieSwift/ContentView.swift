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

struct Home: View {
    @State var switchButton = false
    @State var buttonText = "Start"
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
    
    let map = LocationTrackingViewControl.shared
    

    func speak(speech: String) {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: speech)

        // Configure the utterance.
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8

        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(language: "en-US")

        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Create a speech synthesizer.
        let synthesizer = AVSpeechSynthesizer()

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
    
    
    
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
                    }
                    
                    Divider()

                    if(switchButton) {
                        Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: true, userTrackingMode: .constant(.follow))
                            .edgesIgnoringSafeArea(.all)
                            .onAppear() {
                                map.startTracking()
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

