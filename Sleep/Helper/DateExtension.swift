//
//  DateExtension.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 23/06/22.
//

import Foundation

extension Date {
    func convertDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "id")
        formatter.dateFormat = "EEEE, dd MMMM yyyy - HH:mm"
        return formatter.string(from: self)
    }
    
    func getDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}

extension DateComponentsFormatter {
    static let positional: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}
