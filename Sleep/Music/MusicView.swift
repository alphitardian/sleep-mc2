//
//  MusicView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct MusicView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isChangeListToggle: Bool
    var filteredMusic: [Music]
    var onMusicSelected: () -> Void
    
    var body: some View {
        ZStack {
            if isChangeListToggle {
                GridListView(
                    animation: animation,
                    musicViewModel: musicViewModel,
                    filteredMusic: filteredMusic,
                    onMusicSelected: onMusicSelected
                )
            } else {
                HorizontalListView(
                    animation: animation,
                    musicViewModel: musicViewModel,
                    filteredMusic: filteredMusic,
                    onMusicSelected: onMusicSelected
                )
            }
        }
    }
}

struct MusicView_Previews: PreviewProvider {
    
    @Namespace static var animation
    
    static var previews: some View {
        MusicView(
            animation: animation,
            musicViewModel: MusicViewModel(),
            isChangeListToggle: .constant(false),
            filteredMusic: [],
            onMusicSelected: {}
        )
            .environment(\.colorScheme, .dark)
    }
}

struct HorizontalListView: View {
    
    var animation: Namespace.ID
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
                    .matchedGeometryEffect(id: music.title, in: animation)
                    .onTapGesture {
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        musicViewModel.playMusic()
                        onMusicSelected()
                    }
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width / 8)
        }
    }
}

struct GridListView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    var filteredMusic: [Music]
    var onMusicSelected: () -> Void
    
    private let twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: twoColumnGrid) {
                ForEach(filteredMusic) { music in
                    NormalCollectionView(
                        title: music.title,
                        session: "\(music.length) Session",
                        img: music.imageName
                    )
                    .matchedGeometryEffect(id: music.title, in: animation)
                    .onTapGesture {
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        musicViewModel.playMusic()
                        onMusicSelected()
                    }
                }
            }
            .padding(.horizontal)
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
                            RoundedRectangle(cornerRadius: 50)
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
        .frame(width:285, height: UIScreen.main.bounds.height / 1.75)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
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
                .frame(width: UIScreen.main.bounds.width / 2.35, height:173)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
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
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding(10)
            .frame(height: 58)
            .background(.black)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle (cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            }
        }
        .frame(width: UIScreen.main.bounds.width / 2.35, height: 173)
        .padding(.bottom, 10)
    }
}

