//
//  PlayingListView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 28/06/22.
//

import SwiftUI

struct PlayingListView: View {
    
    @ObservedObject var musicViewModel: MusicViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(musicViewModel.selectedMusic?.imageName ?? "")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .cornerRadius(12.0)
                    .shadow(color: .black, radius: 6.0)
                
                VStack(alignment: .leading) {
                    Text(musicViewModel.selectedMusic?.title ?? "Unknown")
                        .bold()
                        .font(.subheadline)
                    Text(musicViewModel.selectedMusic?.category ?? "Unknown")
                        .font(.caption)
                        .foregroundColor(Color("SecondaryTextColor"))
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.bottom)
            
            Text("Playing Next")
                .bold()
                .font(.subheadline)
            Text("From 1 Hour Session")
                .font(.caption)
                .foregroundColor(Color("SecondaryTextColor"))
                .padding(.bottom)
            
            List {
                ForEach(0..<Int(musicViewModel.queueMusic.count), id: \.self) { index in
                    let music = musicViewModel.queueMusic[index]
                    DragableListTile(music: music)
                        .padding(.bottom)
                        .listRowBackground(Color("BackgroundAppColor"))
                        .onTapGesture {
                            musicViewModel.setSelectedMusic(music: music)
                            musicViewModel.refreshQueue()
                            musicViewModel.playMusic()
                        }
                }
                .onMove { fromOffset, toOffset in
                    musicViewModel.musicData.move(fromOffsets: fromOffset, toOffset: toOffset)
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .padding(.horizontal, -20)
            .frame(maxHeight: 400)
        }
        .padding()
    }
}

struct PlayingListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingListView(musicViewModel: MusicViewModel())
            .preferredColorScheme(.dark)
    }
}

struct DragableListTile: View {
    
    var music: Music
    
    var body: some View {
        HStack {
            Image(music.imageName)
                .resizable()
                .frame(width: 64, height: 64)
                .cornerRadius(12.0)
                .shadow(color: .black, radius: 6.0)
            
            VStack(alignment: .leading) {
                Text(music.title)
                    .bold()
                    .font(.subheadline)
                Text(music.category)
                    .font(.caption)
                    .foregroundColor(Color("SecondaryTextColor"))
            }
            .padding(.horizontal)
            
            Spacer()
            
            Image(systemName: "line.3.horizontal")
        }
    }
}
