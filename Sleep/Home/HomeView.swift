//
//  HomeView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var isPlayerExpanded = false
    @State var isChangeListToggle = false
    @State private var searchText = ""
    @Namespace private var animation
    
    @StateObject private var musicViewModel = MusicViewModel()
    
    var filteredMusic: [Music] {
        if searchText.isEmpty {
            return musicViewModel.musicData
        } else {
            return musicViewModel.musicData.filter { music in
                music.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                ZStack {
                    Color("BackgroundAppColor")
                        .ignoresSafeArea()
                    Image("BackgroundAppTexture")
                        .resizable()
                        .ignoresSafeArea()
                    VStack {
                        Text("Soundscapes")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.heavy)
                        SearchBar(searchText: $searchText)
                        MusicView(
                            animation: animation,
                            musicViewModel: musicViewModel,
                            isChangeListToggle: $isChangeListToggle,
                            filteredMusic: filteredMusic
                        ) {
                            withAnimation {
                                isPlayerExpanded.toggle()
                                UIScreen.setBrightness(
                                    from: Constants.currentBrightness,
                                    to: 0.0,
                                    duration: 0.25
                                )
                            }
                        }
                        Spacer()
                    }
                }
                .accentColor(.purple)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        withAnimation {
                            isChangeListToggle.toggle()
                        }
                    } label: {
                        Image(systemName: isChangeListToggle ? "rectangle.stack" : "rectangle.grid.2x2")
                            .foregroundColor(.white)
                    }
                }
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

struct SearchBar: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray.opacity(0.75))
            TextField("Search", text: $searchText)
        }
        .padding()
        .frame(height: 42)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.colorScheme, .dark)
    }
}
