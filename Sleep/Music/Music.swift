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
    
    init(id: UUID = UUID(), title: String, category: String, isPlayed: Bool, imageName: String, musicName: String) {
        self.id = id
        self.title = title
        self.category = category
        self.isPlayed = isPlayed
        self.imageName = imageName
        self.musicName = musicName
    }
}

extension Music {
    static var musicData = [
        Music(title: "Deep in the sea", category: "Audio Sea", isPlayed: false, imageName: "CollectionView0", musicName: "mod_av_nature"),
        Music(title: "Deep in the forest", category: "Audio Forest", isPlayed: false, imageName: "CollectionView1", musicName: "mod_av_forest"),
        Music(title: "Deep in the sleep", category: "Audio Sleep", isPlayed: false, imageName: "CollectionView2", musicName: "mod_piano_av")
    ]
}
