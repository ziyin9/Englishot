//
//  SoundPlayer.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/18/25.
//


import AVFoundation

class SoundPlayer {
    static let shared = SoundPlayer()
    private var player: AVAudioPlayer?

    func playSound(named name: String, withExtension ext: String = "mp3") {
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("Failed to play sound: \(error)")
            }
        } else {
            print("Sound file not found.")
        }
    }
}
