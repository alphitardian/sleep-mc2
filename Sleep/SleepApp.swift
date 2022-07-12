//
//  SleepApp.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 20/06/22.
//

import SwiftUI
import AVKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default,
                options: [.defaultToSpeaker, .allowAirPlay]
            )
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
}

@main
struct SleepApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
