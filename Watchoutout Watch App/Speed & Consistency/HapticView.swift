//
//  MainView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/8/25.
//

import SwiftUI

struct HapticView: View {
    enum HapticMode: String, CaseIterable {
        case click = "작은 햅틱"
        case failure = "강한 햅틱"
        case success = "성공 햅틱"
        case retry = "경고 햅틱"

        var style: WKHapticType {
            switch self {
            case .click: return .click
            case .failure: return .failure
            case .success: return .success
            case .retry: return .retry
            }
        }
    }

    @State private var hapticTimer: Timer?
    @State private var currentMode: HapticMode? = nil
    @Binding var bpm: Int
    var body: some View {
        VStack {
            HStack{
                Text("BPM: \(bpm)")
            }
            List {
                ForEach([HapticMode.click, .failure, .success, .retry], id: \.self) { mode in
                    Button(currentMode == mode ? "\(mode.rawValue) 멈추기" : "\(mode.rawValue) 시작") {
                        if currentMode != mode {
                            startHaptics(style: mode.style)
                            currentMode = mode
                        } else {
                            hapticTimer?.invalidate()
                            hapticTimer = nil
                            currentMode = nil
                        }
                    }
                }
            }
            .listStyle(.carousel)
        }
        .padding()
    }
    func startHaptics(style: WKHapticType) {
        hapticTimer?.invalidate()
        let interval = 60.0 / Double(bpm)
        hapticTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            WKInterfaceDevice.current().play(style)
        }
    }
}

#Preview {
    HapticView(bpm: .constant(120))
}
