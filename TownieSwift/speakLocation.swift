//
//  speakLocation.swift
//  TownieSwift
//
//  Created by Colin Fyock on 6/6/23.
//

import Foundation
import AVFoundation

public class SpeakLocation: NSObject, AVSpeechSynthesizerDelegate {
    static let speaker = SpeakLocation()
    var prev = ""
    var utterance = AVSpeechUtterance()
    var hasAnnouncedFirstLocation = false

    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    public func speak(speech: String) {
        if speech == prev {
            return
        }

        setSession(isActive: true, session: audioSession)

        if AVSpeechSynthesisVoice.speechVoices().count == 0 {
            print("No available speech voices")
            return
        }

        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        if(hasAnnouncedFirstLocation) {
            utterance = AVSpeechUtterance(string: "You are now entering " + speech)
        }
        else {
            utterance = AVSpeechUtterance(string: "Currently in " + speech)
            hasAnnouncedFirstLocation = true
        }

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
        prev = speech
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        setSession(isActive: false, session: audioSession)
    }

    private func setSession(isActive: Bool, session: AVAudioSession) {
        if isActive {
            try! session.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.duckOthers)
        } else {
            try! session.setCategory(AVAudioSession.Category.ambient, options: AVAudioSession.CategoryOptions.mixWithOthers)
        }
        try! session.setActive(isActive, options: .notifyOthersOnDeactivation)
    }

}
