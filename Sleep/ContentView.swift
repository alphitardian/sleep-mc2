//
//  ContentView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 20/06/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView() .environment(\.colorScheme, .dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
