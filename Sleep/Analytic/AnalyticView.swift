//
//  AnalyticView.swift
//  Sleep
//
//  Created by Avian Lukman Setya Budi on 22/06/22.
//

import SwiftUI

struct AnalyticView: View {
    
    @StateObject private var analyticViewModel = AnalyticViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundAppColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        GradientText(text: "Your Sleepiest Day of the Week")
                        
                        SummaryView()
                            .padding(.bottom)
                        
                        GradientText(text: "Weekly Activity")
                        
                        Text("You slept an average of \(analyticViewModel.getSleepAverage()) over the last \(analyticViewModel.sleepData.count) days.")
                            .font(.caption)
                            .foregroundColor(Color("SecondaryTextColor"))
                        
                        ChartView(viewModel: analyticViewModel)
                            .padding(.bottom)
                        
                        GradientText(text: "Most Played Sessions")
                        
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
                    .padding(.horizontal)
                }
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
        .onAppear {
            analyticViewModel.getHealthKitAuthentication { success in
                if success {
                    analyticViewModel.getSleepData()
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

struct GradientText: View {
    
    var text: String = ""
    
    var body: some View {
        Text(text)
            .bold()
            .font(.title)
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
    
    @ObservedObject var viewModel: AnalyticViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Chart
            HStack(spacing: 24) {
                ForEach(0..<7) { day in
                    let chartDay = day >= viewModel.sleepData.count ? "Day" : viewModel.sleepData[day].startDate.getDay()
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color("ChartBackgroundColor"))
                            .frame(width: 16, height: 120)
                            .cornerRadius(8)
                        
                        Text(chartDay)
                            .font(.footnote)
                    }
                }
            }
            .padding(.vertical)
            
            // Value Chart
            HStack(spacing: 24) {
                ForEach(0..<7) { day in
                    let chartHeight = day >= viewModel.sleepData.count ? 0 : viewModel.calculateChartValue(text: viewModel.sleepData[day].hours)
                    let chartDay = day >= viewModel.sleepData.count ? "Day" : viewModel.sleepData[day].startDate.getDay()
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 16, height: chartHeight >= 120 ? 120 : chartHeight)
                            .cornerRadius(8)
                            .overlay {
                                LinearGradient(
                                    colors: [Color("GradientTextColor"), .purple],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .mask {
                                    Rectangle()
                                        .frame(width: 16, height: chartHeight >= 120 ? 120 : chartHeight)
                                        .cornerRadius(8)
                                }
                            }
                        
                        Text(chartDay)
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
