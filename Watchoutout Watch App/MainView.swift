//
//  HapticView 2.swift
//  Watchout
//
//  Created by 나현흠 on 7/8/25.
//

import SwiftUI

struct MainView: View {
    @State private var hapticTimer: Timer?
    @State private var lastTapTime: Date? = nil
    @Binding var bpm: Int
    var body: some View {
        VStack {
            Text("햅틱, 플래시")
            HStack{
                Button("-"){
                    bpm -= 10
                    if hapticTimer != nil {
                        startHaptics()
                    }
                }
                Text("\(bpm)")
                Button("+"){
                    bpm += 10
                    if hapticTimer != nil {
                        startHaptics()
                    }
                }
            }
//            Button(hapticTimer == nil ? "Start Haptics" : "Stop Haptics") {
//                let now = Date()
//                if hapticTimer == nil {
//                    startHaptics()
//                } else {
//                    if let last = lastTapTime, now.timeIntervalSince(last) < 1.0 {
//                        hapticTimer?.invalidate()
//                        hapticTimer = nil
//                    }
//                }
//                lastTapTime = now
//            }
        }
        .padding()
    }
    func startHaptics() {
        hapticTimer?.invalidate()
        let interval = 60.0 / Double(bpm)
        hapticTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            WKInterfaceDevice.current().play(.directionUp)
        }
    }
}

#Preview {
    MainView(bpm: .constant(120))
}
