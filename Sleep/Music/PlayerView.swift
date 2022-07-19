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
    // State when timer is opened
    @State private var isTimerSheetOpened = false
    
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
                    isPlayerExpanded ? 36 :
                        isPlayerExpanded ? 4 : 0
                )
            
            // Mini Player
            //            MiniPlayerView(
            //                animation: animation,
            //                musicViewModel: musicViewModel,
            //                isPlayerExpanded: $isPlayerExpanded,
            //                isListOpened: $isListOpened
            //            )
            
            // Detailed Player
            DetailedPlayerView(
                animation: animation,
                musicViewModel: musicViewModel,
                isPlayerExpanded: $isPlayerExpanded,
                isTimerSheetOpen: $isTimerSheetOpened
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
        if !isTimerSheetOpened {
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
        if !isTimerSheetOpened {
            // Only allow gesture when screen is expanded
            if value.translation.height > 0 && isPlayerExpanded {
                offset = value.translation.height
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    @Namespace static var animation
    @State static var isPlayerExpanded = true
    static var musicViewModel = MusicViewModel()
    
    static var previews: some View {
        Group {
            PlayerView(
                animation: animation,
                isPlayerExpanded: $isPlayerExpanded,
                musicViewModel: musicViewModel
            )
            TimerSetupView(
                isTimerOn: .constant(false),
                isTimerSheetOpen: .constant(false),
                timerValue: .constant(15),
                musicViewModel: musicViewModel
            )
        }
    }
}

struct DetailedPlayerView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isPlayerExpanded: Bool
    @Binding var isTimerSheetOpen: Bool
    
    @State var isTimerOn = false
    @State var hour = 0
    @State var minute = 0
    @State var second = 0
    @State var timerValue = 0
    
    // Move the slider value
    var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            if isPlayerExpanded {
                Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                    .matchedGeometryEffect(id: "Label", in: animation)
                    .padding(.horizontal, 36)
                    .padding(.bottom, 2)
                
                if isTimerOn {
                    let (_, minute, second) = musicViewModel.secondsToHoursMinutesSeconds(timerValue)
                    Text("\(minute):\(second == 0 ? "00" : "\(second)")")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // Music Player Controller
                HStack {
                    Spacer()
                    // Play/Pause Button
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
                        Image(systemName: musicViewModel.isMusicPlayed ? "pause" : "play")
                            .font(.system(size: 24))
                            .foregroundColor(Color("IconColor"))
                    }
                    Spacer()
                    // Previous Button
                    Button {
                        if !musicViewModel.queueMusic.isEmpty {
                            guard let prevMusic = musicViewModel.queueMusic.last else { return }
                            musicViewModel.previousMusic()
                            musicViewModel.setSelectedMusic(music: prevMusic)
                        }
                    } label: {
                        Image(systemName: "backward.end")
                            .font(.system(size: 24))
                            .foregroundColor(Color("IconColor"))
                    }
                    Spacer()
                    // Forward Button
                    Button {
                        if !musicViewModel.queueMusic.isEmpty {
                            guard let nextMusic = musicViewModel.queueMusic.first else { return }
                            musicViewModel.nextMusic()
                            musicViewModel.setSelectedMusic(music: nextMusic)
                        }
                    } label: {
                        Image(systemName: "forward.end")
                            .font(.system(size: 24))
                            .foregroundColor(musicViewModel.queueMusic.first != nil ? Color("IconColor") : .gray)
                    }
                    Spacer()
                    // Timer Button
                    Button {
                        isTimerSheetOpen.toggle()
                    } label: {
                        Image(systemName: "stopwatch")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, UIScreen.main.bounds.height / 8)
            }
        }
        .sheetWithDetents(
            isPresented: $isTimerSheetOpen,
            detents: [.medium()],
            onDismiss: nil
        ) {
            TimerSetupView(
                isTimerOn: $isTimerOn,
                isTimerSheetOpen: $isTimerSheetOpen,
                timerValue: $timerValue,
                musicViewModel: musicViewModel
            )
        }
        .frame(
            width: isPlayerExpanded ? nil : 0,
            height: isPlayerExpanded ? nil : 0
        )
        .opacity(isPlayerExpanded ? 1 : 0)
        .onReceive(timer) { _ in
            if let isAudioPlay = musicViewModel.musicPlayer.audioPlayer?.isPlaying {
                if isTimerOn {
                    timerValue = isAudioPlay ? timerValue - 1 : timerValue - 0
                    if isAudioPlay && timerValue == 0 {
                        musicViewModel.toggleMusic()
                        timerValue = 0
                        isTimerOn = false
                    }
                }
            }
        }
    }
}

struct TimerSetupView: View {
    
    @Binding var isTimerOn: Bool
    @Binding var isTimerSheetOpen: Bool
    @Binding var timerValue: Int
    @ObservedObject var musicViewModel: MusicViewModel
    @State var hour = 0
    @State var minute = 15
    @State var second = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundAppColor")
                    .ignoresSafeArea()
                TimerPickerView(
                    hour: $hour,
                    minute: $minute,
                    second: $second
                )
                .colorInvert()
                .colorMultiply(.white)
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if minute != 0 || second != 0 {
                            guard let isAudioPlay = musicViewModel.musicPlayer.audioPlayer?.isPlaying else { return }
                            if !isAudioPlay {
                                musicViewModel.toggleMusic()
                            }
                            isTimerOn = true
                            isTimerSheetOpen.toggle()
                            timerValue = musicViewModel.minuteToSecond(minute) + second
                            
                        }
                    } label: {
                        Text("Done").bold()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isTimerSheetOpen.toggle()
                    }
                }
            }
            .onAppear {
                UINavigationBar.appearance()
                    .titleTextAttributes = [.foregroundColor:UIColor.white]
            }
        }
    }
}

struct MiniPlayerView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isPlayerExpanded: Bool
    @Binding var isListOpened: Bool
    
    var body: some View {
        HStack(spacing: 14) {
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
