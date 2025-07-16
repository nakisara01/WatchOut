//
//  CountdownView.swift
//  PracticeCoreMotion
//
//  Created by 이현주 on 7/14/25.
//

import SwiftUI

struct CountdownView: View {
    let startTime: Date
    @Binding var isCountdownDone: Bool
    @State var now: Date = Date()
    
    var countdown: Int {
        max(0, Int(ceil(startTime.timeIntervalSince(now))))
    }
    
    var body: some View {
        Text("\(countdown)")
            .font(.system(size: 40))
            .foregroundColor(.white)
            .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { time in
                now = time
                if countdown <= 0 {
                    isCountdownDone = true
                }
            }
    }
}
