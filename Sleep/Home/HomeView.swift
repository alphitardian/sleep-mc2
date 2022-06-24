//
//  HomeView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
