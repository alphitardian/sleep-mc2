//
//  HealthStore.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 23/06/22.
//

import Foundation
import HealthKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        healthStore.requestAuthorization(toShare: [], read: [sleepAnalysis]) { success, error in
            completion(success)
        }
    }
    
    func retrieveSleep(completion: @escaping ([SleepActivity]) -> Void) {
        let sleepAnalysis = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        
        // use sortDescriptor to get recent data first
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(
            sampleType: sleepAnalysis,
            predicate: nil,
            limit: 10000,
            sortDescriptors: [sortDescriptor]
        ) { query, results, error in
            
            // Error handling
            if error != nil {
                print("Error: " + error!.localizedDescription)
            }
            
            if let results = results {
                
                var queryResult = [SleepActivity]()
                
                for item in results {
                    if let sample = item as? HKCategorySample {
                        let value = (sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue) ? "InBed" : "Asleep"
                        
                        if value == "InBed" {
                            print("Healthkit sleep: \(sample.startDate.convertDate()) \(sample.endDate.convertDate()) - value: \(value)")
                            print("How long you sleep: \(sample.endDate.timeIntervalSince(sample.startDate).stringFromTimeInterval())")
                            
                            let activity = SleepActivity(
                                startDate: sample.startDate,
                                endDate: sample.endDate,
                                hours: sample.endDate.timeIntervalSince(sample.startDate).stringFromTimeInterval()
                            )
                            queryResult.append(activity)
                        }
                    }
                }
                
                completion(queryResult)
            }
        }
        
        healthStore?.execute(query)
    }
    
}
