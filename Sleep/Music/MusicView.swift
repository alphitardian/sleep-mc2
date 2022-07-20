//
//  MusicView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct MusicView: View {
    
    @State var showModal = false
    @ObservedObject var musicViewModel: MusicViewModel
    var onMusicSelected: () -> Void
    
    var body: some View {
            HorizontalListView(musicViewModel: musicViewModel, onMusicSelected: onMusicSelected)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(musicViewModel: MusicViewModel(), onMusicSelected: {})
            .environment(\.colorScheme, .dark)
    }
}

struct HorizontalListView: View {
    
    @ObservedObject var musicViewModel: MusicViewModel
    var onMusicSelected: () -> Void
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 24) {
                ForEach(0..<Int(musicViewModel.musicData.count), id:\.self) { index in
                    let music = musicViewModel.musicData[index]
                    HighlightCollectionView(
                        session: "\(music.length) Session",
                        text: music.title,
                        img: music.imageName
                    )
                    .onTapGesture {
                        musicViewModel.setSelectedMusic(music: music)
                        musicViewModel.refreshQueue()
                        musicViewModel.playMusic()
                        onMusicSelected()
                    }
                }
            }
            .padding(.leading, 36)
        }
    }
}

struct HighlightCollectionView: View {
    
    var session = ""
    var text = ""
    var img = ""
    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                Image(img)
                    .resizable()
                    .scaledToFill()
                    .frame(width:285, height:580)
                    .cornerRadius(10)
                
                
                
                HStack {
                    Text(text)
                        .font(.title)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                        .shadow(color: .black, radius: 2, x: 0, y: 0)
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "play")
                            .foregroundColor(.white)
                            .padding()
                            .overlay {
                                RoundedRectangle (cornerRadius: 50)
                                    .stroke(.white, lineWidth: 1)
                            }
                    }
                }
                
                .padding()
                .background(.black)
                .overlay {
                    RoundedRectangle (cornerRadius: 10)
                        .stroke(.white, lineWidth: 1)
                }
            }
            .overlay {
                RoundedRectangle (cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            }
        }
    }
}

struct NormalCollectionView: View {
    
    var title = ""
    var session = ""
    var img = ""
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(img)
                .resizable()
                .cornerRadius(6)
                .frame(width:141, height:141)
            
            Text(title)
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
            
            
            Text(session)
                .foregroundColor(.white)
                .font(.caption2)
                .offset(x: 60, y: 60)
                .shadow(color: .black, radius: 2, x: 0, y: 0)
        }
        .frame(width:141, height:141)
    }
}

