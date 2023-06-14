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
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    
    public func speak(speech: String) {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])

        // Create an utterance.
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let utterance = AVSpeechUtterance(string: speech)
        
        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
    }
    
    
    
    
    
}

