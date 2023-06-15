//
//  speakLocation.swift
//  TownieSwift
//
//  Created by Colin Fyock on 6/6/23.
//

import Foundation
import AVFoundation

public class SpeakLocation: NSObject {
    static let speaker = SpeakLocation()
    var prev = ""
    var utterance = AVSpeechUtterance()
    var hasAnnouncedFirstLocation = false

    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    
    public func speak(speech: String) {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playback, options: [.duckOthers, .interruptSpokenAudioAndMixWithOthers])
        let voice = AVSpeechSynthesisVoice(language: "en-US")

        if(hasAnnouncedFirstLocation == true) {
            utterance = AVSpeechUtterance(string: "You are now entering " + speech)
        }
        else {
            utterance = AVSpeechUtterance(string: "Currently in " + speech)
            hasAnnouncedFirstLocation = true
        }

        // Assign the voice to the utterance.
        utterance.voice = voice

        // Tell the synthesizer to speak the utterance.
        if(speech != prev) {
            synthesizer.speak(utterance)
            prev = speech
        }

    }

    
}
