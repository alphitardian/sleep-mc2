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
    
    @State private var isKeyboardPresented = false
    
    var body: some View {
        ZStack {
            if isChangeListToggle {
                GridListView(
                    animation: animation,
                    musicViewModel: musicViewModel,
                    filteredMusic: filteredMusic,
                    onMusicSelected: onMusicSelected
                )
                .padding(.bottom, musicViewModel.selectedMusic != nil && !isKeyboardPresented ? 54 : 0)
            } else {
                HorizontalListView(
                    animation: animation,
                    musicViewModel: musicViewModel,
                    filteredMusic: filteredMusic,
                    onMusicSelected: onMusicSelected
                )
            }
        }
        .onReceive(keyboardPublisher) { newValue in
            isKeyboardPresented = newValue
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
                    HighlightCollectionView(music: music) {
                        guard let prevSelectedMusic = musicViewModel.selectedMusic else {
                            musicViewModel.setSelectedMusic(music: music)
                            musicViewModel.playMusic()
                            musicViewModel.refreshQueue()
                            return
                        }
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        if musicViewModel.isMusicPlayed {
                            if music.id == prevSelectedMusic.id {
                                musicViewModel.toggleMusic()
                            } else {
                                musicViewModel.playMusic()
                            }
                        } else {
                            musicViewModel.playMusic()
                        }
                    }
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
                    NormalCollectionView(music: music) {
                        guard let prevSelectedMusic = musicViewModel.selectedMusic else {
                            musicViewModel.setSelectedMusic(music: music)
                            musicViewModel.playMusic()
                            musicViewModel.refreshQueue()
                            return
                        }
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        if musicViewModel.isMusicPlayed {
                            if music.id == prevSelectedMusic.id {
                                musicViewModel.toggleMusic()
                            } else {
                                musicViewModel.playMusic()
                            }
                        } else {
                            musicViewModel.playMusic()
                        }
                    }
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
            Spacer(minLength: musicViewModel.selectedMusic != nil ? 36 : 0)
        }
    }
}

struct HighlightCollectionView: View {
    
    var music: Music
    var onToggleMusicClicked: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(music.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width:285, height: (UIScreen.main.bounds.height / 1.75) - 90)
                    .cornerRadius(10)
                Spacer()
            }
            HStack {
                Text(music.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Spacer()
                Button {
                    withAnimation {
                        onToggleMusicClicked()
                    }
                } label: {
                    Image(systemName: music.isPlayed ? "pause" : "play")
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 54, height: 54)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding()
            .frame(height: 100)
            .background(Color("BackgroundAppColor"))
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
    
    var music: Music
    var onToggleMusicClicked: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(music.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width / 2.35, height:173)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 1)
                }
                .contentShape(Rectangle())
            HStack {
                Text(music.title)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                Spacer()
                Button {
                    withAnimation {
                        onToggleMusicClicked()
                    }
                } label: {
                    Image(systemName: music.isPlayed ? "pause" : "play")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .padding(5)
                        .frame(width: 23, height: 23)
                        .overlay {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .padding(10)
            .frame(height: 58)
            .background(Color("BackgroundAppColor"))
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

