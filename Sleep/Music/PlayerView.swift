//
//  PlayerView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 24/06/22.
//

import SwiftUI

struct PlayerView: View {
    
    // PlayerView Parameter
    var animation: Namespace.ID
    @Binding var isPlayerExpanded: Bool
    @ObservedObject var musicViewModel: MusicViewModel
    
    // Offset for drag gesture
    @State private var offset: CGFloat = 0
    // State when music list is opened
    @State private var isListOpened = false
    
    // Safearea for padding usage
    private let safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(
                    width: isPlayerExpanded ? 181 : 0,
                    height: isPlayerExpanded ? 3 : 0
                )
                .opacity(isPlayerExpanded ? 1 : 0)
                .padding(.top, isPlayerExpanded ? safeArea?.top : 0)
                .padding(.top, isPlayerExpanded ? 16 : 0)
            
            Image(systemName: "chevron.down")
                .foregroundColor(Color("SecondaryTextColor"))
                .frame(
                    width: isPlayerExpanded ? 181 : 0,
                    height: isPlayerExpanded ? 3 : 0
                )
                .opacity(isPlayerExpanded ? 1 : 0)
                .padding(.top, isPlayerExpanded ? 8 : 0)
                .padding(
                    .bottom,
                    isPlayerExpanded && !isListOpened ? 36 :
                        isPlayerExpanded && isListOpened ? 4 : 0
                )
            
            // Mini Player
            MiniPlayerView(
                animation: animation,
                musicViewModel: musicViewModel,
                isPlayerExpanded: $isPlayerExpanded,
                isListOpened: $isListOpened
            )
            
