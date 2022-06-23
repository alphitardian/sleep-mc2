//
//  AnalyticView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct AnalyticView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundAppColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Your Sleepiest Day of the Week")
                            .bold()
                            .font(.title)
                            .overlay {
                                LinearGradient(
                                    colors: [Color("GradientTextColor"), .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask {
                                    Text("Your Sleepiest Day of the Week")
                                        .bold()
                                        .font(.title)
                                }
                            }
                        
                        SummaryView()
                            .padding(.bottom)
                        
                        Text("Weekly Activity")
                            .bold()
                            .font(.title)
                            .overlay {
                                LinearGradient(
                                    colors: [Color("GradientTextColor"), .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask {
                                    Text("Weekly Activity")
                                        .bold()
                                        .font(.title)
                                }
                            }
                        
                        Text("You slept an average of 7 hr 23 min over the last 7 days.")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                        
                        ChartView()
                            .padding(.bottom)
                        
                        Text("Most Played Sessions")
                            .bold()
                            .font(.title)
                            .overlay {
                                LinearGradient(
                                    colors: [Color("GradientTextColor"), .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .mask {
                                    Text("Most Played Sessions")
                                        .bold()
                                        .font(.title)
                                }
                            }
                        
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
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Your Sleep")
            .toolbar {
                Button {
                    // Share Function
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

struct AnalyticView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticView()
            .environment(\.colorScheme, .dark)
    }
}

struct SummaryView: View {
    
    var body: some View {
        ZStack {
            HStack {
                Image("CollectionView0")
                    .resizable()
                    .frame(width: 147, height: 147)
                    .cornerRadius(14.0)
                
                VStack(alignment: .leading) {
                    Text("Dreamy Vibes - Hypnotic bliss")
                        .bold()
                        .font(.callout)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .padding(.bottom, 2)
                    
                    Text("1 Hour".uppercased())
                        .font(.caption)
                        .foregroundColor(Color("SecondaryTextColor"))
                        .padding(.bottom, 2)
                    
                    Group {
                        Text("You slept through this session on ")
                            .foregroundColor(.white) +
                        Text("Wednesday ")
                            .bold()
                            .foregroundColor(.red) +
                        Text("for a total of ")
                            .foregroundColor(.white) +
                        Text("8 hours of 24 mins.")
                            .bold()
                            .foregroundColor(.red)
                    }
                    .font(.footnote)
                }
            }
            .padding()
        }
        .frame(width: 360, height: 187)
        .background(Color("CardColor").opacity(0.2))
        .cornerRadius(14.0)
    }
}

struct ChartView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Chart
            HStack(spacing: 24) {
                ForEach(0..<7) { day in
                    VStack {
                        Rectangle()
                            .fill(Color("ChartBackgroundColor"))
                            .frame(width: 16, height: 120)
                            .cornerRadius(8)
                        
                        Text("Day")
                            .font(.footnote)
                    }
                }
            }
            .padding(.vertical)
            
            // Value Chart
            HStack(spacing: 24) {
                ForEach(0..<7) { day in
                    VStack {
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: 16, height: 80)
                            .cornerRadius(8)
                        
                        Text("Day")
                            .font(.footnote)
                    }
                }
            }
            .padding(.vertical)
        }
        .frame(width: 360, height: 187)
        .background(Color("CardColor").opacity(0.2))
        .cornerRadius(14.0)
    }
}
