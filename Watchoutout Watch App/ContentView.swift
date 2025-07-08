//
//  ContentView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/7/25.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @State var bpm = 120
    @State private var selectedTab = 1
    var body: some View {
        TabView(selection: $selectedTab) {
            HapticView(bpm: $bpm)
                .tag(0)
            MainView(bpm: $bpm)
                .tag(1)
            FlashView(bpm: $bpm)
                .tag(2)
            SoundView(bpm: $bpm)
                .tag(3)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
}
