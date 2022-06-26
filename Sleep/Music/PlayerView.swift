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
    
    // Slider music range indicator
    @State private var sliderValue = 50.0
    
    // Safearea for padding usage
    var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    
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
                .padding(.bottom, isPlayerExpanded ? 36 : 0)
            
            HStack(spacing: 14) {
                
                if isPlayerExpanded {
                    Spacer()
                }
                
                Image(musicViewModel.selectedMusic?.imageName ?? "")
                    .resizable()
                    .frame(
                        width: isPlayerExpanded ? 320 : 54,
                        height: isPlayerExpanded ? 320 : 54
                    )
                    .cornerRadius(12.0)
                    .shadow(color: .black, radius: 10.0)
                
                if !isPlayerExpanded {
                    Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                        .bold()
                        .font(.title3)
                        .matchedGeometryEffect(id: "Label", in: animation)
                }
                
                Spacer()
                
                if !isPlayerExpanded {
                    Button {
                        // Rewind
                    } label: {
                        Image(systemName: "backward.fill")
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        // Play
                    } label: {
                        Image(systemName: "play.fill")
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        // Forward
                    } label: {
                        Image(systemName: "forward.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.bottom, isPlayerExpanded ? nil : 8)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                if isPlayerExpanded {
                    Text("Deep In The Sea")
                        .bold()
                        .font(.title)
                        .matchedGeometryEffect(id: "Label", in: animation)
                        .padding(.horizontal, 36)
                        .padding(.bottom, 2)
                    
                    Text("Audio Forest")
                        .foregroundColor(Color("SecondaryTextColor"))
                        .padding(.horizontal, 36)
                        .padding(.bottom, 12)
                    
                    Slider(value: $sliderValue, in: 1...100)
                        .accentColor(.purple)
                        .padding(.horizontal, 36)
                    
                    HStack {
                        Text("05:28")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                        Spacer()
                        Text("05:28")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, -10)
                    
                    HStack {
                        Spacer()
                        Button {
                            // Play
                        } label: {
                            Image(systemName: "play.fill")
                                .resizable()
                                .frame(width: 42, height: 42)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                    .padding(.top, 16)
                }
                
                Spacer()
            }
            .frame(
                width: isPlayerExpanded ? nil : 0,
                height: isPlayerExpanded ? nil : 0
            )
            .opacity(isPlayerExpanded ? 1 : 0)
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
    
    func onDragGestureChanged(value: DragGesture.Value) {
        // Only allow gesture when screen is expanded
        if value.translation.height > 0 && isPlayerExpanded {
            offset = value.translation.height
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
//        PlayerView(animation: animation, isPlayerExpanded: .constant(false))
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
