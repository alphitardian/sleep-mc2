//
//  OnboardingView.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 21/07/22.
//

import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedIndex = 1
    
    var body: some View {
        ZStack {
            Color("BackgroundAppColor")
                .ignoresSafeArea()
            Image("BackgroundAppTexture")
                .resizable()
                .ignoresSafeArea()
            VStack {
                TabView(selection: $selectedIndex) {
                    OnboardingItem().tag(1)
                    OnboardingItem().tag(2)
                    OnboardingItem().tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: UIScreen.main.bounds.height / 1.3)
                OnboardingButton(selectedIndex: $selectedIndex) {
                    if selectedIndex == 3 {
                        dismiss()
                    } else {
                        withAnimation {
                            selectedIndex += 1
                        }
                    }
                }
                
                if selectedIndex != 3 {
                    Button {
                        withAnimation {
                            selectedIndex = 3
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

struct OnboardingItem: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("Backed by science, Sleepify helps you achieve a quality sleep with the help of sound")
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color("BackgroundAppColor"))
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

struct OnboardingButton: View {
    
    @Binding var selectedIndex: Int
    var onButtonClicked: () -> Void
    
    var body: some View {
        Button {
            onButtonClicked()
        } label: {
            Text(selectedIndex == 3 ? "Get Started" : "Next")
                .foregroundColor(selectedIndex == 3 ? Color.black : Color.white)
                .font(.callout)
                .frame(width: UIScreen.main.bounds.width / 1.35, height: 45)
                .background(
                    Group {
                        selectedIndex == 3 ? Color.white : Color("BackgroundAppColor")
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
        OnboardingButton(selectedIndex: .constant(1)) {}
    }
}
