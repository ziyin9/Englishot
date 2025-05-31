//
//  BackgroundMusic.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/1/23.
//

import AVFoundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var volume: Float = 0.5 {
        didSet {
            audioPlayer?.volume = volume
        }
    }

    init() {
        setupAudio()
    }

    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "brisk", withExtension: "mp3") else {
            return
        }
        //guard可以看成if但可以提早退出
        audioPlayer = try? AVAudioPlayer(contentsOf: url)   //try? 將拋出的錯誤轉換為 nil,僅返回 nil。
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.volume = volume
        audioPlayer?.play()
    }

    
}
