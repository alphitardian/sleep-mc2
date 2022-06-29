//
//  Music.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 25/06/22.
//

import Foundation

struct Music: Identifiable {
    var id: UUID
    var title: String
    var category: String
    var length: String
    var imageName: String
    var musicName: String
    
    init(id: UUID = UUID(), title: String, category: String, length: String, imageName: String, musicName: String) {
        self.id = id
        self.title = title
        self.category = category
        self.length = length
        self.imageName = imageName
        self.musicName = musicName
    }
}

extension Music {
    static let musicData = [
        Music(title: "Deep in the sea", length: "1 Hour", imageName: "CollectionView0", musicName: "mod_av_nature"),
        Music(title: "Deep in the forest", length: "2 Hour", imageName: "CollectionView1", musicName: "mod_av_forest"),
        Music(title: "Deep in the sleep", length: "3 Hour", imageName: "CollectionView2", musicName: "mod_piano_av")
    ]
}
