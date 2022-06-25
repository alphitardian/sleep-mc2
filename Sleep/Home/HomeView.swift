//
//  HomeView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isPlayerExpanded = false
    @Namespace private var animation
        
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                MusicView()
                    .tabItem {
                        Image(systemName: "music.note")
                        Text("Music")
                    }
                
                AnalyticView()
                    .tabItem {
                        Image(systemName: "moon.fill")
                        Text("Your Sleep")
                    }
            }
            .onAppear {
                UITabBar.appearance().isTranslucent = false
                UITabBar.appearance().barTintColor = UIColor(Color("BackgroundAppColor"))
            }
            
            PlayerView(animation: animation, isPlayerExpanded: $isPlayerExpanded)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
