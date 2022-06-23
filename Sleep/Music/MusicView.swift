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
                            .font(.title3)
                        Text("in bed")
                            .font(.caption)
                    }.padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                HighlightCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                            }
                        }
                        .padding()
                    }
                    Divider()
                        .frame(height: 1)
                        .background(.gray)
                        .padding()
                    
                    Text("Sleeping with Nature")
                        .bold()
                        .font(.title3)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                NormalCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                                
                            }
                        }
                        .padding(.leading)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(.gray)
                        .padding()
                    
                    Text("5 Mins Session")
                        .bold()
                        .font(.title3)
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) {i in
                                NormalCollectionView(text:"song\(i)", img: "CollectionView\(i)")
                            }
                        }
                        .padding(.leading)
                    }
                    Divider()
                        .frame(height: 1)
                        .background(.gray)
                        .padding()
                    
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
                .frame(width:342, height:223)
                .cornerRadius(25)
            Text(text)
                .font(.caption)
        }
    }
}

struct NormalCollectionView: View {
    
    var text = ""
    var img = ""
    var body: some View {
        ZStack(alignment: .leading) {
            Image(img)
                .resizable()
                .cornerRadius(6)
                .frame(width:141, height:141)
            
            VStack {
                Spacer()
                
                Text("Deep In The Sea")
                    .bold()
                    .font(.title2)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 8)
                
                Spacer()
            }
            
            Text("1 Hour Session")
                .foregroundColor(.white)
                .font(.caption2)
                .offset(x: 60, y: 60)
        }
        .frame(width:141, height:141)
    }
}
