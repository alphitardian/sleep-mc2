//
//  MusicView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct MusicView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading){
                        Text("Sleeping with Nature")
                            .bold()
                            .font(.title2)
                        Text("in bed")
                    }.padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                HighlightCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                            }
                        }
                        .padding()
                    }
                    Divider() .frame(height: 2) .background(.gray) .padding()
                    
                    VStack(alignment: .leading){
                        Text("Sleeping with Nature")
                            .bold()
                            .font(.title2)
                        Text("in forest")
                    }.padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                NormalCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                                
                            }
                        }
                        .padding()
                    }
                    Divider() .frame(height: 2) .background(.gray) .padding()
                    
                    VStack(alignment: .leading){
                        Text("5 Mins Session")
                            .bold()
                            .font(.title2)
                        Text("no sleep")
                    }.padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                NormalCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                            }
                        }
                        .padding()
                    }
                    Divider() .frame(height: 2) .background(.gray) .padding()
                    
                }
            } .navigationTitle("Session")
        }
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView()
    }
}

struct HighlightCollectionView: View {
    
    var text = ""
    var img = ""
    var body: some View {
        VStack{
            Image(img)
                .resizable()
                .scaledToFill()
                .frame(width:350, height:200)
                .cornerRadius(20)
            Text(text)
        }
    }
}

struct NormalCollectionView: View {
    
    var text = ""
    var img = ""
    var body: some View {
        VStack{
            Image(img)
                .resizable()
                .scaledToFill()
                .frame(width:100, height:100)
                .cornerRadius(20)
            Text(text)
        }
    }
}
