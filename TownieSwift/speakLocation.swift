//
//  speakLocation.swift
//  TownieSwift
//
//  Created by Colin Fyock on 6/6/23.
//

import Foundation
import AVFoundation

public class speakLocation: NSObject {
    static let speaker = speakLocation()
    var prev = ""
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    
    public func speak(speech: String) {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])

        // Create an utterance.
        let voice = AVSpeechSynthesisVoice(language: "en-US")

        let utterance = AVSpeechUtterance(string: "You are now entering " + speech)
        print(prev)
        print(speech)
        print(utterance)
        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Tell the synthesizer to speak the utterance.
        if(speech != prev) {
            print("HERE SHOULD BE SPEAKING")
            synthesizer.speak(utterance)
            prev = speech
        }


    }
}
