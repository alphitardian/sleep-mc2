//
//  Music.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 25/06/22.
//

import Foundation

struct Music: Identifiable, Equatable {
    var id: UUID
    var title: String
    var category: String
    var isPlayed: Bool
    var imageName: String
    var musicName: String
    var videoName: String
    
    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        isPlayed: Bool,
        imageName: String,
        musicName: String,
        videoName: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.isPlayed = isPlayed
        self.imageName = imageName
        self.musicName = musicName
        self.videoName = videoName
    }
}

extension Music {
    static var musicData = [
        Music(title: "Classic",
              category: "Classic",
              isPlayed: false,
              imageName: "classicCover",
              musicName: "mod_av_nature",
              videoName: "classicPlayScreen"),
        Music(title: "Forest 1",
              category: "Forest",
              isPlayed: false,
              imageName: "forestCover1",
              musicName: "mod_av_forest",
              videoName: "forestPlayScreen"),
        Music(title: "Forest 2",
              category: "Forest",
              isPlayed: false,
              imageName: "forestCover2",
              musicName: "mod_piano_av",
              videoName: "forestPlayScreen2"),
        Music(title: "Nature",
              category: "Nature",
              isPlayed: false,
              imageName: "natureCover",
              musicName: "mod_piano_av",
              videoName: "naturePlayScreen"),
        Music(title: "Ocean",
              category: "Nature",
              isPlayed: false,
              imageName: "oceanCover",
              musicName: "mod_piano_av",
              videoName: "oceanPlayScreen"),
        Music(title: "Rain",
              category: "Nature",
              isPlayed: false,
              imageName: "rainCover",
              musicName: "mod_piano_av",
              videoName: "rainPlayScreen")
    ]
}
