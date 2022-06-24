//
//  TimeIntervalExtension.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 23/06/22.
//

import Foundation

extension TimeInterval{

    func stringFromTimeInterval() -> String {
        if !(self.isNaN || self.isInfinite) {
            let time = NSInteger(self)

            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2d hr %0.2d min",hours,minutes)
        } else {
            return "NaN"
        }

    }
}
