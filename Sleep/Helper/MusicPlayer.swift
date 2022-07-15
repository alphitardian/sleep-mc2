//
//  MusicPlayer.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 15/07/22.
//

import Foundation
import AVKit

enum MusicLoop {
    case none
    case repeatOne
    case repeatAll
}

class MusicPlayer {
    
    static let sharedInstance = MusicPlayer()
    private var audioPlayer: AVAudioPlayer?
    
    func playMusic(title: String) {
        guard let audioUrl = Bundle.main.url(forResource: title, withExtension: "mp3") else { return }
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleMusic() {
        guard let isAudioPlay = audioPlayer?.isPlaying else {
            return
        }
        if isAudioPlay {
            audioPlayer?.stop()
        } else {
            audioPlayer?.play()
        }
    }
    
    func repeatMusic(isMusicLoop: MusicLoop) {
        switch isMusicLoop {
        case .none:
            audioPlayer?.numberOfLoops = 0
        case .repeatOne:
            audioPlayer?.numberOfLoops = -1
        default:
            audioPlayer?.numberOfLoops = 0
        }
    }
}
