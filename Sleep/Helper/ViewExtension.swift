//
//  ViewExtension.swift
//  Sleep
//
//  Created by Ardian Pramudya Alphita on 12/07/22.
//

import SwiftUI

extension UIScreen {
    
    static func setBrightness(
        from startValue: CGFloat,
        to value: CGFloat,
        duration: TimeInterval = 0.3,
        ticksPerSecond: Double = 120
    ) {
        let delta = value - startValue
        let totalTicks = Int(ticksPerSecond * duration)
        let changePerTick = delta / CGFloat(totalTicks)
        let delayBetweenTicks = 1 / ticksPerSecond
        
        for i in 1...totalTicks {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBetweenTicks * Double(i)) {
                UIScreen.main.brightness = startValue + (changePerTick * CGFloat(i))
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
