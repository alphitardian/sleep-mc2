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
                MusicView(musicViewModel: musicViewModel)
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
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(Color("BackgroundAppColor"))
                UITabBar.appearance().standardAppearance = appearance
            }
            
            if (tabSelection == 1) {
                PlayerView(
                    animation: animation,
                    isPlayerExpanded: $isPlayerExpanded,
                    musicViewModel: musicViewModel
                )
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
