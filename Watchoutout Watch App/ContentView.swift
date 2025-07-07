//
//  ContentView.swift
//  Watchoutout Watch App
//
//  Created by 나현흠 on 7/7/25.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var bpm: Int = 120
    var body: some View {
        TabView {
            HapticView()
            FlashView(bpm: $bpm)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
}
