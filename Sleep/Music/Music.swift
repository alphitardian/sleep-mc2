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
    var length: String
    var imageName: String
    
    init(id: UUID = UUID(), title: String, length: String, imageName: String) {
        self.id = id
        self.title = title
        self.length = length
        self.imageName = imageName
    }
}

extension Music {
    static let musicData = [
        Music(title: "Deep in the sea", length: "1 Hour", imageName: "CollectionView0"),
        Music(title: "Deep in the forest", length: "2 Hour", imageName: "CollectionView1"),
        Music(title: "Deep in the sleep", length: "3 Hour", imageName: "CollectionView2")
    ]
}
