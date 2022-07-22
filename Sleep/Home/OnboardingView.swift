//
//  OnboardingView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 21/07/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack {
            Color("BackgroundAppColor")
                .ignoresSafeArea()
            Image("BackgroundAppTexture")
                .resizable()
                .ignoresSafeArea()
            VStack {
                TabView(selection: $selectedIndex) {
                    OnboardingFirstItem().tag(0)
                    OnboardingSecondItem().tag(1)
                    OnboardingThirdItem().tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: UIScreen.main.bounds.height / 1.3)
                
                OnboardingButton(selectedIndex: $selectedIndex) {
                    if selectedIndex == 2 {
                        UserDefaults.standard.set(true, forKey: "Session")
                        dismiss()
                    } else {
                        withAnimation {
                            selectedIndex += 1
                        }
                    }
                }
                
                if selectedIndex != 2 {
                    Button {
                        withAnimation {
                            selectedIndex = 2
                        }
                    } label: {
                        Text("Skip")
                            .foregroundColor(.white)
                            .font(.callout)
                    }
                    .padding(.top)
                    Spacer()
                } else {
                    Spacer()
                }
            }
        }
    }
}

struct OnboardingFirstItem: View {
    
    var body: some View {
        VStack {
            Spacer()
            Image("onboardingPage1")
            Spacer()
            Group {
                Text("Backed by ") +
                Text("science")
                    .bold() +
                Text(", Sleepify helps you achieve a quality sleep with the help of sound")
            }
            .font(.title2)
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .padding(.trailing, 18)
        }
        .padding()
        .background(Color("BackgroundAppColor").cornerRadius(10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
        )
        .frame(
            width: UIScreen.main.bounds.width / 1.25,
            height: UIScreen.main.bounds.height / 1.55
        )
    }
}

struct OnboardingSecondItem: View {
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("For Better Experience")
                .font(.title2)
            Spacer()
            HStack {
                Image(systemName: "cable.connector.horizontal")
                    .font(.title3)
                    .padding(.trailing)
                Text("Charge your phone")
                    .font(.callout)
            }
            .padding(.top)
            HStack {
                Image(systemName: "airplayaudio")
                    .font(.title3)
                    .padding(.trailing)
                    .padding(.leading, 6)
                Text("Connect with external speaker")
                    .font(.callout)
            }
            .padding(.top)
            HStack {
                Image(systemName: "wave.3.right")
                    .font(.title3)
                    .padding(.trailing)
                    .padding(.leading, 10)
                Text("Adjust the volume")
                    .font(.callout)
            }
            .padding(.top)
            Spacer()
            HStack { Spacer() }
        }
        .padding()
        .padding(.leading, 6)
        .foregroundColor(.white)
        .background(Color("BackgroundAppColor").cornerRadius(10))
        .frame(
            width: UIScreen.main.bounds.width / 1.25,
            height: UIScreen.main.bounds.height / 1.55
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
        )
    }
}

struct OnboardingThirdItem: View {
    var body: some View {
        VStack {
            Spacer()
            Image("onboardingPage3")
            Spacer()
            Text("Please prepare yourself ready for a deep sleep.")
                .font(.title2)
                .multilineTextAlignment(.leading)
                .padding(.trailing, UIScreen.main.bounds.width / 4)
                .padding(.bottom, 36)
            HStack { Spacer() }
        }
        .padding()
        .padding(.leading, 6)
        .foregroundColor(.white)
        .background(Color("BackgroundAppColor").cornerRadius(10))
        .frame(
            width: UIScreen.main.bounds.width / 1.25,
            height: UIScreen.main.bounds.height / 1.55
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.white, lineWidth: 1)
        )
    }
}

struct OnboardingButton: View {
    
    @Binding var selectedIndex: Int
    var onButtonClicked: () -> Void
    
    var body: some View {
        Button {
            onButtonClicked()
        } label: {
            Text(selectedIndex == 2 ? "Get Started" : "Next")
                .foregroundColor(selectedIndex == 2 ? Color.black : Color.white)
                .font(.callout)
                .frame(width: UIScreen.main.bounds.width / 1.35, height: 45)
                .background(
                    Group {
                        selectedIndex == 2 ? Color.white : Color("BackgroundAppColor")
                    }.cornerRadius(10)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 1)
                )
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
        OnboardingFirstItem()
        OnboardingSecondItem()
        OnboardingThirdItem()
        OnboardingButton(selectedIndex: .constant(1)) {}
            .previewLayout(.fixed(width: 300.0, height: 100))
    }
}
