//
//  AnalyticViewModel.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 23/06/22.
//

import Foundation

class AnalyticViewModel: ObservableObject {
    
    @Published private(set) var sleepData = [SleepActivity]()
    
    private var healthStore = HealthStore()
    
    func getHealthKitAuthentication(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(completion: completion)
    }
    
    func getSleepData() {
        DispatchQueue.main.async {
            self.healthStore.retrieveSleep { data in
                self.sleepData = data
            }
        }
    }
    
    func calculateChartValue(text: String) -> Double {
        let textDouble = Double(text.split(separator: " ")[0])!
        let chartMaxHeight = 120.0
        let recommendedSleepHour = 8.0
        let result = (textDouble * chartMaxHeight) / recommendedSleepHour
        return result
    }
    
    func getSleepAverage() -> String {
        var totalTimeInterval: Double = 0.0
        
        for data in sleepData {
            totalTimeInterval += data.endDate.timeIntervalSince(data.startDate)
        }
        
        let average = totalTimeInterval / Double(sleepData.count)
        return average.stringFromTimeInterval()
    }
}
