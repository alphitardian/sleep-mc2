//
//  HomeView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 21/06/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
        VStack
        {
            HStack
            {
                NavigationLink (destination: MusicView())
                {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    
                }
                Button("Asu")
                {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
            }
            Text("ges")
        }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct MusicView: View {
    var body: some View {
        Text("Music")
    }
}