            // Detailed Player
            DetailedPlayerView(
                animation: animation,
                musicViewModel: musicViewModel,
                isPlayerExpanded: $isPlayerExpanded,
                isListOpened: $isListOpened
            )
        }
        // if expand then full height
        .frame(maxHeight: isPlayerExpanded ? .infinity : 72)
        .background(Color("BackgroundAppColor"))
        .offset(y: isPlayerExpanded ? 0 : -48)
        .offset(y: offset)
        .onTapGesture {
            withAnimation(.spring()) {
                isPlayerExpanded = true
            }
        }
        .gesture(
            DragGesture()
                .onEnded(onDragGestureEnded(value:))
                .onChanged(onDragGestureChanged(value:))
        )
        .ignoresSafeArea()
    }
    
    func onDragGestureEnded(value: DragGesture.Value) {
        if !isListOpened {
            // Only happen when user start to drag the screen and release it
            withAnimation(
                .interactiveSpring(
                    response: 0.5,
                    dampingFraction: 0.95,
                    blendDuration: 0.95)
            ) {
                // if user drag untill 1/3 screen height then automatically close
                if value.translation.height > UIScreen.main.bounds.height / 3 {
                    isPlayerExpanded = false
                }
                
                offset = 0
            }
        }
    }
    
    func onDragGestureChanged(value: DragGesture.Value) {
        if !isListOpened {
            // Only allow gesture when screen is expanded
            if value.translation.height > 0 && isPlayerExpanded {
                offset = value.translation.height
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}

struct DetailedPlayerView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isPlayerExpanded: Bool
    @Binding var isListOpened: Bool
    
    // Slider music range indicator
    @State private var sliderValue = 0.0
    @State private var isEditingSlider = false
    
    // Move the slider value
    var timer = Timer
        .publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            if isPlayerExpanded {
                
                if isListOpened {
                    VStack {
                        PlayingListView(musicViewModel: musicViewModel)
                    }
                    .frame(maxHeight: 450)
                }
                
                if !isListOpened {
                    Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                        .bold()
                        .font(.title)
                        .matchedGeometryEffect(id: "Label", in: animation)
                        .padding(.horizontal, 36)
                        .padding(.bottom, 2)
                    Text("Audio Forest")
                        .foregroundColor(Color("SecondaryTextColor"))
                        .padding(.horizontal, 36)
                        .padding(.bottom, 12)
                }
                
                if let audioPlayer = musicViewModel.musicPlayer.audioPlayer {
                    Slider(
                        value: $sliderValue,
                        in: 1...audioPlayer.duration
                    ) { editing in
                        isEditingSlider = editing
                        if !editing {
                            audioPlayer.currentTime = sliderValue
                        }
                    }
                    .accentColor(.purple)
                    .padding(.horizontal, 36)
                    .onReceive(timer, perform: { _ in
                        guard let player = musicViewModel.musicPlayer.audioPlayer, !isEditingSlider else {
                            return
                        }
                        sliderValue = player.currentTime
                    })
                    HStack {
                        Text(DateComponentsFormatter.positional.string(from: audioPlayer.currentTime) ?? "0:00")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                        Spacer()
                        Text(DateComponentsFormatter.positional.string(from: audioPlayer.duration - audioPlayer.currentTime) ?? "0:00")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, -10)
                }
                
                // Music Player Controller
                HStack {
                    Spacer()
                    Button {
                        if !musicViewModel.queueMusic.isEmpty {
                            guard let prevMusic = musicViewModel.queueMusic.last else { return }
                            musicViewModel.previousMusic()
                            musicViewModel.setSelectedMusic(music: prevMusic)
                        }
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(Color("IconColor"))
                    }
                    .padding(.trailing, 81)
                    Button {
                        musicViewModel.toggleMusic()
                        if musicViewModel.isMusicPlayed {
                            UIScreen.setBrightness(
                                from: Constants.currentBrightness,
                                to: 0.0,
                                duration: 3,
                                ticksPerSecond: 240
                            )
                        } else {
                            UIScreen.setBrightness(
                                from: 0.0,
                                to: Constants.currentBrightness,
                                duration: 3,
                                ticksPerSecond: 240
                            )
                        }
                    } label: {
                        Image(systemName: musicViewModel.isMusicPlayed ? "pause" : "play.fill")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(Color("IconColor"))
                    }
                    Button {
                        if !musicViewModel.queueMusic.isEmpty {
                            guard let nextMusic = musicViewModel.queueMusic.first else { return }
                            musicViewModel.nextMusic()
                            musicViewModel.setSelectedMusic(music: nextMusic)
                        }
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(musicViewModel.queueMusic.first != nil ? Color("IconColor") : .gray)
                    }
                    .padding(.leading, 81)
                    Spacer()
                }
                .padding(.top, 16)
                Spacer()
                
                // Music Player Additional Controller
                HStack {
                    Spacer()
                    Button {
                        musicViewModel.shuffleMusic()
                    } label: {
                        Image(systemName: "shuffle")
                            .font(.system(size: 21, weight: .black))
                            .foregroundColor(musicViewModel.isMusicShuffled ? .purple : Color("IconColor"))
                    }
                    .padding(.trailing, 90)
                    Button {
                        withAnimation {
                            isListOpened.toggle()
                        }
                    } label: {
                        Image(systemName: "list.dash")
                            .font(.system(size: 21, weight: .black))
                            .foregroundColor(isListOpened ? .purple : Color("IconColor"))
                    }
                    Button {
                        musicViewModel.loopMusic()
                    } label: {
                        Image(systemName: "repeat")
                            .font(.system(size: 21, weight: .black))
                            .foregroundColor(musicViewModel.isMusicLoop ? .purple : Color("IconColor"))
                    }
                    .padding(.leading, 90)
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(
            width: isPlayerExpanded ? nil : 0,
            height: isPlayerExpanded ? nil : 0
        )
        .opacity(isPlayerExpanded ? 1 : 0)
    }
}

struct MiniPlayerView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isPlayerExpanded: Bool
    @Binding var isListOpened: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            
            if isPlayerExpanded {
                Spacer()
            }
            
            if !isListOpened {
                Image(musicViewModel.selectedMusic?.imageName ?? "")
                    .resizable()
                    .frame(
                        width: isPlayerExpanded ? 320 : 54,
                        height: isPlayerExpanded ? 320 : 54
                    )
                    .cornerRadius(12.0)
                    .shadow(color: .black, radius: 10.0)
            }
            
            if !isPlayerExpanded {
                Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                    .bold()
                    .font(.title3)
                    .matchedGeometryEffect(id: "Label", in: animation)
            }
            
            Spacer()
            
            if !isPlayerExpanded {
                Button {
                    if !musicViewModel.queueMusic.isEmpty {
                        guard let prevMusic = musicViewModel.queueMusic.last else { return }
                        musicViewModel.previousMusic()
                        musicViewModel.setSelectedMusic(music: prevMusic)
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .foregroundColor(.white)
                }
                Button {
                    musicViewModel.toggleMusic()
                    if musicViewModel.isMusicPlayed {
                        UIScreen.setBrightness(
                            from: Constants.currentBrightness,
                            to: 0.0,
                            duration: 3,
                            ticksPerSecond: 240
                        )
                    } else {
                        UIScreen.setBrightness(
                            from: 0.0,
                            to: Constants.currentBrightness,
                            duration: 3,
                            ticksPerSecond: 240
                        )
                    }
                } label: {
                    Image(systemName: musicViewModel.isMusicPlayed ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                }
                Button {
                    if !musicViewModel.queueMusic.isEmpty {
                        guard let nextMusic = musicViewModel.queueMusic.first else { return }
                        musicViewModel.nextMusic()
                        musicViewModel.setSelectedMusic(music: nextMusic)
                    }
                } label: {
                    Image(systemName: "forward.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.bottom, isPlayerExpanded ? nil : 8)
        .padding(.horizontal)
    }
}
