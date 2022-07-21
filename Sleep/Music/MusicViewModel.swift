//
//  MusicViewModel.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 25/06/22.
//

import Foundation
import AVKit

class MusicViewModel: ObservableObject {
    
    @Published var queueMusic = [Music]()
    @Published private(set) var selectedMusic: Music?
    @Published private(set) var isMusicPlayed = false
    @Published private(set) var isMusicShuffled = false
    @Published private(set) var isMusicLoop = false
    
    var musicData = Music.musicData
    var musicPlayer = MusicPlayer.sharedInstance
    
    func setSelectedMusic(music: Music) {
        selectedMusic = music
        if let selectedMusic = selectedMusic {
            updateMusic(selectedMusic: selectedMusic, isPlayed: true)
        }
    }
    
    func playMusic() {
        if let selectedMusic = selectedMusic {
            isMusicPlayed = true
            musicPlayer.playMusic(title: selectedMusic.musicName)
            updateMusic(selectedMusic: selectedMusic, isPlayed: true)
        }
    }
    
    func updateMusic(selectedMusic: Music, isPlayed: Bool) {
        musicData = Music.musicData
        guard let musicIndex = musicData.firstIndex(where: { music in
            music.id == selectedMusic.id
        }) else { return }
        musicData[musicIndex].isPlayed = isPlayed
    }
    
    func toggleMusic() {
        if let selectedMusic = selectedMusic {
            musicPlayer.toggleMusic()
            isMusicPlayed.toggle()
            updateMusic(selectedMusic: selectedMusic, isPlayed: isMusicPlayed)
        }
    }
    
    func nextMusic() {
        // Check if there is any music in queue
        if !isMusicPlayed { toggleMusic() }
        guard let nextMusic = queueMusic.first else { return }
        musicPlayer.playMusic(title: nextMusic.musicName)
        
        // Update queue list
        guard let prevSelectedMusic = selectedMusic else { return }
        updateMusic(selectedMusic: prevSelectedMusic, isPlayed: false)
        queueMusic.append(prevSelectedMusic)
        queueMusic.removeFirst()
    }
    
    func previousMusic() {
        // Check if there is any music in queue
        if !isMusicPlayed { toggleMusic() }
        guard let lastMusic = queueMusic.last else { return }
        musicPlayer.playMusic(title: lastMusic.musicName)
        
        // Update queue list
        guard let prevSelectedMusic = selectedMusic else { return }
        updateMusic(selectedMusic: prevSelectedMusic, isPlayed: false)
        queueMusic.insert(prevSelectedMusic, at: 0)
        queueMusic.removeLast()
    }
    
    func shuffleMusic() {
        if isMusicShuffled {
            refreshQueue()
            isMusicShuffled = false
        } else {
            queueMusic.shuffle()
            isMusicShuffled = true
        }
    }
    
    func loopMusic() {
        if isMusicLoop {
            musicPlayer.repeatMusic(isMusicLoop: .none)
            isMusicLoop = false
        } else {
            musicPlayer.repeatMusic(isMusicLoop: .repeatOne)
            isMusicLoop = true
        }
    }
    
    func refreshQueue() {
        queueMusic = musicData.filter({ music in
            music.id != selectedMusic?.id
        })
    }
    
    func stopPlayer(completion: @escaping () -> Void) {
        if isMusicPlayed && !isMusicLoop {
            isMusicPlayed.toggle()
            completion()
        }
    }
    
    func convertedTimer(_ seconds: Int) -> (hour: Int, minute: Int, second: Int) {
        return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
    }
    
    func hourToSecond(_ hour: Int) -> Int {
        return hour * 3600
    }
    
    func minuteToSecond(_ minute: Int) -> Int {
        return minute * 60
    }
}
