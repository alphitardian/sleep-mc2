//
//  MusicPlayer.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 15/07/22.
//

import Foundation
import AVKit
import MediaPlayer

enum MusicLoop {
    case none
    case repeatOne
    case repeatAll
}

class MusicPlayer {
    
    static let sharedInstance = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var audioItem: AVPlayerItem?
    
    func playMusic(title: String) {
        guard let audioUrl = Bundle.main.url(forResource: title, withExtension: "mp3") else { return }
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioUrl)
            audioItem = AVPlayerItem(url: audioUrl)
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func toggleMusic() {
        guard let isAudioPlay = audioPlayer?.isPlaying else { return }
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
    
    func setupNowPlaying(music: Music) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = music.title
        
        if let image = UIImage(named: music.imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
            MPMediaItemArtwork(boundsSize: CGSize(width: 120, height: 120)) { size in
                return image.imageWith(newSize: size)
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioItem?.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer?.rate
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setupRemoteCommandCenter(
        handlePlayCommand: @escaping () throws -> Void,
        handlePauseCommand: @escaping () throws -> Void,
        handleNextCommand: @escaping () throws -> Void,
        handlePreviousCommand: @escaping () throws -> Void
    ) {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            do {
                try handlePlayCommand()
                return .success
            } catch {
                print(error.localizedDescription)
                return .commandFailed
            }
        }
        
        commandCenter.pauseCommand.addTarget { event in
            do {
                try handlePauseCommand()
                return .success
            } catch {
                print(error.localizedDescription)
                return .commandFailed
            }
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            do {
                try handleNextCommand()
                return .success
            } catch {
                print(error.localizedDescription)
                return .commandFailed
            }
        }

        commandCenter.previousTrackCommand.addTarget { event in
            do {
                try handlePreviousCommand()
                return .success
            } catch {
                print(error.localizedDescription)
                return .commandFailed
            }
        }
    }
}

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}
