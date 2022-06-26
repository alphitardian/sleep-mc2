//
//  MusicViewModel.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 25/06/22.
//

import Foundation
import AVKit

class MusicViewModel: ObservableObject {
    
    lazy var musicData = Music.musicData
    
    @Published private(set) var selectedMusic: Music?
    
    private var audioPlayer: AVAudioPlayer?
    
    func setSelectedMusic(music: Music) {
        selectedMusic = music
    }
    
    func playMusic() {
        if let selectedMusic = selectedMusic {
            if let audioUrl = Bundle.main.url(forResource: selectedMusic.title, withExtension: "mp3") {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                    audioPlayer?.play()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func pauseMusic() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
        }
    }
    
    func nextMusic() {
        var index = 0
        index += 1
        if let audioUrl = Bundle.main.url(forResource: musicData[index].title, withExtension: "mp3") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func previousMusic() {
        var index = 0
        index -= 1
        if let audioUrl = Bundle.main.url(forResource: musicData[index].title, withExtension: "mp3") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
