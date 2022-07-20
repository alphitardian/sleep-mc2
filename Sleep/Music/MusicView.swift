//
//  MusicView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct MusicView: View {
    
    @ObservedObject var musicViewModel: MusicViewModel
    var filteredMusic: [Music]
    var onMusicSelected: () -> Void
    
    var body: some View {
        HorizontalListView(
            musicViewModel: musicViewModel,
            filteredMusic: filteredMusic,
            onMusicSelected: onMusicSelected
        )
        //GridListView(musicViewModel: musicViewModel, onMusicSelected: onMusicSelected)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(musicViewModel: MusicViewModel(), filteredMusic: [], onMusicSelected: {})
            .environment(\.colorScheme, .dark)
    }
}

struct HorizontalListView: View {
    
    @ObservedObject var musicViewModel: MusicViewModel
    var filteredMusic: [Music]
    var onMusicSelected: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 24) {
                ForEach(filteredMusic) { music in
                    HighlightCollectionView(
                        session: "\(music.length) Session",
                        text: music.title,
                        img: music.imageName
                    )
                    .onTapGesture {
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        musicViewModel.playMusic()
                        onMusicSelected()
                    }
                }
            }
            .padding(.horizontal, 52)
        }
    }
}

struct GridListView: View {
    
    @ObservedObject var musicViewModel: MusicViewModel
    var onMusicSelected: () -> Void
    
    private let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: twoColumnGrid) {
                ForEach(0..<Int(musicViewModel.musicData.count), id:\.self) { index in
                    let music = musicViewModel.musicData[index]
                    NormalCollectionView(
                        title: music.title,
                        session: "\(music.length) Session",
                        img: music.imageName
                    )
                    .onTapGesture {
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        musicViewModel.playMusic()
                        onMusicSelected()
                    }
                }
            }
        }
    }
}

struct HighlightCollectionView: View {
    
    var session = ""
    var text = ""
    var img = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(img)
                .resizable()
                .scaledToFill()
                .frame(width:285)
                .cornerRadius(10)
            HStack {
                Text(text)
                    .font(.title)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Spacer()
                Button {
                    //
                } label: {
                    Image(systemName: "play")
                        .foregroundColor(.white)
                        .padding()
                        .overlay {
                            RoundedRectangle (cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding()
            .frame(height: 100)
            .background(.black)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle (cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            }
        }
        .frame(width:285, height:480)
        .overlay {
            RoundedRectangle (cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
        }
        
    }
}

struct NormalCollectionView: View {
    
    var title = ""
    var session = ""
    var img = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(img)
                .resizable()
                .scaledToFill()
                .frame(width:165, height:173)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(.white, lineWidth: 1)
                }
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Spacer()
                Button {
                    //
                } label: {
                    Image(systemName: "play")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .padding(5)
                        .overlay {
                            RoundedRectangle (cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding(10)
            .frame(height: 58)
            .background(.black)
            .overlay {
                RoundedRectangle (cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            }
        }
        .frame(width:165, height:173)
    }
}

