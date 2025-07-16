//
//  ContentView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/7/25.
//

import SwiftUI
import WatchKit

struct SpeedContentView: View {
    @State var bpm = 120
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(bpm: $bpm)
                .tag(0)
            HapticView(bpm: $bpm)
                .tag(1)
            FlashView(bpm: $bpm)
                .tag(2)
            SoundView(bpm: $bpm)
                .tag(3)
            MotionView()
                .tag(4)
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    SpeedContentView()
}
