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
        NavigationView {
            ZStack {
                Color("BackgroundAppColor").ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading){
                            Text("Ready To Fall Asleep?")
                                .bold()
                                .font(.title3)
                                .foregroundColor(.white)
                            Text("Fall into the sweetest dream with these new sonic experiences")
                                .font(.caption)
                        }.padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<Int(musicViewModel.musicData.count), id:\.self) { index in
                                    let music = musicViewModel.musicData[index]
                                    HighlightCollectionView(
                                        session: "\(music.length) Session",
                                        text: music.title,
                                        img: music.imageName
                                    )
                                    .onTapGesture {
                                        musicViewModel.setSelectedMusic(music: music, index: index)
                                        musicViewModel.playMusic()
                                        onMusicSelected()
                                    }
                                }
                            }
                            .padding()
                        }
                        Divider()
                            .frame(height: 1)
                            .background(.gray.opacity(0.2))
                            .padding(.bottom)
                        
                        Text("Sleeping with Nature")
                            .bold()
                            .font(.title3)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<Int(musicViewModel.musicData.count), id:\.self) { index in
                                    let music = musicViewModel.musicData[index]
                                    NormalCollectionView(
                                        title: music.title,
                                        session: "\(music.length) Session",
                                        img: music.imageName
                                    )
                                    .onTapGesture {
                                        musicViewModel.setSelectedMusic(music: music, index: index)
                                        musicViewModel.playMusic()
                                        onMusicSelected()
                                    }
                                }
                            }
                            .padding(.leading)
                        }
                        Divider()
                            .frame(height: 1)
                            .background(.gray.opacity(0.2))
                            .padding(.vertical)
                        
                        Text("5 Mins Session")
                            .bold()
                            .font(.title3)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(0..<5) {i in
                                    NormalCollectionView(
                                        title:"Deep In The Sea",
                                        session: "1 Hour Session",
                                        img: "CollectionView\(i)"
                                    )
                                }
                            }
                            .padding(.leading)
                        }
                        Divider()
                            .frame(height: 1)
                            .background(.gray.opacity(0.2))
                            .padding(.top, 16)
                            .padding(.bottom, 64)
                        
                    }
                }
            }
            .sheetWithDetents(isPresented: $showModal, detents: [.medium()], onDismiss: nil) {
                ScheduleView(showModal: $showModal)
            }
            .navigationTitle("Session")
            .toolbar {
                Button {
                    showModal.toggle()
                } label: {
                    Image(systemName: "clock")
                }
            }
        }
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(musicViewModel: MusicViewModel(), onMusicSelected: {})
            .environment(\.colorScheme, .dark)
    }
}

struct HighlightCollectionView: View {
    
    var session = ""
    var text = ""
    var img = ""
    var body: some View {
        VStack{
            ZStack(alignment: .leading) {
                Image(img)
                    .resizable()
                    .scaledToFill()
                    .frame(width:342, height:223)
                    .cornerRadius(25)
                
                Text(text)
                    .bold()
                    .font(.system(size: 41))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, -42)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .frame(width: 224)
                
                Text(session)
                    .foregroundColor(.white)
                    .offset(x: 210, y: 90)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
            }
            Text(text)
                .font(.caption)
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
