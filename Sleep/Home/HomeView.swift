//
//  HomeView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var tabSelection = 1
    @State private var isPlayerExpanded = false
    @Namespace private var animation
    
    @StateObject private var musicViewModel = MusicViewModel()
        
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelection) {
                MusicView(musicViewModel: musicViewModel) {
                    withAnimation {
                        isPlayerExpanded.toggle()
                        UIScreen.setBrightness(
                            from: Constants.currentBrightness,
                            to: 0.0,
                            duration: 3,
                            ticksPerSecond: 240
                        )
                    }
                }
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Sessions")
                }
                .tag(1)
                
                AnalyticView()
                    .tabItem {
                        Image(systemName: "moon.fill")
                        Text("Your Sleep")
                    }
                    .tag(2)
            }
            .accentColor(.purple)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color("BackgroundAppColor"))
                UITabBar.appearance().standardAppearance = appearance
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                // App moved to background
                if musicViewModel.isMusicPlayed {
                    UIScreen.setBrightness(from: 0.0, to: Constants.currentBrightness)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // App back to active
                if musicViewModel.isMusicPlayed {
                    UIScreen.setBrightness(from: Constants.currentBrightness, to: 0.0)
                }
            }
            
            if (tabSelection == 1) {
                if musicViewModel.selectedMusic != nil {
                    PlayerView(
                        animation: animation,
                        isPlayerExpanded: $isPlayerExpanded,
                        musicViewModel: musicViewModel
                    )
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
