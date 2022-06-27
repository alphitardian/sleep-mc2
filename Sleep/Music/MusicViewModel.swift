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
    @Published private(set) var selectedMusicIndex: Int?
    @Published private(set) var isMusicPlayed: Bool = false
    
    var audioPlayer: AVAudioPlayer?
    
    func setSelectedMusic(music: Music, index: Int) {
        selectedMusic = music
        selectedMusicIndex = index
    }
    
    func playMusic() {
        if let selectedMusic = selectedMusic {
            isMusicPlayed = true
            if let audioUrl = Bundle.main.url(forResource: selectedMusic.musicName, withExtension: "wav") {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                    audioPlayer?.play()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func resumeMusic() {
        isMusicPlayed.toggle()
        if selectedMusic != nil {
            if let audioPlayer = audioPlayer {
                audioPlayer.play()
            }
        }
    }
    
    func pauseMusic() {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
            isMusicPlayed.toggle()
        }
    }
    
    func nextMusic(nextIndex: Int) {
        if let audioUrl = Bundle.main.url(forResource: musicData[nextIndex].musicName, withExtension: "wav") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                if isMusicPlayed {
                    audioPlayer?.play()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func previousMusic(previousIndex: Int) {
        if let audioUrl = Bundle.main.url(forResource: musicData[previousIndex].musicName, withExtension: "wav") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                if isMusicPlayed {
                    audioPlayer?.play()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
