//
//  MusicViewModel.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 25/06/22.
//

import Foundation
import AVKit

class MusicViewModel: ObservableObject {
    
    @Published var musicData = Music.musicData
    @Published var queueMusic = [Music]()
    @Published private(set) var selectedMusic: Music?
    @Published private(set) var selectedMusicIndex: Int?
    @Published private(set) var isMusicPlayed = false
    @Published private(set) var isMusicShuffled = false
    @Published private(set) var isMusicLoop = false
    
    var audioPlayer: AVAudioPlayer?
    
    func setSelectedMusic(music: Music, index: Int) {
        selectedMusic = music
        selectedMusicIndex = index
        queueMusic = musicData.filter({ music in
            music.id != selectedMusic?.id
        })
    }
    
    func playMusic() {
        if let selectedMusic = selectedMusic {
            isMusicPlayed = true
            if let audioUrl = Bundle.main.url(forResource: selectedMusic.musicName, withExtension: "mp3") {
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
        
        if let selectedMusicIndex = selectedMusicIndex {
            if selectedMusicIndex == queueMusic.count {
                self.selectedMusicIndex = 0
            }
        }
        
        if let audioUrl = Bundle.main.url(forResource: queueMusic[selectedMusicIndex ?? 0].musicName, withExtension: "mp3") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                if isMusicPlayed {
                    audioPlayer?.play()
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        queueMusic.append(musicData[selectedMusicIndex ?? 0])
        queueMusic.removeFirst()
    }
    
    func previousMusic(previousIndex: Int) {
        if let audioUrl = Bundle.main.url(forResource: selectedMusic?.musicName ?? "", withExtension: "mp3") {
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
                if isMusicPlayed {
                    audioPlayer?.play()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        queueMusic.insert(musicData[selectedMusicIndex ?? 0], at: queueMusic.count)
        queueMusic.removeLast()
    }
    
    func shuffleMusic() {
        if isMusicShuffled {
            queueMusic = musicData.filter({ music in
                music.id != musicData[selectedMusicIndex ?? 0].id
            })
            isMusicShuffled = false
        } else {
            queueMusic.shuffle()
            isMusicShuffled = true
        }
    }
    
    func loopMusic() {
        if isMusicLoop {
            audioPlayer?.numberOfLoops = 0
            isMusicLoop = false
        } else {
            audioPlayer?.numberOfLoops = -1
            isMusicLoop = true
        }
    }
}
