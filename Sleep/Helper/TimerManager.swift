//
//  TimerManager.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 20/07/22.
//

import Foundation

enum TimerMode {
    case running
    case stopped
}

class TimerManager: ObservableObject {
    
    static let sharedInstance = TimerManager()
    
    @Published var secondsElapsed: TimeInterval = 0.0
    @Published var mode: TimerMode = .stopped
    private var timer = Timer()
    
    func start(count: Double, onTimerChange: @escaping () -> Void) {
        secondsElapsed = count
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsElapsed -= 1
            onTimerChange()
        }
    }
    
    func stop() {
        timer.invalidate()
        mode = .stopped
    }
}
