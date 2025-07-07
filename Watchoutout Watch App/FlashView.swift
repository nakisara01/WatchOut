//
//  FlashView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/8/25.
//

import SwiftUI

struct FlashView: View {
    @Binding var bpm: Int
    @State private var isFlashing = false
    @State private var showGreen = false
    @State private var timer: Timer? = nil
    @State private var lastTapTime: Date? = nil
    
    var body: some View {
        ZStack {
            if showGreen {
                Color.green
                    .ignoresSafeArea()
            }
            
            Button(isFlashing ? "Stop Flash" : "Flash") {
                let now = Date()
                if !isFlashing {
                    isFlashing = true
                    let interval = 60.0 / Double(bpm)
                    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                        showGreen = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showGreen = false
                        }
                    }
                } else {
                    if let last = lastTapTime, now.timeIntervalSince(last) < 1.0 {
                        timer?.invalidate()
                        timer = nil
                        isFlashing = false
                        showGreen = false
                    }
                }
                lastTapTime = now
            }
        }
    }
}

#Preview {
    FlashView(bpm: .constant(120))
}
