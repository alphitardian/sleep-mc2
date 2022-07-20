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
            if isPlayerExpanded {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 181, height: 3)
                    .padding(.top, safeArea?.top)
                    .padding(.top, 16)
                
                Image(systemName: "chevron.down")
                    .foregroundColor(Color("SecondaryTextColor"))
                    .frame(width: 181, height: 3)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                // Detailed Player
                DetailedPlayerView(
                    animation: animation,
                    musicViewModel: musicViewModel,
                    isPlayerExpanded: $isPlayerExpanded,
                    isTimerSheetOpen: $isTimerSheetOpened
                )
            }
            
            // Mini Player
            if !isPlayerExpanded {
                MiniPlayerView(
                    animation: animation,
                    musicViewModel: musicViewModel                )
            }
        }
        // if expand then full height
        .frame(maxHeight: isPlayerExpanded ? .infinity : 72)
        .background(
            isPlayerExpanded ? ZStack {
                BackgroundVideoView(videoName: "Sleepify-PlayScreen")
                LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
            } : nil
        )
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

struct DetailedPlayerView: View {
    
    var animation: Namespace.ID
    @ObservedObject var musicViewModel: MusicViewModel
    @Binding var isPlayerExpanded: Bool
    @Binding var isTimerSheetOpen: Bool
    
    @State var isTimerOn = false
    @State var isTimerConfirmationOpen = false
    @State var hour = 0
    @State var minute = 0
    @State var second = 0
    @State var timerValue = 0
    @StateObject var timerManager = TimerManager()
    
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
                    let (_, minute, second) = musicViewModel.convertedTimer(Int(timerManager.secondsElapsed))
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
                            timerManager.start(count: Double(timerValue)) {
                                if timerManager.secondsElapsed == 0 {
                                    musicViewModel.toggleMusic()
                                    timerManager.stop()
                                    isTimerOn.toggle()
                                    timerValue = 0
                                }
                            }
                            UIScreen.setBrightness(
                                from: Constants.currentBrightness,
                                to: 0.0,
                                duration: 3,
                                ticksPerSecond: 240
                            )
                        } else {
                            timerManager.stop()
                            timerValue = Int(timerManager.secondsElapsed)
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
                        if isTimerOn {
                            isTimerConfirmationOpen.toggle()
                        } else {
                            isTimerSheetOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "stopwatch")
                            .font(.system(size: 24))
                            .foregroundColor(isTimerOn ? .purple : .white)
                    }
                    .confirmationDialog("Do you want to stop the timer?", isPresented: $isTimerConfirmationOpen) {
                        Button("Stop Timer", role: .destructive) {
                            isTimerOn.toggle()
                            timerValue = 0
                            timerManager.stop()
                        }
                    }
                    .environment(\.colorScheme, .dark)
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
                musicViewModel: musicViewModel,
                timerManager: timerManager
            )
        }
        .frame(
            width: isPlayerExpanded ? nil : 0,
            height: isPlayerExpanded ? nil : 0
        )
    }
}

struct TimerSetupView: View {
    
    @Binding var isTimerOn: Bool
    @Binding var isTimerSheetOpen: Bool
    @Binding var timerValue: Int
    @ObservedObject var musicViewModel: MusicViewModel
    @ObservedObject var timerManager: TimerManager
    
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
                            timerManager.start(count: Double(timerValue)) {
                                if timerManager.secondsElapsed == 0 {
                                    musicViewModel.toggleMusic()
                                    timerManager.stop()
                                    isTimerOn.toggle()
                                    timerValue = 0
                                }
                            }
                        }
                    } label: {
                        Text("Done")
                            .bold()
                            .foregroundColor(.purple)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isTimerSheetOpen.toggle()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.purple)
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
    
    var body: some View {
        HStack(spacing: 14) {
            Image(musicViewModel.selectedMusic?.imageName ?? "")
                .frame(width: 46, height: 46)
                .cornerRadius(36)
                
            Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .lineLimit(1)
                .matchedGeometryEffect(id: "Label", in: animation)
            Spacer()
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
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.trailing, 4)
            }
            
        }
        .padding(.horizontal, 18)
        .frame(width: UIScreen.main.bounds.width / 1.25, height: 72)
        .background(Color("BackgroundAppColor").cornerRadius(36))
        .overlay {
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(.white, lineWidth: 1)
        }
        .padding(.bottom)
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    @Namespace static var animation
    @State static var isPlayerExpanded = true
    static var musicViewModel = MusicViewModel()
    static var timerManager = TimerManager()
    
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
                musicViewModel: musicViewModel,
                timerManager: timerManager
            )
            HomeView()
        }
    }
}
